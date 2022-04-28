#! /usr/bin/bash

everdev se reset

set -e

TVM_LINKER=/home/zbork/git/TVM-linker/target/release/tvm_linker
MSIG_ABI=./setcodemultisig/SetcodeMultisigWallet.abi.json
# EXTRA_TVC=./setcodemultisigextra2/SetcodeMultisigWallet.tvc
# EXTRA_ABI=./setcodemultisigextra2/SetcodeMultisigWallet.abi.json

EXTRA_TVC=./extra-wallet/ExtraWallet.tvc
EXTRA_ABI=./extra-wallet/ExtraWallet.abi.json


#deploy initial multisig
everdev contract deploy $MSIG_ABI\
     -i owners:[0x70a854ad8639b298472429d516bfa59126d53845e2e96a52f8d785c54d0567cf],reqConfirms:1\
     -v 100000000000

CODE=$($TVM_LINKER decode --tvc $EXTRA_TVC | grep -oP 'code: \K\S+')
CODE_HASH=$($TVM_LINKER decode --tvc $EXTRA_TVC | grep -oP 'code_hash: \K\S+')


#setcode

UPDATE_ID=$(everdev contract run $MSIG_ABI submitUpdate -p\
    -i codeHash:0x$CODE_HASH,owners:[0x70a854ad8639b298472429d516bfa59126d53845e2e96a52f8d785c54d0567cf],reqConfirms:1 | grep -oP '"updateId": "\K\d+')

everdev contract run $MSIG_ABI executeUpdate -p\
    -i updateId:$UPDATE_ID,code:$CODE


# test transfer

# reworked setcode multisig
# everdev contract run $EXTRA_ABI sendTransaction -p\
#     -a 0:ccfa757d20b1b754316c0427c94bfd958e9c406a21d6aea2cebd2d5138cdba01\
#     -i dest:ccfa757d20b1b754316c0427c94bfd958e9c406a21d6aea2cebd2d5138cdba01,value:10000000000,flags:1,bounce:false,payload:"" #,currency_id:0,currency_value:23


# new light extra-wallet
everdev contract run $EXTRA_ABI transfer -p\
    -a 0:ccfa757d20b1b754316c0427c94bfd958e9c406a21d6aea2cebd2d5138cdba01\
    -i dest:ccfa757d20b1b754316c0427c94bfd958e9c406a21d6aea2cebd2d5138cdba01,value:10000000000
