#! /usr/bin/bash

set -e 

base_dir=$(dirname $0)
source $base_dir/.project_config

dAuction=$1

initial_value=10000000000    # 10 ever


address=$(everdev contract deploy $base_dir/artifacts/Stake.abi.json\
 --data deAuction:$dAuction\
 --value $initial_value\
 --prevent-ui | grep -oP 'address: 0:\K.+')

echo "stake successfully deployed at address: $address"
echo "1. transfer funds to your stake"
echo "2. use lock_stake.sh to lock your stake with dAuction"
