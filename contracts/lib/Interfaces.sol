pragma ton-solidity >=0.59.4;


interface IAuction {
    function reveal(uint256 auctionAddrHash,
                    uint256 ownerAddrHash,
                    uint256 bidHash,
                    uint256 key,
                    uint64 lockTS,
                    uint256 nanonevers,
                    uint256 nanoevers,
                    bool isNever
    ) external;
}

interface INeverBank {
    function payEvers() external;
    function payNevers() external;
    function updateAuction(address auction) external;
    function updateWinners(uint64 closeTS,
                           address neverWinner,
                           uint256 neverWinnerNevers,
                           uint256 neverWinnerEvers,
                           address everWinner,
                           uint256 everWinnerEvers,
                           uint256 everWinnerNevers
    ) external;
}

interface IDeAuction {
    function newStake(uint256 nanonevers,
                      uint256 nanoevers,
                      bool isNever,
                      uint256 key
    ) external;
    function withdraw(uint256 nanonevers,
                      uint256 nanoevers,
                      bool isNever,
                      uint256 key
    ) external;
}

interface IAggregator {
    function addStake(uint256 nanonevers, uint256 nanoevers) external;
    function aggregate() external returns (uint256 nanonevers, uint256 nanoevers);
}
