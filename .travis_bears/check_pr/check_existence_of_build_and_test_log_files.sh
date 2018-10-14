#!/usr/bin/env bash

set -e

BUILD_LOG_FILE_NAME="repairnator.maven.buildproject.log"
TEST_LOG_FILE_NAME="repairnator.maven.testproject.log"

SEARCH_BUILD_LOG_IN_BUGGY_COMMIT=$(git log -n 1 --grep="Bug commit" --format=format:%H -- "$BUILD_LOG_FILE_NAME")
if [ -z "$SEARCH_BUILD_LOG_IN_BUGGY_COMMIT" ]; then
    RESULT="$BRANCH_NAME [FAILURE] (buggy commit does not change the file $BUILD_LOG_FILE_NAME)"
    echo -e "$RED$RESULT"
    exit 1
else
    echo "> The file $BUILD_LOG_FILE_NAME was changed in the buggy commit."
fi

SEARCH_BUILD_LOG_IN_PATCHED_COMMIT=$(git log -n 1 --grep="Human patch" --format=format:%H -- "$BUILD_LOG_FILE_NAME")
if [ -z "$SEARCH_BUILD_LOG_IN_PATCHED_COMMIT" ]; then
    RESULT="$BRANCH_NAME [FAILURE] (patched commit does not change the file $BUILD_LOG_FILE_NAME)"
    echo -e "$RED$RESULT"
    exit 1
else
    echo "> The file $BUILD_LOG_FILE_NAME was changed in the patched commit."
fi
