pragma ton-solidity >=0.59.4;


import "./Interfaces.sol";
import "./Lib.sol";


contract Stake {
    address static deAuction;

    uint256 _nevers;
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

    function lock(uint256 nevers, uint256 nanoevers, bool isNever) public onlyOwner {
        require(!_locked);
        tvm.accept();

        ExtraCurrencyCollection c;
        uint128 value = 0;

        if (isNever) {
            optional(uint256) neverBalance =
                address(this).currencies.fetch(Constants.NEVER_ID);
            require(neverBalance.hasValue());
            require(neverBalance.get() >= nevers);
            c[Constants.NEVER_ID] = nevers;
        } else {
            require(address(this).balance >= nanoevers);
            value = uint128(nanoevers);
        }

        _nevers = nevers;
        _nanoevers = nanoevers;
        _isNever = isNever;
        _locked = true;

        IDeAuction(deAuction).newStake{value: value, currencies: c}(
            nevers, nanoevers, isNever, tvm.pubkey());
    }

    // requires auction ended
    function withdraw() public onlyOwner {
        require(!_withdrawn);
        IDeAuction(deAuction).withdraw(_nevers, _nanoevers, _isNever, tvm.pubkey());
        _withdrawn = true;
    }

}