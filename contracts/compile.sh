#! /usr/bin/bash

set -e

base_dir=$(dirname $0)

source $base_dir/.project_config

everdev sol set --compiler $compiler_version

for s in $base_dir/*.sol
do
    echo $s
    everdev sol compile $s --output-dir $base_dir/artifacts
done

