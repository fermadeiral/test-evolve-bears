#!/usr/bin/env bash

set -e

BRANCH_NAME="$TRAVIS_PULL_REQUEST_BRANCH"

RED='\033[0;31m'
GREEN='\033[0;32m'

branches_per_version_file_path="./releases/branches_per_version.json"

git checkout -qf master

FOUND=$(cat "$branches_per_version_file_path" | grep "$BRANCH_NAME");

if [ ! -z "$FOUND" ]; then
    RESULT="> $BRANCH_NAME [FAILURE] (the bug already exists in Bears)"
    echo -e "$RED$RESULT"
    exit 1
fi

RESULT="> $BRANCH_NAME [OK]"
echo -e "$GREEN$RESULT"
