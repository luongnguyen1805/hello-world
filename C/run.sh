#!/bin/zsh

CHECK_COMPILER="$(which gcc)"

if [[ "$CHECK_COMPILER" == *"not found"* ]]; then
    echo "gcc NOT FOUND"
    exit 1
fi

cd src
mkdir -p build

gcc global.c main.c \
    -o "./build/main"

./build/main