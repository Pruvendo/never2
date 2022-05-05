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
a wider audothorium the patadigm of
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

**Architecure**

**Usage**
