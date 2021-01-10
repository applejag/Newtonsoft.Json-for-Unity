#!/usr/bin/env bash

# Set error flags
set -o nounset
set -o errexit
set -o pipefail

: ${VERSION:?"Need the version to be checked"}

OK=1

echo

if git show-ref --verify --quiet refs/remotes/origin/upm
then
    echo "> Branch 'upm' exists, all ok!"
else
    echo "[!] Missing branch 'upm'."
    echo "[!] Make sure to create that branch in advance"
    echo "[!] Branches found:"
    git show-ref
    OK=0
fi

echo

if egrep -q "^## ${VERSION//\./\\.}$" CHANGELOG.md
then
    echo "> Changelog has been updated, all ok!"
else
    echo "[!] Changelog in CHANGELOG.md is missing line '## $VERSION'."
    echo "[!] Make sure to update the CHANGELOG.md"
    OK=0
fi

echo

for ENV_VAR in NPM_AUTH_TOKEN GITHUB_USER_EMAIL GITHUB_USER_NAME GITHUB_GPG_ID GITHUB_GPG_SEC_B64
do
    if [ -z "${!ENV_VAR}" ]
    then
        echo "[!] Missing environment variable \$$ENV_VAR."
        OK=0
    else
        echo "> Environment variable \$$ENV_VAR is set, all ok!"
    fi

    echo
done

echo

if [ $OK != 1 ]
then
    echo "At least one check failed. Aborting!"
    exit 1
fi

echo "Nice work! Happy deploying!"
