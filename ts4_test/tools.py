import tonos_ts4.ts4 as ts4

from common_contracts import SafeMultisig

def send_evers(dest, value):
    SafeMultisig(value + 10 ** 9).send_transaction(dest, value)
    ts4.dispatch_messages()
