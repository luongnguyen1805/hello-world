#!/bin/zsh

CHECK_COMPILER="$(which go)"

if [[ "$CHECK_COMPILER" == *"not found"* ]]; then
    echo "go NOT FOUND"
    exit 1
fi

cd src
go build
./main