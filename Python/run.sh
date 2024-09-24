#!/bin/zsh

CHECK_COMPILER="$(which python3)"

if [[ "$CHECK_COMPILER" == *"not found"* ]]; then
    echo "python3 NOT FOUND"
    exit 1
fi

cd src
python3 main.py
