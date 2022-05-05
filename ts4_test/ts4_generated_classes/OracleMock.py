
import tonos_ts4.ts4 as ts4


class OracleMock(ts4.BaseContract):
    def __init__(
        self,

        
        
        address=None,
        balance=None,
        keypair=None,
    ):
        keypair = keypair or ts4.make_keypair()
        if address:
            super().__init__(
                'OracleMock',
                ctor_params=None,
                initial_data=dict(),
                address=address,
                nickname='OracleMock',
            )
        else:
            super().__init__(
                'OracleMock',
                ctor_params=None,
                initial_data=dict(
                    
                ),
                keypair=keypair,
                balance=balance,
                nickname='OracleMock',
            )

            super().call_method(
                'constructor',
                params=dict(
                    
                ),
                private_key=self.private_key_,
            )


    def acceptOracle(
        self,
        oracleProxy,
        USDToNanoever,
        
        is_getter=False,
    ):
        if is_getter:
            return super().call_getter(
                method='acceptOracle',
                params=dict(
                    oracleProxy=oracleProxy,
                    USDToNanoever=USDToNanoever,
                    
                ),
            )
        else:
            return super().call_method(
                method='acceptOracle',
                params=dict(
                    oracleProxy=oracleProxy,
                    USDToNanoever=USDToNanoever,
                    
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

    
