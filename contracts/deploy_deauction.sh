#! /usr/bin/bash

set -e 

base_dir=$(dirname $0)
source $base_dir/.project_config


initial_value=10000000000
aggregate_value=1000000000
salt_ever=123
salt_never=134

auction=$1


address=$(everdev contract deploy $base_dir/artifacts/DeAuction.abi.json\
 --data _auction:$auction\
 --input saltEver:$salt_ever,saltNever:$salt_never\
 --value $initial_value\
 --prevent-ui | grep -oP 'address: 0:\K.+')

echo "deauction deployed at address: $address"


stake_code=$($TVM_LINKER decode --tvc $base_dir/artifacts/Stake.tvc | grep -oP 'code: \K\S+')
locker_code=$($TVM_LINKER decode --tvc $base_dir/artifacts/BidLocker.tvc | grep -oP 'code: \K\S+')

everdev contract run $base_dir/artifacts/DeAuction.abi.json setStakeCode\
 --address $address\
 --input code:$stake_code\
 --prevent-ui

everdev contract run $base_dir/artifacts/DeAuction.abi.json setLockerCode\
 --address $address\
 --input code:$locker_code\
 --prevent-ui


# aggregators:

never_aggregate=$(everdev contract deploy $base_dir/aggregators/artifacts/WeightedAggregate.abi.json\
 --data _deAuction:"$address",_isNever:true\
 --value $aggregate_value\
 --prevent-ui | grep -oP 'address: 0:\K.+')

ever_aggregate=$(everdev contract deploy $base_dir/aggregators/artifacts/WeightedAggregate.abi.json\
 --data _deAuction:"$address",_isNever:false\
 --value $aggregate_value\
 --prevent-ui | grep -oP 'address: 0:\K.+')

echo "never aggregator: $never_aggregate"
echo "ever aggregator: $ever_aggregate"

everdev contract run $base_dir/artifacts/DeAuction.abi.json setAggregators\
 --address $address\
 --input neverAggregator:"$never_aggregate",everAggregator:"$ever_aggregate"\
 --prevent-ui

echo "dAuction ready and deploy at address: $address"
