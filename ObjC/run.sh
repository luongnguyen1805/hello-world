#!/bin/zsh

CHECK_COMPILER="$(which clang)"

if [[ "$CHECK_COMPILER" == *"not found"* ]]; then
    echo "clang NOT FOUND"
    exit 1
fi

cd src

mkdir -p build

clang -fobjc-arc -framework Foundation Global.m main.m -o ./build/main

./build/main