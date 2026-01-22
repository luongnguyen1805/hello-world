#!/bin/zsh

CHECK_COMPILER="$(which deno)"

if [[ "$CHECK_COMPILER" == *"not found"* ]]; then
    echo "deno NOT FOUND"
    exit 1
fi

cd test
deno main.ts
