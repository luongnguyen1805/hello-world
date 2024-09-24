#!/bin/zsh

CHECK_COMPILER="$(which gcc)"

if [[ "$CHECK_COMPILER" == *"not found"* ]]; then
    echo "gcc NOT FOUND"
    exit 1
fi

if [ $# -gt 0 ]; then
    echo "Argument: $1"
fi

cd src
gcc main.c -o main
./main