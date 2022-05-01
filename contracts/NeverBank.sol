pragma ton-solidity >=0.59.4;


import "./lib/Interfaces.sol";
import "./lib/Lib.sol";


contract NeverBank is INeverBank {

    address static _proxy;

    address _activeAuction;

    uint64 _auctionCloseTS;
    uint64 _winnerBuyDuration = 60*60*12;     // 12 hours
    uint64 _loserBuyDuration = 60*60*24;      // 12 hours

    uint256 _neverWinnerNevers; // to pay
    uint256 _neverWinnerEvers;  // to expect
    address _neverWinner;

    uint256 _everWinnerNevers;  // to expect
    uint256 _everWinnerEvers;   // to pay
    address _everWinner;

    


    modifier onlyAuction() {
        require(msg.sender == _activeAuction, Errors.NOT_AN_AUCTION);
        _;
    }

    modifier onlyProxy() {
        require(msg.sender == _proxy, Errors.NOT_AN_AUCTION);
        _;
    }

    modifier onlyNeverWinner() {
        require(msg.sender == _neverWinner, Errors.NOT_NEVER_WINNER);
        require(tx.timestamp < _auctionCloseTS + _winnerBuyDuration, Errors.WINNER_TOO_LATE);
        _;
    }

    modifier onlyEverWinner() {
        require(msg.sender == _everWinner, Errors.NOT_EVER_WINNER);
        require(tx.timestamp < _auctionCloseTS + _winnerBuyDuration, Errors.WINNER_TOO_LATE);
        _;
    }

    function updateAuction(address auction) public override onlyProxy {
        tvm.accept();
        _activeAuction = auction;
    }

    function updateWinners(
                           uint64 closeTS,
                           address neverWinner,
                           uint256 neverWinnerNevers,
                           uint256 neverWinnerEvers,
                           address everWinner,
                           uint256 everWinnerEvers,
                           uint256 everWinnerNevers) public override onlyAuction {
        tvm.accept();
        _neverWinner = neverWinner;
        _neverWinnerNevers = neverWinnerNevers;
        _neverWinnerEvers = neverWinnerEvers;
        _everWinner = everWinner;
        _everWinnerEvers = everWinnerEvers;
        _everWinnerNevers = everWinnerNevers;

        if (_everWinner != address(0) || _neverWinner != address(0)) {
            // auction was a success
            _auctionCloseTS = closeTS;
        }
    }

    constructor() public {
        require(tvm.pubkey() == msg.pubkey());
        require(tvm.pubkey() != 0);
        require(_proxy != address(0), Errors.PROXY_NOT_SET);
        tvm.accept();
    }


    // todo: use tvm.rawReserve() to return the exact change
    function payNevers() public override onlyNeverWinner {
        require(msg.value >= _neverWinnerEvers);
        tvm.accept();
        ExtraCurrencyCollection c;
        c[Constants.NEVER_ID] = _neverWinnerNevers;
        msg.sender.transfer({
            value: 0,
            bounce: false,
            flag: 1,
            currencies: c
        });
    }

    function payEvers() public override onlyEverWinner {
        optional(uint256) nevers = msg.currencies.fetch(Constants.NEVER_ID);
        require(nevers.hasValue() && nevers.get() >= _everWinnerNevers);
        tvm.accept();
        msg.sender.transfer({
            value: uint128(_everWinnerEvers),
            bounce: false,
            flag: 1
        });
    }



}

