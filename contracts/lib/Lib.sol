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

    // common errors

    uint16 constant WRONG_PUBKEY = 101;
    uint16 constant BALANCE_TOO_LOW = 102;
    uint16 constant BIDS_UNCOMPARABLE = 103;

    // oracle proxy errors

    uint16 constant IS_NOT_ORACLE = 201;
    uint16 constant AUCTION_CODE_NOT_SET = 202;
    uint16 constant BANK_NOT_SET = 203;

    // auction errors

    uint16 constant WRONG_PHASE = 301;
    uint16 constant NOT_A_LOCKER = 302;
    uint16 constant IS_NOT_AUCTION_OWNER = 303;
    uint16 constant IS_NOT_PROXY = 304;
    uint16 constant BID_NOT_LOCKED_IN_TIME = 305;
    uint16 constant BID_TOO_SMALL = 306;

    // bank errors

    uint16 constant NOT_AN_AUCTION = 401;
    uint16 constant NOT_NEVER_WINNER = 402;
    uint16 constant NOT_EVER_WINNER = 403;
    uint16 constant WINNER_TOO_LATE = 404;
    uint16 constant PROXY_NOT_SET = 405;

    // locker errors

    uint16 constant IS_NOT_BANK = 501;
    uint16 constant IS_NOT_LOCKER_OWNER = 502;
    uint16 constant BID_ALREADY_LOCKED = 503;
    uint16 constant NEVER_TOO_LOW = 504;
    uint16 constant BAD_BID_HASH = 505;
    uint16 constant BAD_OWNER_HASH = 506;
    uint16 constant BAD_AUCTION_HASH = 507;
    uint16 constant LOCKED_BALANCE_TOO_LOW = 508;
    uint16 constant FRAUD_REVEAL_FUNDS_LOCKED = 509;

    // de'auction errors 

    uint16 constant NOT_A_STAKE = 601;

    // stake errors


}
