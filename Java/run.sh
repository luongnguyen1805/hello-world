#!/bin/zsh

CHECK_COMPILER="$(which java)"

if [[ "$CHECK_COMPILER" == *"not found"* ]]; then
    echo "java NOT FOUND"
    exit 1
fi

javac Main.java
java Program