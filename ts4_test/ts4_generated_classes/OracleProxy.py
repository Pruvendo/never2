
import tonos_ts4.ts4 as ts4


class OracleProxy(ts4.BaseContract):
    def __init__(
        self,

        _oracle=None,
        
        
        address=None,
        balance=None,
        keypair=None,
    ):
        keypair = keypair or ts4.make_keypair()
        if address:
            super().__init__(
                'OracleProxy',
                ctor_params=None,
                initial_data=dict(),
                address=address,
                nickname='OracleProxy',
            )
        else:
            super().__init__(
                'OracleProxy',
                ctor_params=None,
                initial_data=dict(
                    _oracle=_oracle,
                    
                ),
                keypair=keypair,
                balance=balance,
                nickname='OracleProxy',
            )

            super().call_method(
                'constructor',
                params=dict(
                    
                ),
                private_key=self.private_key_,
            )


    def registerBank(
        self,
        bank,
        
        is_getter=False,
    ):
        if is_getter:
            return super().call_getter(
                method='registerBank',
                params=dict(
                    bank=bank,
                    
                ),
            )
        else:
            return super().call_method(
                method='registerBank',
                params=dict(
                    bank=bank,
                    
                ),
                private_key=self.private_key_,
            )

    def acceptOracle(
        self,
        USDToNanoever,
        
        is_getter=False,
    ):
        if is_getter:
            return super().call_getter(
                method='acceptOracle',
                params=dict(
                    USDToNanoever=USDToNanoever,
                    
                ),
            )
        else:
            return super().call_method(
                method='acceptOracle',
                params=dict(
                    USDToNanoever=USDToNanoever,
                    
                ),
                private_key=self.private_key_,
            )

    def initiateAuctions(
        self,
        pubkey,
        
        is_getter=False,
    ):
        if is_getter:
            return super().call_getter(
                method='initiateAuctions',
                params=dict(
                    pubkey=pubkey,
                    
                ),
            )
        else:
            return super().call_method(
                method='initiateAuctions',
                params=dict(
                    pubkey=pubkey,
                    
                ),
                private_key=self.private_key_,
            )

    def _setAuctionCode(
        self,
        code,
        
        is_getter=False,
    ):
        if is_getter:
            return super().call_getter(
                method='_setAuctionCode',
                params=dict(
                    code=code,
                    
                ),
            )
        else:
            return super().call_method(
                method='_setAuctionCode',
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
    def _oracle(self):
        return self.call_getter('_oracle')

    @property
    def _bank(self):
        return self.call_getter('_bank')

    @property
    def _USDToNanoever(self):
        return self.call_getter('_USDToNanoever')

    @property
    def auctionIteration(self):
        return self.call_getter('auctionIteration')

    @property
    def lastAuction(self):
        return self.call_getter('lastAuction')

    @property
    def newAuctionIsDue(self):
        return self.call_getter('newAuctionIsDue')

    @property
    def auctionCodeHash(self):
        return self.call_getter('auctionCodeHash')

    @property
    def _auctionCode(self):
        return self.call_getter('_auctionCode')

    @property
    def _auctionCodeSet(self):
        return self.call_getter('_auctionCodeSet')

    @property
    def _auctionDeployValue(self):
        return self.call_getter('_auctionDeployValue')

    
