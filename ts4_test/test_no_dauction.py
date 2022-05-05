from dataclasses import dataclass
from random import randint
from typing import List
import tonos_ts4.ts4 as ts4
import pytest

import constants

from ts4_generated_classes import *
from tools import send_evers
from common_contracts import SafeMultisig


@dataclass
class Bid:
    bid_size: int
    salt: int
    locker: BidLocker
    owner: ts4.Address


@pytest.mark.parametrize(
    argnames=['bid_sizes'],
    argvalues=[
        ([1000 * 10**9, 2000 * 10**9, 3000 * 10**9, 4000 * 10**9,],),
    ]
)
def test(pytestconfig, bid_sizes):
    ts4.reset_all()
    rootpath = pytestconfig.rootpath
    ts4.init(rootpath.joinpath('./contracts/'), verbose=True)
    calc = Calculator()


    # prepare OracleProxy
    oracle_mock = OracleMock()
    oracle_proxy = OracleProxy(
        _oracle=oracle_mock.address,
        balance=100 * 10**9,
    )
    never_bank = NeverBank(_proxy=oracle_proxy.address)

    oracle_proxy.registerBank(never_bank.address)
    ts4.dispatch_messages()

    auction_code = ts4.load_code_cell('BlindAuction')
    locker_code = ts4.load_code_cell('BidLocker')


    # start auction
    oracle_proxy._setAuctionCode(code=auction_code)

    auction_keypair = ts4.make_keypair()
    auction_address = oracle_proxy.initiateAuctions(pubkey=auction_keypair[1])
    ts4.dispatch_messages()
    auction = BlindAuction(address=auction_address)
    auction._setLockerCode(locker_code)


    # lock bids
    bids: List[Bid] = []
    for bid_size in bid_sizes:
        salt = randint(0, 2**128 - 1)
        # bid_size = 1000 * 10**9
        multisig = SafeMultisig()

        bid_locker = BidLocker(
            auctionAddrHash=calc.hashOfAddess(
                a=auction.address,
                salt=salt,
                is_getter=True
            ),
            ownerAddrHash=calc.hashOfAddess(
                # TODO wrong address
                a=multisig.address,
                salt=salt,
                is_getter=True
            ),
            bidHash=calc.bidHash(0, bid_size, salt, is_getter=True),
            never=False,
        )
        ts4.dispatch_messages()

        send_evers(bid_locker.address, bid_size + 10**9)
        ts4.dispatch_messages()

        bid_locker.lock()
        ts4.dispatch_messages()
        bids.append(Bid(
            bid_size=bid_size,
            salt=salt,
            locker=bid_locker,
            owner=multisig.address,
        ))


    # reveal bid
    ts4.core.set_now(ts4.core.get_now() + constants.open_duration + 1)

    for bid in bids:
        bid.locker.verify(
            # TODO wrong address
            owner=bid.owner,
            salt=bid.salt,
            auction=auction.address,
            nevers=0,
            evers=bid.bid_size,
        )
        ts4.dispatch_messages()


    # end auction
    ts4.core.set_now(ts4.core.get_now() + constants.reveal_duration + 1)
    auction.update()
    # ts4.dispatch_one_message(expect_ec=constants.)
    # ts4.dispatch_messages()
