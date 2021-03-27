#!/usr/bin/env bash
# Script taken from https://github.com/zifro-playground/car-controller
# Copyright Zifro © 2019

# Set error flags
set -o nounset
set -o errexit
set -o pipefail

dll="${1?Path to DLL required.}"

if ! [ -x "$(command -v pwsh)" ]
then
    echo "Error: powershell is not installed"
    exit 1
fi

if ! [ -f "$dll" ]
then
    echo "Error: file not found '$dll'"
    exit 1
fi

pwsh -Command "[System.Reflection.Assembly]::LoadFrom(\"$dll\").GetName().Version.ToString()"
