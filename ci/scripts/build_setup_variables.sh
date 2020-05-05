#!/bin/bash

# Set error flags
set -o nounset
set -o errexit
set -o pipefail

VAR_SOURCE="${1:-json}"
UPDATE_PACKAGE_JSON="${2:-false}"

env() {
    echo "export '$1=$2'" >> $BASH_ENV
    echo "$1='$2'"
    export "$1=$2"
}

if [ "$VAR_SOURCE" == "xml" ]; then
    xml() {
        xmlstarlet sel -t -v "/Project/PropertyGroup/$1" -n Src/Newtonsoft.Json/Newtonsoft.Json.csproj | head -n 1
    }

    echo ">>> OBTAINING VERSION FROM $(pwd)/Src/Newtonsoft.Json/Newtonsoft.Json.csproj"
    env VERSION "$(xml VersionPrefix)"
    env VERSION_SUFFIX "$(xml VersionSuffix)"
    env VERSION_JSON_NET "$(xml VersionPrefix)"
    env VERSION_ASSEMBLY "$(xml AssemblyVersion)"
    echo
elif [ "$VAR_SOURCE" == "json" ]; then
    json() {
        $SCRIPTS/get_json_version.sh ./ci/version.json "$1"
    }

    echo ">>> OBTAINING VERSION FROM $(pwd)/ci/version.json"
    env VERSION "$(json FULL)"
    env VERSION_SUFFIX "$(json SUFFIX)"
    env VERSION_JSON_NET "$(json JSON_NET)"
    env VERSION_ASSEMBLY "$(json ASSEMBLY)"
    echo
else
    echo "Invalid argument: '${VAR_SOURCE}'" >&2
    echo "Valid values: 'json', 'xml'" >&2
    exit 1
fi

if [ "$UPDATE_PACKAGE_JSON" == 'true' ]; then
    echo ">>> UPDATING VERSION IN $(pwd)/Src/Newtonsoft.Json-for-Unity/package.json"
    echo "BEFORE:"
    echo ".version=$(jq ".version" Src/Newtonsoft.Json-for-Unity/package.json)"
    echo ".displayName=$(jq ".displayName" Src/Newtonsoft.Json-for-Unity/package.json)"
    echo "$(jq ".version=\"$VERSION\" | .displayName=\"Json.NET $VERSION_JSON_NET for Unity\"" Src/Newtonsoft.Json-for-Unity/package.json)" > Src/Newtonsoft.Json-for-Unity/package.json
    echo "AFTER:"
    echo ".version=$(jq ".version" Src/Newtonsoft.Json-for-Unity/package.json)"
    echo ".displayName=$(jq ".displayName" Src/Newtonsoft.Json-for-Unity/package.json)"
fi
