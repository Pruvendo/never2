pragma ton-solidity >=0.59.4;

import "./BidLocker.sol";
import "./lib/Interfaces.sol";
import "./lib/Lib.sol";



contract BlindAuction is IAuction {

    address static _proxy;
    address static _bank;
    uint64 static _iteration;

    //

    event auctionNeverWinnerEvent(address locker);
    event auctionEverWinnerEvent(address locker);

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

    uint128 _USDToNanoever;   //  assumed as  10^9 * NANONEVER/NANOEVER

    Bid _baselineBid;         //  bids with lesser ratio aren't allowed

    uint256 _minNanoeverBid;
    uint256 _minNanoneverBid;

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
                 uint256 minNanoneverBid,
                 uint256 minNanoeverBid,
                 uint64 openDuration,
                 uint64 revealDuration) public onlyProxy {
        tvm.accept();
        _phase = Phase.OPEN;
        openTS = now;

        _USDToNanoever = USDToNanoever;

        _baselineBid = Bid(10^9, _USDToNanoever, false);


        _minNanoneverBid = minNanoneverBid;
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
                    uint256 nanonevers,
                    uint256 nanoevers,
                    bool isNever) public override doUpdate inPhase(Phase.REVEAL) {

        require(lockTS < revealStartTS, Errors.BID_NOT_LOCKED_IN_TIME);

        tvm.accept(); // затычка (не хватает газа)

        // TODO не лучше ли использовать хеши?
        // если их не использовать, то газа не хватает
        // TvmCell code = _lockerCode.toSlice().loadRef();
        TvmCell code = _lockerCode;
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
        // require(lockerAddress == msg.sender, Errors.NOT_A_LOCKER);
        if (lockerAddress != msg.sender) {
            return; // NOT A LOCKER CONTRACT
        }

        if (isNever) {
            _baselineBid.isNever = true;
            Bid newBid = Bid(nanonevers, nanoevers, isNever);
            if (Helpers.greater(_baselineBid, newBid) || nanoevers < _minNanoeverBid) {
                return;  // BID TOO SMALL OR RATE BELOW MIN
            }
            if (Helpers.greater(newBid, everSecondPrice)) {
                everSecondPrice = newBid;
            }
            if (Helpers.greater(everSecondPrice, everFirstPrice)) {
                (everSecondPrice, everFirstPrice) = (everFirstPrice, everSecondPrice);
                everFirst = msg.sender;
            }
        } else {
            _baselineBid.isNever = false;
            Bid newBid = Bid(nanonevers, nanoevers, isNever);
            require(nanonevers >= _minNanoneverBid, Errors.BID_TOO_SMALL);
            require(Helpers.greaterOrEqual(newBid, _baselineBid), Errors.BID_RATE_BELOW_MIN);
            if (Helpers.greater(_baselineBid, newBid) || nanonevers < _minNanoneverBid) {
                return;  // BID TOO SMALL OR RATE BELOW MIN
            }
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
        // TODO если не было ни одного ревила, то контракт намертво застрянет
        if (_phase == Phase.OPEN && now > openTS + _openDuration) {
            _phase = Phase.REVEAL;
            revealStartTS = now;
        }
        if (_phase == Phase.REVEAL && now > revealStartTS + _revealDuration) {
            _phase = Phase.CLOSED;
            _closeTS = now;
        }
        if (_phase == Phase.CLOSED) {
            // TODO никто не может инициировать выплату кроме владельца, что плохо
            _notifyWinner();
        }
    }

    function _notifyWinner() private view {

        (uint256 neverWinnerNevers,
         uint256 neverWinnerEvers, 
         uint256 everWinnerEvers,
         uint256 everWinnerNevers) = _calcWinnerRatios();

        INeverBank(_bank).updateWinners({
            closeTS: _closeTS,
            neverWinner: neverFirst,
            neverWinnerNevers: neverWinnerNevers,
            neverWinnerEvers: neverWinnerEvers,
            everWinner: everFirst,
            everWinnerEvers: everWinnerEvers,
            everWinnerNevers: everWinnerNevers
        });

        emit auctionNeverWinnerEvent(neverFirst);
        emit auctionEverWinnerEvent(everFirst);
    }

    function _calcWinnerRatios() private view 
            returns (uint256 nNanonevers, uint256 nNanoevers,
                     uint256 eNanoevers, uint256 eNanonevers) {
        // the winner should be able to get his requested amount of currency
        // but pay according to the ratio of the second highest bid.

        // winner of never auction:
        nNanonevers = neverFirstPrice.nanonevers;
        nNanoevers = neverSecondPrice.nanoevers * nNanonevers / neverSecondPrice.nanoevers; 
        // winner of ever auction:
        eNanoevers = everFirstPrice.nanoevers;
        eNanonevers = everSecondPrice.nanonevers * eNanonevers / everSecondPrice.nanonevers;
    }

    function _setLockerCode(TvmCell code) public onlyOwner {
        tvm.accept();
        _lockerCode = code;
    }

}
