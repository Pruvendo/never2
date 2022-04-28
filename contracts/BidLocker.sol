pragma ton-solidity >=0.59.4;

import "./Interfaces.sol";
import "./Lib.sol";


contract BidLocker {

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
        require(msg.sender == _owner, Errors.IS_NOT_OWNER);
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
            optional(uint256) nevers = currencies.fetch(Constants.NEVER_ID);
            require(nevers.hasValue(), Errors.NEVER_TOO_LOW);
            lockedBalance = nevers.get();
        } else {
            lockedBalance = address(this).balance - _operationsReserved;
        }

        lockedTS = tx.timestamp;
        locked = true;
    }

    function verify(address owner, address auction,
                    uint256 nevers, uint256 evers, uint128 salt) public {

        require(tvm.pubkey() == msg.pubkey());
        tvm.accept();

        TvmBuilder bidBuilder;
        bidBuilder.store(nevers, evers, salt);
        TvmCell bidCell = bidBuilder.toCell();

        require(tvm.hash(bidCell) == bidHash, Errors.BAD_BID_HASH);

        TvmBuilder ownerBuilder;
        ownerBuilder.store(owner, salt);
        TvmCell ownerCell = ownerBuilder.toCell();

        require(tvm.hash(ownerCell) == ownerAddrHash, Errors.BAD_OWNER_HASH);

        TvmBuilder auctionBuilder;
        auctionBuilder.store(auction, salt);
        TvmCell auctionCell = auctionBuilder.toCell();

        require(tvm.hash(auctionCell) == auctionAddrHash, Errors.BAD_AUCTION_HASH);


        if (_never) {
            require(lockedBalance >= nevers, Errors.NEVER_TOO_LOW);
        } else {
            require(lockedBalance >= evers, Errors.BALANCE_TOO_LOW);
        }

        _successfulReveal = true;
        _owner = owner;
        IAuction(auction).reveal(auctionAddrHash, ownerAddrHash, bidHash, tvm.pubkey(), lockedTS, nevers, evers, _never);
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
    function receiveWinInternal() internal view onlyOwner {
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
