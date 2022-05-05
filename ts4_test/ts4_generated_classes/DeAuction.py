
import tonos_ts4.ts4 as ts4


class DeAuction(ts4.BaseContract):
    def __init__(
        self,

        _auction=None,
        _neverAggregator=None,
        _everAggregator=None,
        
        
        address=None,
        balance=None,
        keypair=None,
    ):
        keypair = keypair or ts4.make_keypair()
        if address:
            super().__init__(
                'DeAuction',
                ctor_params=None,
                initial_data=dict(),
                address=address,
                nickname='DeAuction',
            )
        else:
            super().__init__(
                'DeAuction',
                ctor_params=None,
                initial_data=dict(
                    _auction=_auction,
                    _neverAggregator=_neverAggregator,
                    _everAggregator=_everAggregator,
                    
                ),
                keypair=keypair,
                balance=balance,
                nickname='DeAuction',
            )

            super().call_method(
                'constructor',
                params=dict(
                    
                ),
                private_key=self.private_key_,
            )


    def newStake(
        self,
        nevers,
        nanoevers,
        isNever,
        key,
        
        is_getter=False,
    ):
        if is_getter:
            return super().call_getter(
                method='newStake',
                params=dict(
                    nevers=nevers,
                    nanoevers=nanoevers,
                    isNever=isNever,
                    key=key,
                    
                ),
            )
        else:
            return super().call_method(
                method='newStake',
                params=dict(
                    nevers=nevers,
                    nanoevers=nanoevers,
                    isNever=isNever,
                    key=key,
                    
                ),
                private_key=self.private_key_,
            )

    def withdraw(
        self,
        nevers,
        nanoevers,
        isNever,
        key,
        
        is_getter=False,
    ):
        if is_getter:
            return super().call_getter(
                method='withdraw',
                params=dict(
                    nevers=nevers,
                    nanoevers=nanoevers,
                    isNever=isNever,
                    key=key,
                    
                ),
            )
        else:
            return super().call_method(
                method='withdraw',
                params=dict(
                    nevers=nevers,
                    nanoevers=nanoevers,
                    isNever=isNever,
                    key=key,
                    
                ),
                private_key=self.private_key_,
            )

    def updateStatus(
        self,
        win,
        
        is_getter=False,
    ):
        if is_getter:
            return super().call_getter(
                method='updateStatus',
                params=dict(
                    win=win,
                    
                ),
            )
        else:
            return super().call_method(
                method='updateStatus',
                params=dict(
                    win=win,
                    
                ),
                private_key=self.private_key_,
            )

    def setStakeCode(
        self,
        code,
        
        is_getter=False,
    ):
        if is_getter:
            return super().call_getter(
                method='setStakeCode',
                params=dict(
                    code=code,
                    
                ),
            )
        else:
            return super().call_method(
                method='setStakeCode',
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
    def _auction(self):
        return self.call_getter('_auction')

    @property
    def _neverAggregator(self):
        return self.call_getter('_neverAggregator')

    @property
    def _everAggregator(self):
        return self.call_getter('_everAggregator')

    @property
    def neverLocker(self):
        return self.call_getter('neverLocker')

    @property
    def everLocker(self):
        return self.call_getter('everLocker')

    @property
    def _stakeCode(self):
        return self.call_getter('_stakeCode')

    @property
    def stakeCodeSet(self):
        return self.call_getter('stakeCodeSet')

    @property
    def status(self):
        return self.call_getter('status')

    
