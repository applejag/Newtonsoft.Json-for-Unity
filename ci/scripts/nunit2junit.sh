#!/usr/bin/env bash
# Script taken from https://github.com/zifro-playground/car-controller
# Copyright Zifro © 2019

INPUT_FOLDER=${1?Folder of input NUnit XML files}
OUTPUT_FOLDER=${2?Folder of output JUnit XML files}
: ${TRANSFORMER:=$(dirname "$0")/nunit2junit.xslt}

if ! [ -x "$(command -v xmlstarlet)" ]
then
    echo "Error: xmlstarlet is not installed"
    exit 1
fi

echo "Using transformer '$TRANSFORMER'"
echo "Converting NUnit XML files from folder '$INPUT_FOLDER'"
echo "Outputting JUnit XML files into folder '$OUTPUT_FOLDER'"
echo

(cd $INPUT_FOLDER && find . -name '*.xml') | cut -c 3- |
while read path
do
    folder="$(dirname "$path")"
    file="$(basename "$path")"
    echo "Working on '$folder' :: '$file'"

    out_folder=$OUTPUT_FOLDER/$folder
    out_file=$out_folder/$file

    in_file=$INPUT_FOLDER/$path

    mkdir -p $out_folder
    xmlstarlet tr "$TRANSFORMER" "$in_file" > $out_file
done

echo "Convertion complete"
