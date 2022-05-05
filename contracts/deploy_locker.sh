#! /usr/bin/bash

set -e 

base_dir=$(dirname $0)
source $base_dir/.project_config

initial_value=10000000000

auctionAddrHash=$1
ownerAddrHash=$2
bidHash=$3
isNever=$4


address=$(everdev contract deploy $base_dir/artifacts/BidLocker.abi.json\
 --data auctionAddrHash:$auctionAddrHash,ownerAddrHash:$ownerAddrHash,bidHash:$bidHash\
 --input never:$isNever,\
 --value $initial_value\
 --prevent-ui | grep -oP 'address: 0:\K.+')

 echo "bid locker deployed on address $address"
