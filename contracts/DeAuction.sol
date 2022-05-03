pragma ton-solidity >=0.59.4;

import "./BidLocker.sol";
import "./Stake.sol";


enum DeAuctionStatus {
    FUNDING, WIN, LOSE
}


contract DeAuction is IDeAuction {

    address static _auction;
    address static _neverAggregator;
    address static _everAggregator;

    address neverLocker;
    address everLocker;

    TvmCell _stakeCode;
    bool stakeCodeSet = false;
    DeAuctionStatus status = DeAuctionStatus.FUNDING;

    modifier onlyOwner() {
        require(tvm.pubkey() != 0);
        require(tvm.pubkey() == msg.pubkey());
        _;
    }

    constructor() public onlyOwner {
        tvm.accept();
    }

    function newStake(uint256 nanonevers,
                      uint256 nanoevers,
                      bool isNever,
                      uint256 key) public override {
        require(stakeCodeSet);
        require(_getStakeAddress(key) == msg.sender, Errors.NOT_A_STAKE);

        tvm.accept();

        if (isNever) {
            IAggregator(_neverAggregator).addStake(nanonevers, nanoevers);
        } else {
            IAggregator(_everAggregator).addStake(nanonevers, nanoevers);
        }
    }

    function withdraw(uint256 nanonevers,
                      uint256 nanoevers,
                      bool isNever,
                      uint256 key) public override {
        require(status != DeAuctionStatus.FUNDING);
        require(_getStakeAddress(key) == msg.sender, Errors.NOT_A_STAKE);

        if (isNever && (status == DeAuctionStatus.WIN) || !isNever && (status == DeAuctionStatus.LOSE)) {
            msg.sender.transfer({value: uint128(nanoevers), bounce: false, flag: 1});
        } else {
            ExtraCurrencyCollection c;
            c[Constants.NEVER_ID] = nanonevers;
            msg.sender.transfer({value: 0, bounce: false, flag: 1, currencies: c});
        }

    }

    function updateStatus(bool win) public onlyOwner {
        tvm.accept();
        if (win) {
            status = DeAuctionStatus.WIN;
        } else {
            status = DeAuctionStatus.LOSE;
        }
    }

    function setStakeCode(TvmCell code) public onlyOwner {
        require(!stakeCodeSet);
        tvm.accept();
        _stakeCode = code;
        stakeCodeSet = true;
    }

    function _getStakeAddress(uint256 pubkey) private inline view returns (address addr){
        TvmCell code = _stakeCode.toSlice().loadRef();
        TvmCell state = tvm.buildStateInit({
            contr: Stake,
            varInit: {
                deAuction: address(this)
            },
            pubkey: pubkey,
            code: code
        });
        addr = address.makeAddrStd(0, tvm.hash(state));
    }

}
