#! /usr/bin/bash

set -e 

base_dir=$(dirname $0)
source $base_dir/.project_config

oracle_mock="0000000000000000000000000000000000000000000000000000000000000000"
initial_value=100000000000


address=$(everdev contract deploy $base_dir/artifacts/OracleProxy.abi.json\
 --data _oracle:$oracle_mock\
 --value $initial_value\
 --prevent-ui | grep -oP 'address: 0:\K.+')

echo "oracle proxy deployed on address: $address"

bank=$(everdev contract deploy $base_dir/artifacts/NeverBank.abi.json\
 --data _proxy:$address\
 --value $initial_value\
 --prevent-ui | grep -oP 'address: 0:\K.+')

echo "bank deployed on address: $bank"


everdev contract run $base_dir/artifacts/OracleProxy.abi.json registerBank\
 --address $address\
 --input bank:$bank\
 --prevent-ui

auction_code=$($TVM_LINKER decode --tvc $base_dir/artifacts/BlindAuction.tvc | grep -oP 'code: \K\S+')

everdev contract run $base_dir/artifacts/OracleProxy.abi.json _setAuctionCode\
 --address $address\
 --input code:$auction_code\
 --prevent-ui

echo "oracle proxy deployed and setup on address: $address"
