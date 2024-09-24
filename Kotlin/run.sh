#!/bin/zsh

CHECK_COMPILER="$(which kotlinc)"

if [[ "$CHECK_COMPILER" == *"not found"* ]]; then
    echo "kotlinc NOT FOUND"
    exit 1
fi

cd src
kotlinc main.kt -include-runtime -d main.jar
java -jar main.jar