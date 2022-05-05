
import tonos_ts4.ts4 as ts4


class NeverBank(ts4.BaseContract):
    def __init__(
        self,

        _proxy=None,
        
        
        address=None,
        balance=None,
        keypair=None,
    ):
        keypair = keypair or ts4.make_keypair()
        if address:
            super().__init__(
                'NeverBank',
                ctor_params=None,
                initial_data=dict(),
                address=address,
                nickname='NeverBank',
            )
        else:
            super().__init__(
                'NeverBank',
                ctor_params=None,
                initial_data=dict(
                    _proxy=_proxy,
                    
                ),
                keypair=keypair,
                balance=balance,
                nickname='NeverBank',
            )

            super().call_method(
                'constructor',
                params=dict(
                    
                ),
                private_key=self.private_key_,
            )


    def updateAuction(
        self,
        auction,
        
        is_getter=False,
    ):
        if is_getter:
            return super().call_getter(
                method='updateAuction',
                params=dict(
                    auction=auction,
                    
                ),
            )
        else:
            return super().call_method(
                method='updateAuction',
                params=dict(
                    auction=auction,
                    
                ),
                private_key=self.private_key_,
            )

    def updateWinners(
        self,
        closeTS,
        neverWinner,
        neverWinnerNevers,
        neverWinnerEvers,
        everWinner,
        everWinnerEvers,
        everWinnerNevers,
        
        is_getter=False,
    ):
        if is_getter:
            return super().call_getter(
                method='updateWinners',
                params=dict(
                    closeTS=closeTS,
                    neverWinner=neverWinner,
                    neverWinnerNevers=neverWinnerNevers,
                    neverWinnerEvers=neverWinnerEvers,
                    everWinner=everWinner,
                    everWinnerEvers=everWinnerEvers,
                    everWinnerNevers=everWinnerNevers,
                    
                ),
            )
        else:
            return super().call_method(
                method='updateWinners',
                params=dict(
                    closeTS=closeTS,
                    neverWinner=neverWinner,
                    neverWinnerNevers=neverWinnerNevers,
                    neverWinnerEvers=neverWinnerEvers,
                    everWinner=everWinner,
                    everWinnerEvers=everWinnerEvers,
                    everWinnerNevers=everWinnerNevers,
                    
                ),
                private_key=self.private_key_,
            )

    def payNevers(
        self,
        
        is_getter=False,
    ):
        if is_getter:
            return super().call_getter(
                method='payNevers',
                params=dict(
                    
                ),
            )
        else:
            return super().call_method(
                method='payNevers',
                params=dict(
                    
                ),
                private_key=self.private_key_,
            )

    def payEvers(
        self,
        
        is_getter=False,
    ):
        if is_getter:
            return super().call_getter(
                method='payEvers',
                params=dict(
                    
                ),
            )
        else:
            return super().call_method(
                method='payEvers',
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
    def _proxy(self):
        return self.call_getter('_proxy')

    @property
    def _activeAuction(self):
        return self.call_getter('_activeAuction')

    @property
    def _auctionCloseTS(self):
        return self.call_getter('_auctionCloseTS')

    @property
    def _winnerBuyDuration(self):
        return self.call_getter('_winnerBuyDuration')

    @property
    def _loserBuyDuration(self):
        return self.call_getter('_loserBuyDuration')

    @property
    def _neverWinnerNevers(self):
        return self.call_getter('_neverWinnerNevers')

    @property
    def _neverWinnerEvers(self):
        return self.call_getter('_neverWinnerEvers')

    @property
    def _neverWinner(self):
        return self.call_getter('_neverWinner')

    @property
    def _everWinnerNevers(self):
        return self.call_getter('_everWinnerNevers')

    @property
    def _everWinnerEvers(self):
        return self.call_getter('_everWinnerEvers')

    @property
    def _everWinner(self):
        return self.call_getter('_everWinner')

    
