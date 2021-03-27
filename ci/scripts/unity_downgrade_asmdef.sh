#!/usr/bin/env bash
# Downgrades from Unity 2019.x asmdef to 2018.x asmdef format

# Set error flags
set -o nounset
set -o errexit
set -o pipefail

echo_stderr() {
    echo "$@" >&2
}

usage() {
    echo "Usage: $(basename $0) <FILE>"
    echo "Downgrades <FILE> in place from a Unity 2019.x style .asmdef file to Unity 2018.x style"
    echo
    echo "  -b,--backup          saves the previous file in a backup file at '.*.asmdef.old'"
    echo "  -r,--reset           reverts the changes saved in the backup file"
}

usage_error() {
    echo_stderr "$@"
    echo_stderr
    usage >&2
    exit 1
}

positional() {
    if [ -z "$1" ]
    then
        usage_error "Missing required parameter <$2>"
    fi
    echo "$1"
}

BACKUP=false
RESET=false
POSITIONAL=()
while [[ $# -gt 0 ]]
do
    key="$1"
    
    case $key in
        -b|--backup)
        if [ "$RESET" = true ]
        then
            usage_error "Cannot use --backup in combination with --reset"
        fi
        BACKUP=true
        shift
        ;;
        -r|--reset)
        if [ "$BACKUP" = true ]
        then
            usage_error "Cannot use --reset in combination with --backup"
        fi
        RESET=true
        shift
        ;;
        *)
        POSITIONAL+=("$1") # save it in an array for later
        shift # past argument
        ;;
    esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

BACKUP_FILENAME="$(dirname "$1")/.$(basename "$1").old"
ASMDEF="$(positional "${1:-}" FILE)"

if [ "$RESET" = true ]
then
    if ! [ -f "$BACKUP_FILENAME" ]
    then
        echo "Error: backup not found '$BACKUP_FILENAME'"
        exit 1
    fi

    mv -f "$BACKUP_FILENAME" "$ASMDEF"

    echo "Successfully reset '$ASMDEF' to backup"
else
    if ! [ -f "$ASMDEF" ]
    then
        echo "Error: file not found '$ASMDEF'"
        exit 1
    fi

    if ! [ -x "$(command -v jq)" ]
    then
        echo "Error: jq is not installed"
        exit 1
    fi

    if [ "$BACKUP" = true ]
    then
        if [ -f "$BACKUP_FILENAME" ]
        then
            echo "Error: backup already exists '$BACKUP_FILENAME'"
            exit 1
        fi

        cp -f "$ASMDEF" "$BACKUP_FILENAME"
        echo "Created backup of '$ASMDEF' to '$(basename "$BACKUP_FILENAME")'"
    fi

    echo "$(jq '
        .references-=["UnityEngine.TestRunner", "UnityEditor.TestRunner"] |
        .precompiledReferences=[] |
        .optionalUnityReferences=["TestAssemblies"] |
        .overrideReferences=false |
        .autoReferenced=true |
        del(.versionDefines)
    ' $ASMDEF)" > $ASMDEF

    echo "Successfully downgraded '$ASMDEF' to 2018.x style"
fi
