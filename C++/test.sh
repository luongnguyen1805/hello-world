#!/bin/zsh

CHECK_COMPILER="$(which g++)"

if [[ "$CHECK_COMPILER" == *"not found"* ]]; then
    echo "g++ NOT FOUND"
    exit 1
fi

cd test

mkdir -p build

# Build and run Google Test
g++ -std=c++17 -Igoogletest/include -Igoogletest -pthread \
    googletest/src/gtest-all.cc \
    main.cpp -o build/test_runner

if [[ $? -ne 0 ]]; then
    echo "Test build failed"
    exit 1
fi

./build/test_runner
