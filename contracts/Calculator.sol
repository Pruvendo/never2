pragma ton-solidity >=0.59.4;

contract Calculator {
    constructor() public {
        tvm.accept();
    }

    function hashOfAddess(address a, uint128 salt) public pure returns(uint256) {
        TvmBuilder builder;
        builder.store(a, salt);
        return tvm.hash(builder.toCell());
    }

    function bidHash(uint256 nevers, uint256 evers, uint128 salt) public pure returns(uint256) {
        TvmBuilder bidBuilder;
        bidBuilder.store(nevers, evers, salt);
        TvmCell bidCell = bidBuilder.toCell();
        return tvm.hash(bidCell);
    }
}