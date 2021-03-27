#!/usr/bin/env bash

# Set error flags
set -o nounset
set -o errexit
set -o pipefail

build="${1?"Build name required. Possible values: 'Standalone', 'AOT', 'Editor', 'Tests'."}"

error() {
    >&2 echo "$0: ERROR: $@"
    exit 1
}

case "$build" in
Standalone)
    framework="netstandard2.0"
    ;;
AOT)
    framework="netstandard2.0"
    ;;
Portable)
    error "Portable Json .NET build has been deprecated since 13.0.1."
    exit 1
    ;;
Editor)
    framework="netstandard2.0"
    ;;
Tests)
    framework="net46"
    ;;
*)
    error "Invalid build name.
    Possible values: 'Standalone', 'AOT', 'Editor', 'Tests'."
    ;;
esac

echo "$framework"
