
import tonos_ts4.ts4 as ts4


class BlindAuction(ts4.BaseContract):
    def __init__(
        self,

        _proxy=None,
        _bank=None,
        _iteration=None,
        
        USDToNanoever=None,
        minNeverBid=None,
        minNanoeverBid=None,
        openDuration=None,
        revealDuration=None,
        
        address=None,
        balance=None,
        keypair=None,
    ):
        keypair = keypair or ts4.make_keypair()
        if address:
            super().__init__(
                'BlindAuction',
                ctor_params=None,
                initial_data=dict(),
                address=address,
                nickname='BlindAuction',
            )
        else:
            super().__init__(
                'BlindAuction',
                ctor_params=None,
                initial_data=dict(
                    _proxy=_proxy,
                    _bank=_bank,
                    _iteration=_iteration,
                    
                ),
                keypair=keypair,
                balance=balance,
                nickname='BlindAuction',
            )

            super().call_method(
                'constructor',
                params=dict(
                    USDToNanoever=USDToNanoever,
                    minNeverBid=minNeverBid,
                    minNanoeverBid=minNanoeverBid,
                    openDuration=openDuration,
                    revealDuration=revealDuration,
                    
                ),
                private_key=self.private_key_,
            )


    def reveal(
        self,
        auctionAddrHash,
        ownerAddrHash,
        bidHash,
        key,
        lockTS,
        nevers,
        nanoevers,
        isNever,
        
        is_getter=False,
    ):
        if is_getter:
            return super().call_getter(
                method='reveal',
                params=dict(
                    auctionAddrHash=auctionAddrHash,
                    ownerAddrHash=ownerAddrHash,
                    bidHash=bidHash,
                    key=key,
                    lockTS=lockTS,
                    nevers=nevers,
                    nanoevers=nanoevers,
                    isNever=isNever,
                    
                ),
            )
        else:
            return super().call_method(
                method='reveal',
                params=dict(
                    auctionAddrHash=auctionAddrHash,
                    ownerAddrHash=ownerAddrHash,
                    bidHash=bidHash,
                    key=key,
                    lockTS=lockTS,
                    nevers=nevers,
                    nanoevers=nanoevers,
                    isNever=isNever,
                    
                ),
                private_key=self.private_key_,
            )

    def update(
        self,
        
        is_getter=False,
    ):
        if is_getter:
            return super().call_getter(
                method='update',
                params=dict(
                    
                ),
            )
        else:
            return super().call_method(
                method='update',
                params=dict(
                    
                ),
                private_key=self.private_key_,
            )

    def _setLockerCode(
        self,
        code,
        
        is_getter=False,
    ):
        if is_getter:
            return super().call_getter(
                method='_setLockerCode',
                params=dict(
                    code=code,
                    
                ),
            )
        else:
            return super().call_method(
                method='_setLockerCode',
                params=dict(
                    code=code,
                    
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
    def _proxy(self):
        return self.call_getter('_proxy')

    @property
    def _bank(self):
        return self.call_getter('_bank')

    @property
    def _iteration(self):
        return self.call_getter('_iteration')

    @property
    def _phase(self):
        return self.call_getter('_phase')

    @property
    def everFirst(self):
        return self.call_getter('everFirst')

    @property
    def everFirstPrice(self):
        return self.call_getter('everFirstPrice')

    @property
    def everSecondPrice(self):
        return self.call_getter('everSecondPrice')

    @property
    def neverFirst(self):
        return self.call_getter('neverFirst')

    @property
    def neverFirstPrice(self):
        return self.call_getter('neverFirstPrice')

    @property
    def neverSecondPrice(self):
        return self.call_getter('neverSecondPrice')

    @property
    def _USDToNanoever(self):
        return self.call_getter('_USDToNanoever')

    @property
    def _minNanoeverBid(self):
        return self.call_getter('_minNanoeverBid')

    @property
    def _minNeverBid(self):
        return self.call_getter('_minNeverBid')

    @property
    def openTS(self):
        return self.call_getter('openTS')

    @property
    def revealStartTS(self):
        return self.call_getter('revealStartTS')

    @property
    def _openDuration(self):
        return self.call_getter('_openDuration')

    @property
    def _revealDuration(self):
        return self.call_getter('_revealDuration')

    @property
    def _closeTS(self):
        return self.call_getter('_closeTS')

    @property
    def _owner(self):
        return self.call_getter('_owner')

    @property
    def _lockerCode(self):
        return self.call_getter('_lockerCode')

    
