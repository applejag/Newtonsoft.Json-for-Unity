#!/bin/bash

# Set error flags
set -o nounset
set -o errexit
set -o pipefail

build="${1?"Build name required. Possible values: 'Standalone', 'AOT', 'Portable', 'Editor'."}"

error() {
    >&2 echo "$0: $@"
    exit 1
}

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
    Possible values: 'Standalone', 'AOT', 'Portable', 'Editor'."
    ;;
esac

echo "$framework"
