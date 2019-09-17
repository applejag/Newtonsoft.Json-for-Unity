#!/bin/bash
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

${UNITY_EXECUTABLE:-xvfb-run -as '-screen 0 640x480x24' /opt/Unity/Editor/Unity} \
        -projectPath $PROJECT \
        -buildTarget Linux \
        -batchmode \
        -quit \
        -logfile

EXIT_STATUS=$?

echo
echo ">>>>>> Compilation finished successfully"

exit $EXIT_STATUS
