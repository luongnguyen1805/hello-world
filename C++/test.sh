#!/bin/zsh

CHECK_COMPILER="$(which g++)"

if [[ "$CHECK_COMPILER" == *"not found"* ]]; then
    echo "g++ NOT FOUND"
    exit 1
fi

# Build and run Google Test
g++ -std=c++17 -Igoogletest/include -Igoogletest -pthread \
    googletest/src/gtest-all.cc \
    test/main_test.cpp -o test_runner

if [[ $? -ne 0 ]]; then
    echo "Test build failed"
    exit 1
fi

./test_runner
