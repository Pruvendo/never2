pragma ton-solidity >=0.59.4;


import "./lib/Lib.sol";
import "./BidLocker.sol";
import "./Stake.sol";


enum DeAuctionStatus {
    FUNDING, BIDDING, WIN, LOSE
}


contract DeAuction is IDeAuction {

    address static _auction;


    address _neverAggregator;
    address _everAggregator;

    address neverLocker;
    uint128 _saltNever;
    address everLocker;
    uint128 _saltEver;

    Bid neverBid;
    Bid everBid;

    uint128 _lockerDeployValue = 1 ever;

    uint64 fundingDeadline;

    TvmCell _lockerCode;
    bool lockerCodeSet = false;

    TvmCell _stakeCode;
    bool stakeCodeSet = false;
    DeAuctionStatus status = DeAuctionStatus.FUNDING;

    modifier onlyOwner() {
        require(tvm.pubkey() != 0);
        require(tvm.pubkey() == msg.pubkey());
        _;
    }

    modifier onlyAggregator() {
        require(msg.sender == _neverAggregator || msg.sender == _everAggregator);
        _;
    }

    modifier onlyLocker() {
        require(msg.sender == neverLocker || msg.sender == everLocker);
        _;
    }

    modifier doUpdate() {
        _update();
        _;
    }

    constructor(uint128 saltEver, uint128 saltNever) public onlyOwner {
        require(saltEver != saltNever);
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

    function acceptAggregate(uint256 nanonevers,
                             uint256 nanoevers,
                             bool isNever) public onlyAggregator override {
        Bid bid = Bid(nanonevers, nanoevers, isNever);
        if (isNever) {
            neverBid = bid;
        } else {
            everBid = bid;
        }
    }

    function notifyWin(bool isNever) public onlyLocker view {
        if (isNever) {
            BidLocker(neverLocker).receiveWinInternal{value: .5 ever}();
        } else {
            BidLocker(everLocker).receiveWinInternal{value: .5 ever}();
        }
    }

    function updateStatus(bool win) public doUpdate onlyOwner {
        tvm.accept();
        if (win) {
            status = DeAuctionStatus.WIN;
        } else {
            status = DeAuctionStatus.LOSE;
        }
    }

    function _initBidding() private inline {
        _deployLocker(_saltNever, true);
        _deployLocker(_saltEver, false);
    }

    function _deployLocker(uint128 salt, bool isNever) private inline {
        (
            uint256 auctionAddrHash,
            uint256 ownerAddrHash,
            uint256 bidHash
        ) = _calcHashes(salt, isNever);

        TvmCell stateInit = _buildBidLockerStateInit(
            auctionAddrHash,
            ownerAddrHash,
            bidHash
        );
        address locker = new BidLocker{
            stateInit: stateInit,
            value: _lockerDeployValue
        }(isNever);

        if (isNever) {
            neverLocker = locker;
        } else {
            everLocker = locker;
        }
    }

    function _calcHashes(uint128 salt, bool isNever) private inline view returns (
            uint256 auctionAddrHash,
            uint256 ownerAddrHash,
            uint256 bidHash) {
    
        uint256 nanonevers;
        uint256 nanoevers;

        if (isNever) {
            nanonevers = neverBid.nanonevers;
            nanoevers = neverBid.nanoevers;
        } else {
            nanonevers = everBid.nanonevers;
            nanoevers = everBid.nanoevers;
        }

        TvmBuilder bidBuilder;
        bidBuilder.store(nanonevers, nanoevers, salt);
        TvmCell bidCell = bidBuilder.toCell();
        bidHash = tvm.hash(bidCell);

        TvmBuilder ownerBuilder;
        ownerBuilder.store(address(this), salt);
        TvmCell ownerCell = ownerBuilder.toCell();
        ownerAddrHash = tvm.hash(ownerCell);

        TvmBuilder auctionBuilder;
        auctionBuilder.store(_auction, salt);
        TvmCell auctionCell = auctionBuilder.toCell();
        auctionAddrHash = tvm.hash(auctionCell);

    }

    function _buildBidLockerStateInit(
        uint256 auctionAddrHash,
        uint256 ownerAddrHash,
        uint256 bidHash
    ) private inline view returns (TvmCell) {
        return tvm.buildStateInit({
            contr: BidLocker,
            varInit: {
                auctionAddrHash: auctionAddrHash,
                ownerAddrHash: ownerAddrHash,
                bidHash: bidHash
            },
            code: _lockerCode
        });
    }

    function _update() private inline {
        if (status == DeAuctionStatus.FUNDING && now > fundingDeadline) {
            status = DeAuctionStatus.BIDDING;
            _initBidding();
        }
    }

    function setAggregators(address neverAggregator,
                            address everAggregator) public onlyOwner {
        tvm.accept();
        _neverAggregator = neverAggregator;
        _everAggregator = everAggregator;
    }

    function setStakeCode(TvmCell code) public onlyOwner {
        require(!stakeCodeSet);
        tvm.accept();
        _stakeCode = code;
        stakeCodeSet = true;
    }

    function setLockerCode(TvmCell code) public onlyOwner {
        require(!lockerCodeSet);
        tvm.accept();
        _lockerCode = code;
        lockerCodeSet = true;
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
