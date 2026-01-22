#!/bin/zsh

set -e

CHECK_COMPILER="$(which java)"

if [[ "$CHECK_COMPILER" == *"not found"* ]]; then
    echo "java NOT FOUND"
    exit 1
fi

cd src
mkdir -p build
cp jna-5.17.0.jar ./build/
javac -d ./build -cp jna-5.17.0.jar Main.java Global.java

cd ./build
java -cp .:jna-5.17.0.jar Main