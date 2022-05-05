#! /usr/bin/bash

set -e 

base_dir=$(dirname $0)
source $base_dir/.project_config

stake=$1

address=$(everdev contract run $base_dir/artifacts/Stake.abi.json withdraw\
 --address $stake\
 --prevent-ui | grep -oP 'address: 0:\K.+')
