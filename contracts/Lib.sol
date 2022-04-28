pragma ton-solidity >=0.59.4;


enum Phase {OPEN, REVEAL, CLOSED}

// Bid isNever means the owner of the bid wants to buy 
// corresponding amount of *nanoevers* using corresponding amount of *nevers*
// and vice versa.
struct Bid {
    uint256 nevers;
    uint256 nanoevers;
    bool isNever;
}

enum AuctionType {
    NEVER,      // Participants wish to buy never using ever
    EVER        // Participants wish to buy ever using never
}

library Helpers {

    // compare two bids
    function greater(Bid left, Bid right) public returns (bool gt) {
        require(left.isNever == right.isNever, Errors.BIDS_UNCOMPARABLE);

        return left.nanoevers * right.nevers > left.nevers * right.nanoevers;
    }

}


library Constants {

    uint256 constant DEFAULT_QUOTATION_FACTOR = 10^9;

    uint32 constant NEVER_ID = 67;

}


library Errors {

    uint16 constant WRONG_PUBKEY = 101;
    uint16 constant AUCTION_CODE_NOT_SET = 101;

    // 

    uint16 constant WRONG_PHASE = 101;

    uint16 constant NOT_A_LOCKER = 101;

    uint16 constant IS_NOT_OWNER = 101;
    uint16 constant IS_NOT_PROXY = 101;
    uint16 constant IS_NOT_ORACLE = 101;

    uint16 constant BAD_QUOTATION = 101;
    uint16 constant BIDS_UNCOMPARABLE = 101;

    uint16 constant NEVER_TOO_LOW = 101;
    uint16 constant BALANCE_TOO_LOW = 101;
    uint16 constant BID_ALREADY_LOCKED = 101;
    uint16 constant BID_TOO_SMALL = 101;
    uint16 constant BID_NOT_LOCKED_IN_TIME = 101;
    uint16 constant FRAUD_REVEAL_FUNDS_LOCKED = 101;
    uint16 constant IS_NOT_BANK = 101;

    uint16 constant BAD_BID_HASH = 101;
    uint16 constant BAD_OWNER_HASH = 101;
    uint16 constant BAD_AUCTION_HASH = 101;

    uint16 constant NOT_AN_AUCTION = 101;
    uint16 constant NOT_NEVER_WINNER = 101;
    uint16 constant NOT_EVER_WINNER = 101;
    uint16 constant WINNER_TOO_LATE = 101;

    uint16 constant PROXY_NOT_SET = 101;
    uint16 constant BANK_NOT_SET = 101;

    uint16 constant NOT_A_STAKE = 101;
}
