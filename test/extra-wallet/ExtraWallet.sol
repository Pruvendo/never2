pragma AbiHeader expire;

contract ExtraWallet {

    constructor () public {
        require(tvm.pubkey() == msg.pubkey());
        require(tvm.pubkey() != 0);
        tvm.accept();
    }

    function getCurrencies() external pure returns (mapping(uint32 => uint256) res) {
        ExtraCurrencyCollection col = address(this).currencies;
        (uint32 k, uint256 v, bool success) = col.min();

        while (success) {
            res[k] = v;
            (k, v, success) = col.next(k);
        }
    }

    function extraTransfer(uint32 id, uint256 value, address payable dest) external view {
        require(tvm.pubkey() == msg.pubkey());
        require(tvm.pubkey() != 0);
        tvm.accept();

        ExtraCurrencyCollection c;
        if (id != 0) {
            c[id] = value;
        }

        dest.transfer({
            currencies: c,
            value: 0,
            flag: 1
        });
    }

    function transfer(uint128 value, address payable dest) external view {
        require(tvm.pubkey() == msg.pubkey());
        require(tvm.pubkey() != 0);
        tvm.accept();

        dest.transfer({
            value: value,
            flag: 1
        });
    }

    function onCodeUpgrade() private {
        tvm.resetStorage();
    }

}
