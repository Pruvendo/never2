pragma ton-solidity >=0.59.4;

import "./BidLocker.sol";
import "./lib/Interfaces.sol";
import "./lib/Lib.sol";



contract BlindAuction is IAuction {

    address static _proxy;
    address static _bank;
    uint64 static _iteration;

    //

    Phase _phase;

    // selling ever >>
    address everFirst;
    Bid everFirstPrice;
    Bid everSecondPrice;
    // << selling never >>
    address neverFirst;
    Bid neverFirstPrice;
    Bid neverSecondPrice;
    // <<

    uint128 _USDToNanoever;   //  assumed as NEVER/NANOEVER

    uint256 _minNanoeverBid;
    uint256 _minNeverBid;

    uint64 openTS;
    uint64 revealStartTS;
    uint64 _openDuration;
    uint64 _revealDuration;
    uint64 _closeTS;

    address _owner;
    TvmCell _lockerCode;

    //

    modifier inPhase(Phase p) {
        require(_phase == p, Errors.WRONG_PHASE);
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, Errors.IS_NOT_AUCTION_OWNER);
        _;
    }

    modifier onlyProxy() {
        require(msg.sender == _proxy, Errors.IS_NOT_PROXY);
        _;
    }

    modifier doUpdate() {
        _update();
        _;
    }

    //

    constructor (
                 uint128 USDToNanoever,
                 uint256 minNeverBid,
                 uint256 minNanoeverBid,
                 uint64 openDuration,
                 uint64 revealDuration) public onlyProxy {
        tvm.accept();
        _phase = Phase.OPEN;
        openTS = tx.timestamp;

        _USDToNanoever = USDToNanoever;

        _minNeverBid = minNeverBid;
        _minNanoeverBid = minNanoeverBid;

        _openDuration = openDuration;
        _revealDuration = revealDuration;
    }

    //

    function reveal(
                    uint256 auctionAddrHash,
                    uint256 ownerAddrHash,
                    uint256 bidHash,
                    uint256 key,
                    uint64 lockTS,
                    uint256 nevers,
                    uint256 nanoevers,
                    bool isNever) public override doUpdate inPhase(Phase.REVEAL) {

        require(lockTS < revealStartTS, Errors.BID_NOT_LOCKED_IN_TIME);
        
        TvmCell code = _lockerCode.toSlice().loadRef();
        TvmCell state = tvm.buildStateInit({
            contr: BidLocker,
            varInit: {
                auctionAddrHash: auctionAddrHash,
                ownerAddrHash: ownerAddrHash,
                bidHash: bidHash
            },
            pubkey: key,
            code: code
        });
        address lockerAddress = address.makeAddrStd(0, tvm.hash(state));
        require(lockerAddress == msg.sender, Errors.NOT_A_LOCKER);

        tvm.accept();

        if (isNever) {
            require(nanoevers >= _minNanoeverBid, Errors.BID_TOO_SMALL);
            Bid newBid = Bid(nevers, nanoevers, isNever);
            if (Helpers.greater(newBid, everSecondPrice)) {
                everSecondPrice = newBid;
            }
            if (Helpers.greater(everSecondPrice, everFirstPrice)) {
                (everSecondPrice, everFirstPrice) = (everFirstPrice, everSecondPrice);
                everFirst = msg.sender;
            }
        } else {
            require(nevers >= _minNeverBid, Errors.BID_TOO_SMALL);
            Bid newBid = Bid(nevers, nanoevers, isNever);
            if (Helpers.greater(newBid, neverSecondPrice)) {
                neverSecondPrice = newBid;
            }
            if (Helpers.greater(neverSecondPrice, neverFirstPrice)) {
                (neverSecondPrice, neverFirstPrice) = (neverFirstPrice, neverSecondPrice);
                neverFirst = msg.sender;
            }
        }

    }

    function update() public pure onlyOwner doUpdate {
        tvm.accept();
    } 

    //

    function _update() private {
        if (_phase == Phase.OPEN && tx.timestamp > openTS + _openDuration) {
            _phase = Phase.REVEAL;
            revealStartTS = tx.timestamp;
        }
        if (_phase == Phase.REVEAL && tx.timestamp > revealStartTS + _revealDuration) {
            _phase = Phase.CLOSED;
            _closeTS = tx.timestamp;
        }
        if (_phase == Phase.CLOSED) {
            _notifyWinner();
        }
    }

    function _notifyWinner() private view {
        // todo: emit winner event

        INeverBank(_bank).updateWinners(
            _closeTS,
            neverFirst,
            neverSecondPrice.nevers,
            neverSecondPrice.nanoevers,
            everFirst,
            everSecondPrice.nanoevers,
            everSecondPrice.nevers
        );
    }

    function _setLockerCode(TvmCell code) public onlyOwner {
        _lockerCode = code;
    }

}
