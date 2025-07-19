#!/bin/zsh

CHECK_COMPILER="$(which java)"

if [[ "$CHECK_COMPILER" == *"not found"* ]]; then
    echo "java NOT FOUND"
    exit 1
fi

cd test
javac Main.java
java -ea Main