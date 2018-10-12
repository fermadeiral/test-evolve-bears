#!/usr/bin/env bash

set -e

function checkCommit {
    if [ -z "$1" ]; then
        RESULT="$BRANCH_NAME [FAILURE] (some commit is missing)"
        echo -e "$RED$RESULT"
        exit 1
    else
        echo "> The commit is OK."
    fi
}

function checkParent {
    if [ "$1" != "$2" ]; then
        RESULT="$BRANCH_NAME [FAILURE] (the commits are not in the right sequence)"
        echo -e "$RED$RESULT"
        exit 1
    else
        echo "> The parent commit is OK."
    fi
}

BRANCH_NAME="$TRAVIS_PULL_REQUEST_BRANCH"

RED='\033[0;31m'
GREEN='\033[0;32m'

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

case=$(cat bears.json | sed 's/.*"type": "\(.*\)".*/\1/;t;d')
echo "> Branch from $case case."

if [ "$case" == "failing_passing" ]; then
    echo "> 3 commits must exist."

    echo "> Checking commits..."

    bugCommitId=`git log --format=format:%H --grep="Bug commit"`
    patchCommitId=`git log --format=format:%H --grep="Human patch"`
    endCommitId=`git log --format=format:%H --grep="End of the bug and patch reproduction process"`

    echo "Buggy commit: $bugCommitId"
    checkCommit "$bugCommitId"
    echo "Patched commit: $patchCommitId"
    checkCommit "$patchCommitId"
    echo "End of the process commit: $endCommitId"
    checkCommit "$endCommitId"

    echo "> Checking parent commits..."

    parentEndCommit=`git log --pretty=%P -n 1 "$endCommitId"`
    parentPatchCommit=`git log --pretty=%P -n 1 "$patchCommitId"`

    echo "End of the process commit's parent: $parentEndCommit"
    checkParent "$parentEndCommit" "$patchCommitId"
    echo "Patched commit's parent: $parentPatchCommit"
    checkParent "$parentPatchCommit" "$bugCommitId"
else
    echo "> 4 commits must exist."

    echo "> Checking commits..."

    bugCommitId=`git log --format=format:%H --grep="Bug commit"`
    testCommitId=`git log --format=format:%H --grep="Changes in the tests"`
    patchCommitId=`git log --format=format:%H --grep="Human patch"`
    endCommitId=`git log --format=format:%H --grep="End of the bug and patch reproduction process"`

    echo "Buggy commit: $bugCommitId"
    checkCommit "$bugCommitId"
    echo "Changes in the tests commit: $testCommitId"
    checkCommit "$testCommitId"
    echo "Patched commit: $patchCommitId"
    checkCommit "$patchCommitId"
    echo "End of the process commit: $endCommitId"
    checkCommit "$endCommitId"

    echo "> Checking parent commits..."

    parentEndCommit=`git log --pretty=%P -n 1 "$endCommitId"`
    parentPatchCommit=`git log --pretty=%P -n 1 "$patchCommitId"`
    parentTestCommit=`git log --pretty=%P -n 1 "$testCommitId"`

    echo "End of the process commit's parent: $parentEndCommit"
    checkParent "$parentEndCommit" "$patchCommitId"
    echo "Patched commit's parent: $parentPatchCommit"
    checkParent "$parentPatchCommit" "$testCommitId"
    echo "Changes in the tests commit's parent: $parentTestCommit"
    checkParent "$parentTestCommit" "$bugCommitId"
fi

RESULT="$BRANCH_NAME [OK]"
echo -e "$GREEN$RESULT"
