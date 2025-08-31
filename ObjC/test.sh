#!/bin/zsh

CHECK_COMPILER="$(which clang)"

if [[ "$CHECK_COMPILER" == *"not found"* ]]; then
    echo "clang NOT FOUND"
    exit 1
fi

cd test
clang -fobjc-arc -framework Foundation main.m -o main

./main