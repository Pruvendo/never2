#! /usr/bin/bash

set -e 

base_dir=$(dirname $0)
source $base_dir/.project_config

locker=$1
owner=$2
auction=$3
nanonevers=$4
nanoevers=$5
salt=$6


everdev contract run $base_dir/artifacts/BidLocker.abi.json verify\
 --address $locker\
 --input owner:$owner,auction:$auction,nanonevers:$nanonevers,nanoevers:$nanoevers,salt:$salt\
 --prevent-ui
