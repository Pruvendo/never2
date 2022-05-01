pragma ton-solidity >=0.59.4;

import "./BlindAuction.sol";
import "./lib/Lib.sol";


// Creates auctions, handles oracle subscription 

contract OracleProxy {

    address static _oracle;

    address _bank;

    // updated via oracle
    uint128 _USDToNanoever; 

    uint64 auctionIteration = 0;

    address public lastAuction;

    bool newAuctionIsDue = false;

    //

    uint256 public auctionCodeHash;
    TvmCell _auctionCode;
    bool _auctionCodeSet = false;


    uint128 _auctionDeployValue = 10 ever;


    modifier onlyOracle () {
        require(msg.sender == _oracle, Errors.IS_NOT_ORACLE);
        _;
    }

    modifier checkPubkey() {
        require(msg.pubkey() == tvm.pubkey(), Errors.WRONG_PUBKEY);
        _;
    }

    //

    constructor() public checkPubkey {
        tvm.accept();
    }

    function registerBank(address bank) public checkPubkey {
        tvm.accept();
        _bank = bank;
    }

    //

    function acceptOracle(uint128 USDToNanoever) public onlyOracle {
        tvm.accept();

        _USDToNanoever = USDToNanoever;

        //TODO: logic if we need to start new auction

        if (newAuctionIsDue) {
            // _initiateAuctions();
        }
    }

  

    //
    // do it by hand
    function initiateAuctions(uint256 pubkey) public checkPubkey {
        require(_auctionCodeSet, Errors.AUCTION_CODE_NOT_SET);
        require(address(_bank) != address(0), Errors.BANK_NOT_SET);
        tvm.accept();

        // todo: emit notifying event

        lastAuction = new BlindAuction{
            code: _auctionCode,
            value: _auctionDeployValue,
            pubkey: pubkey,
            varInit: {
                _proxy: address(this),
                _bank: _bank,
                _iteration: auctionIteration++
            }
        }(_USDToNanoever, 10, 25000000, 900, 300);

    }

    function _setAuctionCode(TvmCell code) public checkPubkey {
        tvm.accept();

        _auctionCode = code;
        auctionCodeHash = tvm.hash(code);
        _auctionCodeSet = true;
    }



}
