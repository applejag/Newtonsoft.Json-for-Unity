#!/usr/bin/env bash
# Script taken from https://github.com/zifro-playground/car-controller
# Copyright Zifro © 2019

# Set error flags
set -o nounset
set +o errexit
set -o pipefail

PROJECT=${1?Project path}

if ! [ -x "$(command -v jq)" ]
then
    echo "Error: jq is not installed"
    exit 1
fi

manifest=$PROJECT/Packages/manifest.json

if ! [ -f $manifest ]
then
    echo "Error: manifest.json not found"
    exit 1
fi

# First fully read and modify, save in memory, then close file handle
# for reading. Then echo back into stdout and write to file.
echo "$(jq -M 'del(.lock)' $manifest)" > $manifest
# Using this because you cannot write to the file while it's reading it.
# Like this:
# jq -M 'del(.lock)' $manifest > $manifest
# That results in a blank file

echo
echo "Removed 'lock' from 'Packages/manifest.json'"
echo

echo ">>>>>> Running Unity to update UPM packages and compile sources"
echo
rm -f ~/.config/unity3d/Editor.log

${UNITY_EXECUTABLE:-xvfb-run -as '-screen 0 640x480x24' /opt/Unity/Editor/Unity} \
        -projectPath $PROJECT \
        -buildTarget Linux64 \
        -batchmode \
        -nographics \
        -quit \
        -logfile /dev/stdout

EXIT_STATUS=$?

echo "[LOGS FROM ~/.config/unity3d/Editor.log]"
cat ~/.config/unity3d/Editor.log
echo

if [ $EXIT_STATUS -ne 0 ]
then
    echo ">>>>>> Compilation failed"
    exit $EXIT_STATUS
else
    echo ">>>>>> Compilation finished successfully"
fi

