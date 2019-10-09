#!/bin/bash

# Set error flags
set -o nounset
set -o errexit
set -o pipefail

build="${1?"Build name required. Possible values: 'Standalone', 'AOT', 'Portable', 'Editor', ''."}"
framework="${BUILD_FRAMEWORK:-}"

error() {
    >&2 echo "$0: $@"
}

if ! [ -z "$framework" ]
then
    # Build framework already defined
    echo "$framework"
    exit 0
fi

case "$build" in
Standalone)
    framework="net462"
    ;;
AOT)
    framework="net462"
    ;;
Portable)
    framework="portable-net45+win8+wpa81+wp8"
    ;;
Editor)
    framework="net45"
    ;;
*)
    error "Invalid build name.
    Possible values: 'Standalone', 'AOT', 'Portable', 'Editor', ''."
    exit 1
    ;;
esac

echo "$framework"
