pragma ton-solidity >=0.59.4;


import "./lib/Interfaces.sol";
import "./lib/Lib.sol";


contract Stake {
    address static deAuction;

    uint256 _nanonevers;
    uint256 _nanoevers;
    bool _isNever;
    bool _locked = false;
    bool _withdrawn = false;

    modifier onlyOwner() {
        require(tvm.pubkey() != 0);
        require(tvm.pubkey() == msg.pubkey());
        _;
    }

    constructor() public onlyOwner {
        tvm.accept();
    }

    function lock(uint256 nanonevers, uint256 nanoevers, bool isNever) public onlyOwner {
        require(!_locked);
        tvm.accept();

        ExtraCurrencyCollection c;
        uint128 value = 0;

        if (isNever) {
            optional(uint256) neverBalance =
                address(this).currencies.fetch(Constants.NEVER_ID);
            if (!neverBalance.hasValue() || neverBalance.get() < nanonevers) {
                return;
            }
            c[Constants.NEVER_ID] = nanonevers;
        } else {
            if (address(this).balance < nanoevers) {
                return;
            }
            value = uint128(nanoevers);
        }

        _nanonevers = nanonevers;
        _nanoevers = nanoevers;
        _isNever = isNever;
        _locked = true;

        IDeAuction(deAuction).newStake{value: value, currencies: c}(
            nanonevers, nanoevers, isNever, tvm.pubkey());
    }

    // requires auction ended
    function withdraw() public onlyOwner {
        tvm.accept();
        require(!_withdrawn);
        IDeAuction(deAuction).withdraw(_nanonevers, _nanoevers, _isNever, tvm.pubkey());
        _withdrawn = true;
    }

    function transfer(uint128 value, uint256 never_value, bool bounce, uint16 flag, address dest) public view onlyOwner {
        require(_withdrawn);
        tvm.accept();


        if (never_value != 0) {
            ExtraCurrencyCollection col;
            col[Constants.NEVER_ID] = never_value;
            dest.transfer({
                value: value,
                bounce: bounce,
                flag: flag,
                currencies: col
            });
        }

        dest.transfer({
            value: value,
            bounce: bounce,
            flag: flag
        });
    }

}
