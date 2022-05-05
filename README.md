# NEVER Phase 2 (Auctions)
## Developed by Pruvendo at 05/06/22

**Introduction**

The present set of conracts describes
EVER/NEVER auction implementation with
the full support of D'Auctions. The
solution follows the winner of [DeFi contest #14](https://firebasestorage.googleapis.com/v0/b/ton-labs.appspot.com/o/documents%2Fapplication%2Fpdf%2Fjz5i5hcndnktkekjat-NOT%20Pruvendo%20Implementation%20draft%203.pdf?alt=media&token=015ee545-fe73-432c-a525-9a4e672128ba).

**Overview**

The entities described below were
implemented throughout the present
contest.

_Auctions_

Auctions are intended to define the 
fare EVER/USD rate. The initial
estimations are done by Oracle handling
(implemented during the first stage of
NEVER contests [(DeFi contest #16)](https://firebasestorage.googleapis.com/v0/b/ton-labs.appspot.com/o/documents%2Fapplication%2Fpdf%2Fjz5i5hcndnktkekjat-NOT%20Pruvendo%20Implementation%20draft%203.pdf?alt=media&token=015ee545-fe73-432c-a525-9a4e672128ba)
while the goal of the auction is 
to define the final price, to
sell the required amount to the winner
as well as to open an exchange center
for all the participants allowing then
to buy/sell NEVER's with some
surplus fee comparing to the Auction
price.

The auction is desinged as a [Vickrey
second price](https://en.wikipedia.org/wiki/Vickrey_auction) auction.

_D'Auctions_

While the minimal stake allowed for the
auction is supposed to be pretty high
(up to millions of dollars) very few
people can participate there.

To make the auction more acceptible for
a wider audithorium the paradigm of
D'Auctions has been implemented. The
participants can combine their
capabilities and create a joining stake
trying to win as a single entity.

Later the winning stake is fairly
distributed between the participants
(with some extra award for the 
D'Auction owner) and the lost stakes 
are returned back (with the 
possibility to be automatically 
reinvested).

The important feature is to let
D'Action owner to explicitly declare
his investment strategy, has no ability
to hiddenly change it, thus letting a
participant to select a D'Auction that
is best in terms of satisfying the
participant's requirements and desires.

**Location**

The implementation provided is located
at [GitHub](https://github.com/Pruvendo/never2). The product is under
[MIT](https://opensource.org/licenses/MIT) license.

**Architecture**

The following key contracts were
implemented.

_BidLocker_

This contract keeps the bid of a participant
until the auction is completed. Upon completion
the bid either sent to _NeverBank_ or returned
back to the participant.

_BlindAuction_

To be here.

_Calculator_

_Calculator_ is an auxiliary contract that
performs hash calculations with salting.

_DeAuction_

The present implementation of D'Auctions works 
as follows:
- _DeAuction_ contract is created using the 
owner's public key where the parent 
_BlindAuction_ is kept as a static variable.
_DeAuction_ as well as a _BlindAuction_ works in
both directions. It will create two stakes -
_NEVER/EVER_ and _EVER_NEVER_, certainly, 
only in case the corresponding 
_WeightedAggregate_ contracts will exist. 
- The corresponding _WeightedAggregate_ 
contracts are created keeping the _DeAuction_
address as a static variable.
- The owner calls _setAggregators_ methods to
keep the addresses of aggregators and trust 
them. Additionally, it calls _setLockerCode_ to
be able to create bids as well as _setStakeCode_
to trust to the _Stake_ contracts to be 
appeared.
- Upon the completion of the auction (in case
of any result) the _DeAuction_ will be notified
by _BidLocker_ (described above) using 
_notifyWin_ method and thus receives coins that
can be withdrawn by _Stake_ owners using
_withdraw_ method.

_NeverBank_

_NeverBank_ is an auxiliary contract that is
responsible for payments to winners of auctions.

_OracleProxy_

This contract acts a bridge between oracles and
auctions, creating the laters.

_Stake_

The _Stake_ contract works in the following way:
- _Stake_ contract is created using the 
owner's public key where the parent _DeAuction_
is kept as a static variable.
- Upon creation, it's necessary to put there a
required amount and call _lock_ with two 
numbers - (nano)evers and (nano)nevers as well
as with direction flag (_true_ means that
the coversion from NEVER to EVER is expected).
- Upon the successful lock the contract send all
the coins to the _DeAuction_ to take them back
upon completion using _withdraw_ method
(_DeAuction_ is trustful as the contract 
address is checked).

**Usage**

**More information**

Feel free to ask any question [Sergey Egorov](https://t/me/SergeyEgorovSPb), 
he will either answer or address them
to the proper developer.
