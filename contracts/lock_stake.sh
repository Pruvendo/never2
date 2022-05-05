#! /usr/bin/bash

set -e 

base_dir=$(dirname $0)
source $base_dir/.project_config


#  your suggested exchange parameters, depending on 'is_never' flag:
#  true: you wish to exchange your 'nanonevers' for 'nanoevers'.
#  false: you wish to exchange your 'nanoevers' for 'nanonevers'.
##  note: you need to transfer your coins to stake contract before you do a lock operation 
##  note2: final bid is calculated depending on dAuction aggregator
stake=$1
nanonevers=$2
nanoevers=$3
is_never=$4


address=$(everdev contract run $base_dir/artifacts/Stake.abi.json lock\
 --address $stake\
 --input nanonevers:$nanonevers,nanoevers:$nanoevers,isNever:$is_never\
 --prevent-ui | grep -oP 'address: 0:\K.+')
