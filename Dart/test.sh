#!/bin/zsh

CHECK_COMPILER="$(which dart)"

if [[ "$CHECK_COMPILER" == *"not found"* ]]; then
    echo "dart NOT FOUND"
    exit 1
fi

cd test
dart main.dart