pragma ton-solidity >=0.59.4;

import "./lib/Interfaces.sol";
import "./lib/Lib.sol";


contract BidLocker is IBidLocker {

    uint256 static auctionAddrHash;
    uint256 static ownerAddrHash;
    uint256 static bidHash;

    //

    bool _never;            // does this bid lock nevers?

    bool _successfulReveal = false;

    bool locked;
    uint64 lockedTS;
    uint256 lockedBalance;

    address _owner;
    address _bank;

    //

    uint128 _operationsReserved = .5 ever;

    modifier onlyBank() {
        require(msg.sender == _bank, Errors.IS_NOT_BANK);
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, Errors.IS_NOT_LOCKER_OWNER);
        _;
    }


    constructor(bool never) public {
        require(tvm.pubkey() == msg.pubkey());
        require(tvm.pubkey() != 0);
        tvm.accept();

        _never = never;
    }

    function lock() public {
        require(tvm.pubkey() == msg.pubkey());
        tvm.accept();

        require(!locked, Errors.BID_ALREADY_LOCKED);

        require(address(this).balance > _operationsReserved, Errors.BALANCE_TOO_LOW);

        if (_never) {
            ExtraCurrencyCollection currencies = address(this).currencies;
            optional(uint256) nanonevers = currencies.fetch(Constants.NEVER_ID);
            require(nanonevers.hasValue(), Errors.NEVER_TOO_LOW);
            lockedBalance = nanonevers.get();
        } else {
            lockedBalance = address(this).balance - _operationsReserved;
        }

        lockedTS = now;
        locked = true;
    }

    function verify(address owner, address auction,
                    uint256 nanonevers, uint256 nanoevers, uint128 salt) public {

        require(tvm.pubkey() == msg.pubkey());
        require(!_successfulReveal);
        tvm.accept();

        TvmBuilder bidBuilder;
        bidBuilder.store(nanonevers, nanoevers, salt);
        TvmCell bidCell = bidBuilder.toCell();

        if (tvm.hash(bidCell) != bidHash) {
            return;
        }

        TvmBuilder ownerBuilder;
        ownerBuilder.store(owner, salt);
        TvmCell ownerCell = ownerBuilder.toCell();

        if (tvm.hash(ownerCell) != ownerAddrHash) {
            return;
        }

        TvmBuilder auctionBuilder;
        auctionBuilder.store(auction, salt);
        TvmCell auctionCell = auctionBuilder.toCell();

        if (tvm.hash(auctionCell) != auctionAddrHash) {
            return;
        }

        if (_never && lockedBalance < nanonevers || (!_never) && lockedBalance < nanoevers) {
            return;
        }

        _successfulReveal = true;
        _owner = owner;
        IAuction(auction).reveal(
            auctionAddrHash,
            ownerAddrHash,
            bidHash,
            tvm.pubkey(),
            lockedTS,
            nanonevers,
            nanoevers,
            _never
        );
    }

    function transfer(address dest) public view {
        require(tvm.pubkey() == msg.pubkey());
        require(_successfulReveal, Errors.FRAUD_REVEAL_FUNDS_LOCKED);
        tvm.accept();
        dest.transfer(0, false, 128);
    }

    // external
    function receiveWin() public view {
        require(tvm.pubkey() == msg.pubkey());
        tvm.accept();
        _receiveWin();
    }

    // internal (deAuction)
    function receiveWinInternal() public override onlyOwner {
        _receiveWin();
    }

    function _receiveWin() private inline view {
        if (_never) {
            INeverBank(_bank).payEvers();
        } else {
            INeverBank(_bank).payNevers();
        }
    }

}
