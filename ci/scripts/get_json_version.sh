#!/bin/bash

# Set error flags
set -o nounset
set -o errexit
set -o pipefail

jsonFile="${1?Path to JSON required.}"
output="${2:-FULL}"
# output types
# - FULL    (major.minor.build-SUFFIX)
# - SHORT   (major.minor.build)
# - SUFFIX  (SUFFIX)

error() {
    >&2 echo "$0: $@"
}

if ! [ -x "$(command -v jq)" ]
then
    error "Error: jq is not installed"
    exit 1
fi

if ! [ -f "$jsonFile" ]
then
    error "Error: file not found '$jsonFile'"
    exit 2
fi

jq2() {
    result="$(jq "$@")"
    if [ -z "$result" ]
    then
        error "Error: No output"
        exit 4
    else
        echo "$result"
    fi
}

case "$output" in
FULL)
    suffix="$(jq2 -er '.Suffix // empty' "$jsonFile")"

    if [ -z "$suffix" ]
    then
        jq2 -er '(.Major // 0|tostring) + "." + (.Minor // 0|tostring) + "." + (.Build // 0|tostring)' "$jsonFile"
    else
        jq2 -er '(.Major // 0|tostring) + "." + (.Minor // 0|tostring) + "." + (.Build // 0|tostring) + "-" + (.Suffix // 0|tostring)' "$jsonFile"
    fi
    ;;
SHORT)
    jq2 -er '(.Major // 0|tostring) + "." + (.Minor // 0|tostring) + "." + (.Build // 0|tostring)' "$jsonFile"
    ;;
SUFFIX)
    jq2 -er '.Suffix // empty' "$jsonFile"
    ;;
*)
    error "Error: Unknown output type '$output'
    Possible values: FULL, SHORT, SUFFIX"
    exit 3
    ;;
esac
