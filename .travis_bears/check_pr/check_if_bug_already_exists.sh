#!/usr/bin/env bash

set -e

BRANCH_NAME="$TRAVIS_PULL_REQUEST_BRANCH"

RED='\033[0;31m'
GREEN='\033[0;32m'

git checkout -qf master

if grep -q "$BRANCH_NAME" ./releases/branches_per_version.json; then
    RESULT="> $BRANCH_NAME [FAILURE] (the bug already exists in Bears)"
    echo -e "$RED$RESULT"
    exit 1
fi

RESULT="> $BRANCH_NAME [OK]"
echo -e "$GREEN$RESULT"
