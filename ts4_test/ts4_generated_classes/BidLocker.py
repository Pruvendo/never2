
import tonos_ts4.ts4 as ts4


class BidLocker(ts4.BaseContract):
    def __init__(
        self,

        auctionAddrHash=None,
        ownerAddrHash=None,
        bidHash=None,

        never=None,

        address=None,
        balance=None,
        keypair=None,
    ):
        keypair = keypair or ts4.make_keypair()
        if address:
            super().__init__(
                'BidLocker',
                ctor_params=None,
                initial_data=dict(),
                address=address,
                nickname='BidLocker',
            )
        else:
            super().__init__(
                'BidLocker',
                ctor_params=None,
                initial_data=dict(
                    auctionAddrHash=auctionAddrHash,
                    ownerAddrHash=ownerAddrHash,
                    bidHash=bidHash,

                ),
                keypair=keypair,
                balance=balance,
                nickname='BidLocker',
            )

            super().call_method(
                'constructor',
                params=dict(
                    never=never,

                ),
                private_key=self.private_key_,
            )


    def lock(
        self,

        is_getter=False,
    ):
        if is_getter:
            return super().call_getter(
                method='lock',
                params=dict(

                ),
            )
        else:
            return super().call_method(
                method='lock',
                params=dict(

                ),
                private_key=self.private_key_,
            )

    def verify(
        self,
        owner,
        auction,
        nanonevers,
        nanoevers,
        salt,

        is_getter=False,
    ):
        if is_getter:
            return super().call_getter(
                method='verify',
                params=dict(
                    owner=owner,
                    auction=auction,
                    nanonevers=nanonevers,
                    nanoevers=nanoevers,
                    salt=salt,

                ),
            )
        else:
            return super().call_method(
                method='verify',
                params=dict(
                    owner=owner,
                    auction=auction,
                    nanonevers=nanonevers,
                    nanoevers=nanoevers,
                    salt=salt,

                ),
                private_key=self.private_key_,
            )

    def transfer(
        self,
        dest,

        is_getter=False,
    ):
        if is_getter:
            return super().call_getter(
                method='transfer',
                params=dict(
                    dest=dest,

                ),
            )
        else:
            return super().call_method(
                method='transfer',
                params=dict(
                    dest=dest,

                ),
                private_key=self.private_key_,
            )

    def receiveWin(
        self,

        is_getter=False,
    ):
        if is_getter:
            return super().call_getter(
                method='receiveWin',
                params=dict(

                ),
            )
        else:
            return super().call_method(
                method='receiveWin',
                params=dict(

                ),
                private_key=self.private_key_,
            )




    @property
    def _pubkey(self):
        return self.call_getter('_pubkey')

    @property
    def _timestamp(self):
        return self.call_getter('_timestamp')

    @property
    def _constructorFlag(self):
        return self.call_getter('_constructorFlag')

    @property
    def auctionAddrHash(self):
        return self.call_getter('auctionAddrHash')

    @property
    def ownerAddrHash(self):
        return self.call_getter('ownerAddrHash')

    @property
    def bidHash(self):
        return self.call_getter('bidHash')

    @property
    def _never(self):
        return self.call_getter('_never')

    @property
    def _successfulReveal(self):
        return self.call_getter('_successfulReveal')

    @property
    def locked(self):
        return self.call_getter('locked')

    @property
    def lockedTS(self):
        return self.call_getter('lockedTS')

    @property
    def lockedBalance(self):
        return self.call_getter('lockedBalance')

    @property
    def _owner(self):
        return self.call_getter('_owner')

    @property
    def _bank(self):
        return self.call_getter('_bank')

    @property
    def _operationsReserved(self):
        return self.call_getter('_operationsReserved')


