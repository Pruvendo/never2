pragma ton-solidity >=0.59.4;

import "./lib/Lib.sol";
import "./OracleProxy.sol";


contract OracleMock {

    constructor() public {
        require(tvm.pubkey() == msg.pubkey());
        require(tvm.pubkey() != 0);
        tvm.accept();
    }

    function acceptOracle(address oracleProxy, uint128 USDToNanoever) external view {
        require(tvm.pubkey() == msg.pubkey());
        tvm.accept();

        OracleProxy(oracleProxy).acceptOracle(USDToNanoever);
    }
}

