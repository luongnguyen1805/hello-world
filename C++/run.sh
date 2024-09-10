#!/bin/zsh

CHECK_COMPILER="$(which g++)"

if [[ "$CHECK_COMPILER" == *"not found"* ]]; then
    echo "g++ NOT FOUND"
    exit 1
fi

g++ main.cpp -o main
./main