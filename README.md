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

It's a core contract that represents auction
itself, below the process of its creation
described.

- The creation of _BlindAuction_ is initiated by
_OracleProxy_ mentioned below.
- At the same time, _NeverBank_ is deployed that
acts as an entrance point for the "winning"
coins.
- _registerBank_ method of _OracleProxy_ is 
called to keep the bank address. Later this
address will be sent to each _BlindAuction_
created by the present _OracleProxy_.
- Also _setAuctionCode_ method of _OracleProxy_
is called as it's needed for auction deployment.
- In the present implementation the 
_BlindAuction_ itself is deployed by
_initiateAuctions_ method, but during the Phase
3 (final stage) it's planned to improve the
robustness. At the same time the bank is called
with _updateAuction_ to let it be prepared to
pay to the winners.

The auctions consists on two parts:
_NEVER/EVER_ and _EVER_NEVER_. It has as much as
three static variables:
- _OracleProxy_ address
- _NeverBank_ address
- Ordinary number of the auction (monitored by
_OracleProxy_ that deploys the auctions to keep
them unique).

The auction bid looks like a triple: nanoevers,
nanoevers and direction, where the first two
numbers indicate the amounts the participant
plans to pay or receive, where the last one
represents the direction (_true_ means 
conversion from nanonevers to nanoevevers and
_false_ the opposite).

The constructor parameteres define the floor
rate (all the lower bids are dropped) as well
as minimal exchange amounts (too small deals
are forbidden). The rest of parameters describe
the duration of _OPEN_ and _REVEAL_ stages.

The creation of bids is not controlled by the
auction. The first interaction of bids with the
auction happens at _REVEAL_ stage that allows
to keep all the bids secret for other
participants (all the data is hashed and
salted, the exception here is D'Auction as it
can not make a hidden bid).

To create a bid (_BidLocker_) it's necessary to
calculate the following hashes:
- Auction address
- Owner address (where coins are to be 
transferred later, important for D'Auctions)
- hashes of the bid itself (a pair of values)

All these hashes are kept as static variables of
the _BidLocker_ contract.

Upon deployment of _BidLocker_ it's necessary
to transfer there enough coins and call the
_lock_ method BEFORE starting the _REVEAL_ stage
of the auction. During the _REVEAL_ stage the
_verify_ method should be called to check if
the bid corresponds to the one created at the
time of _lock_ method invocation. The same
parameteres (that were hashed before deployment
and salting) must be used.

The winning bid is the one with the best 
_myCurrency_/_buyCurrency_ ratio, however,
_buyCurrency_ can be purchased by the rate of
the second-best bid.

Upon the auction completion the auction calls
_updateWinners_ method of _NeverBank_ and 
informs it about winners and necessary payments.
The owner of the winning _BidLocker_ can call
_receiveWin_ method that transfers the required
amount to the bank and receives coins in the
desired currency back.

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
Basically, it's an entrance point for the "winning" coins. It keeps an _OracleProxy_
address as a static variable.

_OracleProxy_

This contract acts a bridge between oracles and
auctions, creating the laters. The reference
to the oracle (that provides a preliminary
exchange rate) is kept as a static variable.
Also it's needed for a validation of
_BlindAuction_ updates for the auctions created
by the present _OracleProxy_.

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

All the scripts use _everdev_ utility.
To set the required _Solidity_ compiler version
run:

```
everdev sol set -c 0.59.4
```

The user must have standard _signers_ and _givers_ to make the scripts runnable. The
corresponding instruction can be found
[here](https://github.com/tonlabs/everdev).

- In the file _.project_config_ change _TVM_LINKER_ to the own linker. The
recompile can be done by using:

```
./clean.sh && ./compile.sh
```

- At first run `deploy_proxy_and_bank.sh`. 
It will deploy contracts and register them
for the mutial work. Remember the proxy
address from the last output line.
- After this the user can freely deploy the
auctions by the script

```
./deploy_auction.sh <address>
```

where the _\<address\>_ is a proxy address
received above. Again, remember the address
from the last output line.

Now the auction has started.The user can do
bids and create D'Auctions.

- Create D'Auction by

```
./deploy_deauction.sh <address>
```

where the _\<address\>_ is taken from the 
previous bullet point. Remember the address.

- Now the user can create stakes by

```
./deploy_stake.sh <address>
```
where the _\<address\>_ is an D'Auction address.
Remember the address.

- To lock the stake and withdraw use:

```
./lock_stake.sh <address>
```

- Just to withdraw:

```
 ./withdraw_stake.sh <address>
```

Also the user can act without D'Auctions:

- To deploy locker with the given hashes and 
flags. Remember the address:

```
./deploy_locker.sh <auctionAddrHash> <ownerAddrHash> <bidHash> <isNever>
```

- To lock the bid:

```
./lock_locker.sh <address>
```

- To reveal:

```
./reveal_locker.sh <address> <owner> <auction> <nanonevers> <nanoevers> <salt>
```

_Note: Addresses should be without 0:_

**Links**

_OracleProxy_
0:76c91eebfcf6cb8a12bcc1a6c77ada5d9488821716faa91fec512feb3a6e39bd
_NeverBank_
0:424e2d4611d45e3daf148a49c5ae6b1ca8358bcaae2df6f2924c9a82efa88585
_DeAuction_
0:4cfab22670b64b71206d5a71031453223b8b002e3caa4538674b665c535d05bf
_Stake_
0:e09d6bcaad311d3a5dfa30b21c5c81fb05fbd70cb68dcbbe0cba9f3044e92604
_BidLocker_
0:ae0291e79bd4fb550bb10cd8d6c95f2df1674e02d63993d8bb4a3989352d8cc1

**Quality**

The present system was both covered by TS4 tests
as well as integration testing in a special dev
net.

**More information**

Feel free to ask any question [Sergey Egorov](https://t/me/SergeyEgorovSPb), 
he will either answer or address them
to the proper developer.
