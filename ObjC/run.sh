#!/bin/zsh

CHECK_COMPILER="$(which clang)"

if [[ "$CHECK_COMPILER" == *"not found"* ]]; then
    echo "clang NOT FOUND"
    exit 1
fi

cd src
clang main.m -o main
./main