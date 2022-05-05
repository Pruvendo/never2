
import tonos_ts4.ts4 as ts4


class Stake(ts4.BaseContract):
    def __init__(
        self,

        deAuction=None,
        
        
        address=None,
        balance=None,
        keypair=None,
    ):
        keypair = keypair or ts4.make_keypair()
        if address:
            super().__init__(
                'Stake',
                ctor_params=None,
                initial_data=dict(),
                address=address,
                nickname='Stake',
            )
        else:
            super().__init__(
                'Stake',
                ctor_params=None,
                initial_data=dict(
                    deAuction=deAuction,
                    
                ),
                keypair=keypair,
                balance=balance,
                nickname='Stake',
            )

            super().call_method(
                'constructor',
                params=dict(
                    
                ),
                private_key=self.private_key_,
            )


    def lock(
        self,
        nevers,
        nanoevers,
        isNever,
        
        is_getter=False,
    ):
        if is_getter:
            return super().call_getter(
                method='lock',
                params=dict(
                    nevers=nevers,
                    nanoevers=nanoevers,
                    isNever=isNever,
                    
                ),
            )
        else:
            return super().call_method(
                method='lock',
                params=dict(
                    nevers=nevers,
                    nanoevers=nanoevers,
                    isNever=isNever,
                    
                ),
                private_key=self.private_key_,
            )

    def withdraw(
        self,
        
        is_getter=False,
    ):
        if is_getter:
            return super().call_getter(
                method='withdraw',
                params=dict(
                    
                ),
            )
        else:
            return super().call_method(
                method='withdraw',
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
    def deAuction(self):
        return self.call_getter('deAuction')

    @property
    def _nevers(self):
        return self.call_getter('_nevers')

    @property
    def _nanoevers(self):
        return self.call_getter('_nanoevers')

    @property
    def _isNever(self):
        return self.call_getter('_isNever')

    @property
    def _locked(self):
        return self.call_getter('_locked')

    @property
    def _withdrawn(self):
        return self.call_getter('_withdrawn')

    
