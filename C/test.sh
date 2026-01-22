#!/bin/zsh

CHECK_COMPILER="$(which gcc)"

if [[ "$CHECK_COMPILER" == *"not found"* ]]; then
    echo "gcc NOT FOUND"
    exit 1
fi

cd test
mkdir -p build

# Build and run Google Test
gcc -Icmocka/include -Icmocka \
    cmocka/src/*.c \
    main.c -o ./build/test_runner \
    -Wno-unused-parameter

if [[ $? -ne 0 ]]; then
    echo "Test build failed"
    exit 1
fi

./build/test_runner
