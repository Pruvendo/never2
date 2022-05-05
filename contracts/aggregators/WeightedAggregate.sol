pragma ton-solidity >=0.59.4;

import "../lib/Interfaces.sol";
import "../lib/Lib.sol";



contract WeightedAggregate is IAggregator {

    address static _deAuction;
    bool static _isNever;

    
    uint256 _nanonevers = 0;
    uint256 _nanoevers = 0;


    modifier isAuction() {
        require(msg.sender == _deAuction, Errors.NOT_DEAUCTION);
        _;
    }

    constructor() public {
        tvm.accept();
    }

    function addStake(uint256 nanonevers, uint256 nanoevers) public isAuction override {
        _nanonevers += nanonevers;
        _nanoevers += nanoevers;
    }

    function aggregate() public override {
        IDeAuction(_deAuction).acceptAggregate({
            nanonevers: _nanonevers,
            nanoevers: _nanoevers,
            isNever: _isNever
        });
    }

}
