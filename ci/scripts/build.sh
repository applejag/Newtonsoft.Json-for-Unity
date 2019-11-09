#!/bin/bash

# Set error flags
set -o nounset
set -o errexit
set -o pipefail

BUILD_UNITY=${1:-${BUILD_UNITY:?"Build name required. Possible values: 'Standalone', 'AOT', 'Portable', 'Editor'."}}
BUILD_SOLUTION=${2:-${BUILD_SOLUTION:?"Build solution required. Example: .csproj or .sln file."}}
BUILD_DESTINATION=${3:-${BUILD_DESTINATION:-"${BUILD_DESTINATION_BASE:?"Build output path required."}/Newtonsoft.Json $BUILD_UNITY"}}

: ${VERSION:?"Full version required."}
: ${VERSION_SHORT:?"Short version required."}
: ${VERSION_SUFFIX:?"Version suffix required."}
: ${BUILD_CONFIGURATION:="Release"}

error() {
    >&2 echo "$0: $@"
    exit 1
}

if ! [ -f "$BUILD_SOLUTION" ]
then
    error "Build solution '$BUILD_SOLUTION' not found!"
fi

BUILD_FRAMEWORK="${BUILD_FRAMEWORK:-"$($SCRIPTS/get_framework_from_build.sh "${BUILD_UNITY}")"}"

echo "############"
echo "$0: BUILDING PROJECT '$BUILD_SOLUTION'"
echo "$0: BUILD '$BUILD_UNITY' ($BUILD_FRAMEWORK, $BUILD_CONFIGURATION)"
echo "$0: OUTPUT '$BUILD_DESTINATION'"
echo "############"
echo

msbuild -t:build "$BUILD_SOLUTION" \
    -p:Configuration="$BUILD_CONFIGURATION" \
    -p:LibraryFrameworks="$BUILD_FRAMEWORK" \
    -p:OutputPath="$BUILD_DESTINATION" \
    -p:UnityBuild="$BUILD_UNITY" \
    -p:VersionPrefix="$VERSION_SHORT" \
    -p:VersionSuffix="$VERSION_SUFFIX" \
    -p:AssemblyVersion="$VERSION_SHORT" \
    -p:FileVersion="$VERSION"

echo
echo "############"
echo "$0: DONE: BUILDING PROJECT '$BUILD_SOLUTION'"
echo "$0: DONE: BUILD '$BUILD_UNITY' ($BUILD_FRAMEWORK, $BUILD_CONFIGURATION)"
echo "$0: DONE: OUTPUT '$BUILD_DESTINATION'"
echo "############"
