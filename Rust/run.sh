#!/bin/zsh

CHECK_COMPILER="$(which rustc)"

if [[ "$CHECK_COMPILER" == *"not found"* ]]; then
    echo "rustc NOT FOUND"
    exit 1
fi

rustc main.rs
./main
