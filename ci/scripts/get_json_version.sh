#!/bin/bash

# Set error flags
set -o nounset
set -o errexit
set -o pipefail

jsonFile="${1?Path to JSON required.}"
output="${2:-FULL}"
# output types
# - FULL        "{major}.{release}.{patch}"
# - JSON_NET    "{major}.0.{release}"
# - SUFFIX  if {patch}:
#               "patch-{patch}" (3 digit left padded)
#           else:
#               <no output>

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
    jq2 -er '(.Major // 0|tostring) + "." + (.Release // 0|tostring) + "." + (.Patch // 0|tostring)' "$jsonFile"
    ;;
JSON_NET)
    jq2 -er '(.Major // 0|tostring) + ".0." + (.Release // 0|tostring)' "$jsonFile"
    ;;
SUFFIX)
    patch="$(jq2 -er '.Patch // empty' "$jsonFile")"
    
    if [ -z "$patch" ]
    then
        # No suffix
        echo ""
    else
        printf "patch-%03d" "$patch"
    fi
    ;;
*)
    error "Error: Unknown output type '$output'
    Possible values: FULL, JSON_NET, SUFFIX"
    exit 3
    ;;
esac
