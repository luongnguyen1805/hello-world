#!/bin/zsh

CHECK_COMPILER="$(which g++)"

if [[ "$CHECK_COMPILER" == *"not found"* ]]; then
    echo "g++ NOT FOUND"
    exit 1
fi

cd src

mkdir -p build

g++ -std=c++11 global.cpp main.cpp -o ./build/main
./build/main