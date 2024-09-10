#!/bin/zsh

CHECK_COMPILER="$(which gcc)"

if [[ "$CHECK_COMPILER" == *"not found"* ]]; then
    echo "gcc NOT FOUND"
    exit 1
fi

gcc main.c -o main
./main