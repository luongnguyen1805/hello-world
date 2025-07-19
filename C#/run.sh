#!/bin/zsh

CHECK_COMPILER="$(which dotnet)"

if [[ "$CHECK_COMPILER" == *"not found"* ]]; then
    echo "dotnet NOT FOUND"
    exit 1
fi

cd src
dotnet build

dotnet run "bin/Debug/net8.0/Main"
