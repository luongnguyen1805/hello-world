#!/bin/zsh

CHECK_COMPILER="$(which kotlinc)"

if [[ "$CHECK_COMPILER" == *"not found"* ]]; then
    echo "kotlinc NOT FOUND"
    exit 1
fi

cd src
mkdir -p build

cp ./kotlinx-coroutines-core-jvm-1.9.0.jar ./build/
cp ./jline-3.30.5.jar ./build/
kotlinc -cp ./kotlinx-coroutines-core-jvm-1.9.0.jar:./jline-3.30.5.jar \
    -include-runtime -d ./build/main.jar main.kt

cd build
MAIN_CLASS=$(jar tf "main.jar" | grep 'Kt.class$' | sed 's/\.class$//' | head -n 1)
java -cp main.jar:kotlinx-coroutines-core-jvm-1.9.0.jar:jline-3.30.5.jar "$MAIN_CLASS"