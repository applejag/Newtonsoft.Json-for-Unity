#!/usr/bin/env bash

# Set error flags
set -o nounset
set -o errexit
set -o pipefail

jsonFile="${1?Path to JSON required.}"
output="${2:-FULL}"

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
    jsonnet=$(jq2 -er '(.Major // 0|tostring) + "." + (.Minor // 0|tostring) + "." + (.Patch // 0|tostring)' "$jsonFile")
    release=$(jq2 -er '.Release // 0' "$jsonFile")

    printf "%s%02d" "$jsonnet" "$release"
    ;;
JSON_NET)
    jq2 -er '(.Major // 0|tostring) + "." + (.Minor // 0|tostring) + "." + (.Patch // 0|tostring)' "$jsonFile"
    ;;
ASSEMBLY)
    jq2 -er '(.Major // 0|tostring) + ".0.0.0"' "$jsonFile"
    ;;
SUFFIX)
    release="$(jq -er '.Release // empty' "$jsonFile")"

    if [ -z "$release" ]
    then
        # No suffix
        echo ""
    else
        printf "r%02d" "$release"
    fi
    ;;
RELEASE)
    jq2 -er '.Release // 0' "$jsonFile"
    ;;
AUTO_DEPLOY_LIVE_RUN)
    jq2 -r '.AutoDeployLiveRun' "$jsonFile"
    ;;
*)
    error "Error: Unknown output type '$output'
    Possible values: FULL, JSON_NET, ASSEMBLY, SUFFIX, RELEASE, AUTO_DEPLOY_LIVE_RUN"
    exit 3
    ;;
esac
