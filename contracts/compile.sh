#! /usr/bin/bash

set -e

base_dir=$(dirname $0)

source $base_dir/.project_config

everdev sol set --compiler $compiler_version

compile_dir () {
    for s in $1/*.sol
    do
        echo $s
        everdev sol compile $s --output-dir $1/artifacts
    done

}

compile_dir $base_dir
compile_dir $base_dir/aggregators
