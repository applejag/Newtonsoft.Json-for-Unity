#!/usr/bin/env bash
# Script taken from https://github.com/zifro-playground/car-controller
# Copyright Zifro © 2019

# Set error flags
set -o nounset
set +o errexit
set -o pipefail

function guid {
    if [ -x "$(command -v POWERSHELL)" ]
    then
        POWERSHELL -COMMAND "[guid]::NewGuid().ToString(\"n\")"
    else
        local id=$(cat /proc/sys/kernel/random/uuid);
        echo ${id//-}
    fi
}

function metatemplate {
    : ${1?File extension required.}

    # Convert "dll" -> ".dll"
    local ext=".${1/#.}";

    # Default header used for all
    echo "
fileFormatVersion: 2
guid: $(guid)"

    case $ext in
        ".") # Folder
        echo "
folderAsset: yes
DefaultImporter:
  externalObjects: {}
  userData: 
  assetBundleName: 
  assetBundleVariant: "
            ;;
        ".dll") # Assemblies
            echo "
PluginImporter:
  externalObjects: {}
  serializedVersion: 2
  iconMap: {}
  executionOrder: {}
  defineConstraints: []
  isPreloaded: 0
  isOverridable: 0
  isExplicitlyReferenced: 0
  platformData:
  - first:
      Any: 
    second:
      enabled: 1
      settings: {}
  - first:
      Editor: Editor
    second:
      enabled: 0
      settings:
        DefaultValueInitialized: true
  - first:
      Windows Store Apps: WindowsStoreApps
    second:
      enabled: 0
      settings:
        CPU: AnyCPU
  userData: 
  assetBundleName: 
  assetBundleVariant: 
"
            ;;
        ".xml"|".json") # XML & JSON
            echo "
TextScriptImporter:
  externalObjects: {}
  userData: 
  assetBundleName: 
  assetBundleVariant: 
"
            ;;
        ".cs") # C# files
            echo "
MonoImporter:
  externalObjects: {}
  serializedVersion: 2
  defaultReferences: []
  executionOrder: 0
  icon: {instanceID: 0}
  userData: 
  assetBundleName: 
  assetBundleVariant:             
"
            ;;
        ".asmdef") # Assembly definitions
            echo "
AssemblyDefinitionImporter:
  externalObjects: {}
  userData: 
  assetBundleName: 
  assetBundleVariant:
"
            ;;
        ".prefab") # Unity prefabs
        echo "
PrefabImporter:
  externalObjects: {}
  userData: 
  assetBundleName: 
  assetBundleVariant: 
"
            ;;
        *) # Any other file type
            echo "
DefaultImporter:
  externalObjects: {}
  userData: 
  assetBundleName: 
  assetBundleVariant:             
"
            ;;

    esac
}

# is folder empty. orphaned .meta files does not count
function isfolderempty {
    : ${1?Folder path required.}
    if [ -z "$(find "$1" -not -name '*.meta' -and -type f)" ]
    then
        return 0 # true, found none
    else
        return 1 # false, found some
    fi
}

# files or non-empty folders without .meta files
function findorphanfiles {
    local folder="${1-.}"
    find "$folder" -not -name '*.meta' -and -not -path '*/\.*' -and -not -path '.' |
    while read path
    do
        # skip topmost
        if [[ "$folder" == "$path" ]]
        then
            continue
        fi
        # missing .meta file?
        if [ ! -f "${path}.meta" ]
        then
            # is file?
            if [ -f "$path" ]
            then
                echo $path
            # is folder and not empty?
            elif [ -d "$path" ]
            then
                if ! isfolderempty "$path"
                then
                    echo "$path"
                fi
            fi
        fi
    done
}

# .meta files without a file or empty folder
function findorphanmeta {
    find "${1-.}" -name '*.meta' -and -type f |
    while read path
    do
        local other="${path/%.meta}"
        
        # is empty folder?
        if [ -d "$other" ]
        then
            if isfolderempty "$other"
            then
                echo $path
            fi
        # missing file?
        elif [ ! -f "$other" ]
        then
            echo $path
        fi
    done
}

function generatemeta {
    local COUNTER=$((0))
    local folder="${1-.}"
    while read path
    do
        if [ -d "$path" ]
        then
            # folder
            metatemplate "" > "${path}.meta"
            ((COUNTER++))
            echo "Generated for folder: ${path}.meta"
        else
            # file
            metatemplate ${path##*.} > "${path}.meta"
            ((COUNTER++))
            echo "Generated for \"${path##*.}\" file: ${path}.meta"
        fi
    done < <(findorphanfiles "$folder")
    echo "<<< Generated $COUNTER meta files."
}

function removeorphans {
    local COUNTER=$((0))
    while read path
    do
        local other="${path/%.meta}"
        if [ -d "$other" ]
        then
            # remove empty folder
            rm -rf "$other"
        fi

        # remove meta file
        rm "$path"
        ((COUNTER++))
        echo "Removed orphaned \".meta\" file: $path"
    done < <(findorphanmeta "${1-.}")
    echo "<<< Removed $COUNTER orphaned meta files."
}

#-----------------------------

: ${1?Folder to generate metafiles in required.}

echo ">>> Generate .meta files"
generatemeta "$1"
removeorphans "$1"
