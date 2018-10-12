#!/usr/bin/env bash

function checkCommit {
    echo "$1"
    if [ -z "$1" ]; then
        RESULT="$BRANCH_NAME [FAILURE] (some commit is missing)"
        >&2 echo -e "$RED $RESULT"
        exit 1
    else
        echo "The commit is OK."
    fi
}

function checkParent {
    echo "$1"
    if [ "$1" != "$2" ]; then
        RESULT="$BRANCH_NAME [FAILURE] (the commits are not in the right sequence)"
        >&2 echo -e "$RED $RESULT"
        exit 1
    else
        echo "The commit is OK."
    fi
}

BRANCH_NAME=$1

RED='\033[0;31m'
GREEN='\033[0;32m'

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

case=$(cat bears.json | sed 's/.*"type": "\(.*\)".*/\1/;t;d')
echo "Branch from $case case."

if [ "$case" == "failing_passing" ]; then
    echo "> 3 commits must exist."

    echo "> Checking commits..."

    bugCommitId=`git log --format=format:%H --grep="Bug commit"`
    patchCommitId=`git log --format=format:%H --grep="Human patch"`
    endCommitId=`git log --format=format:%H --grep="End of the bug and patch reproduction process"`

    checkCommit "$bugCommitId"
    checkCommit "$patchCommitId"
    checkCommit "$endCommitId"

    parentEndCommit=`git log --pretty=%P -n 1 "$endCommitId"`
    parentPatchCommit=`git log --pretty=%P -n 1 "$patchCommitId"`

    checkParent "$parentEndCommit" "$patchCommitId"
    checkParent "$parentPatchCommit" "$bugCommitId"
else
    echo "> 4 commits must exist."

    echo "> Checking commits..."

    bugCommitId=`git log --format=format:%H --grep="Bug commit"`
    testCommitId=`git log --format=format:%H --grep="Changes in the tests"`
    patchCommitId=`git log --format=format:%H --grep="Human patch"`
    endCommitId=`git log --format=format:%H --grep="End of the bug and patch reproduction process"`

    checkCommit "$bugCommitId"
    checkCommit "$testCommitId"
    checkCommit "$patchCommitId"
    checkCommit "$endCommitId"

    parentEndCommit=`git log --pretty=%P -n 1 "$endCommitId"`
    parentPatchCommit=`git log --pretty=%P -n 1 "$patchCommitId"`
    parentTestCommit=`git log --pretty=%P -n 1 "$testCommitId"`

    checkParent "$parentEndCommit" "$patchCommitId"
    checkParent "$parentPatchCommit" "$testCommitId"
    checkParent "$parentTestCommit" "$bugCommitId"
fi

RESULT="$BRANCH_NAME [OK]"
echo -e "$GREEN $RESULT"
