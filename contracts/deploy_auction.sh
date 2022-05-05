#! /usr/bin/bash

set -e 

base_dir=$(dirname $0)
source $base_dir/.project_config

proxy=$1

address=$(everdev contract run $base_dir/artifacts/OracleProxy.abi.json initiateAuctions\
 --address $proxy\
 --prevent-ui | grep -oP 'address: 0:\K.+')
