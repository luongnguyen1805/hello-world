#!/bin/zsh

CHECK_COMPILER="$(which npx)"

if [[ "$CHECK_COMPILER" == *"not found"* ]]; then
    echo "npx NOT FOUND"
    exit 1
fi

cd test
npx tsc 

node build/main.js

