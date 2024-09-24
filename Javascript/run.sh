#!/bin/zsh

CHECK_COMPILER="$(which node)"

if [[ "$CHECK_COMPILER" == *"not found"* ]]; then
    echo "node NOT FOUND"
    exit 1
fi

cd src
node main.js