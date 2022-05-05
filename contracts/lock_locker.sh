#! /usr/bin/bash

set -e 

base_dir=$(dirname $0)
source $base_dir/.project_config

locker=$1


everdev contract run $base_dir/artifacts/BidLocker.abi.json lock\
 --address $locker\
 --input 
 --prevent-ui
