
import tonos_ts4.ts4 as ts4


class Calculator(ts4.BaseContract):
    def __init__(
        self,

        
        
        address=None,
        balance=None,
        keypair=None,
    ):
        keypair = keypair or ts4.make_keypair()
        if address:
            super().__init__(
                'Calculator',
                ctor_params=None,
                initial_data=dict(),
                address=address,
                nickname='Calculator',
            )
        else:
            super().__init__(
                'Calculator',
                ctor_params=None,
                initial_data=dict(
                    
                ),
                keypair=keypair,
                balance=balance,
                nickname='Calculator',
            )

            super().call_method(
                'constructor',
                params=dict(
                    
                ),
                private_key=self.private_key_,
            )


    def hashOfAddess(
        self,
        a,
        salt,
        
        is_getter=False,
    ):
        if is_getter:
            return super().call_getter(
                method='hashOfAddess',
                params=dict(
                    a=a,
                    salt=salt,
                    
                ),
            )
        else:
            return super().call_method(
                method='hashOfAddess',
                params=dict(
                    a=a,
                    salt=salt,
                    
                ),
                private_key=self.private_key_,
            )

    def bidHash(
        self,
        nevers,
        evers,
        salt,
        
        is_getter=False,
    ):
        if is_getter:
            return super().call_getter(
                method='bidHash',
                params=dict(
                    nevers=nevers,
                    evers=evers,
                    salt=salt,
                    
                ),
            )
        else:
            return super().call_method(
                method='bidHash',
                params=dict(
                    nevers=nevers,
                    evers=evers,
                    salt=salt,
                    
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

    
