#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
    echo "Usage: ./check_commits.sh <branch name>"
    exit 2
fi

function checkCommit {
    echo "$1"
    if [ -z "$1" ]; then
        RESULT="$BRANCH_NAME [FAILURE] (some commit is missing)"
        >&2 echo -e "$RED $RESULT $NC"
        exit 1
    else
        echo "The commit is OK."
    fi
}

function checkParent {
    echo "$1"
    if [ "$1" != "$2" ]; then
        RESULT="$BRANCH_NAME [FAILURE] (the commits are not in the right sequence)"
        >&2 echo -e "$RED $RESULT $NC"
        exit 1
    else
        echo "The commit is OK."
    fi
}

BRANCH_NAME=$1

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

numberOfCommits=`git rev-list --count HEAD`
if [ "$numberOfCommits" -lt 4 ] ; then
    RESULT="$BRANCH_NAME [FAILURE] (the number of commits is less than 4)"
    >&2 echo -e "$RED $RESULT $NC"
    exit 1
fi

git log

bugCommitId=""

case=$(cat bears.json | sed 's/.*"type": "\(.*\)".*/\1/;t;d')
echo "Branch from case $case"
if [ "$case" == "failing_passing" ]; then
    echo "3 commits must exist."

    echo "Checking commits..."

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

    bugCommitId=`git log --format=format:%H --grep="Bug commit"`
else
    echo "4 commits must exist."

    echo "Checking commits..."

    bugCommitId=`git log --format=format:%H --grep="Bug commit"`
    testCommitId=`git log --format=format:%H --grep="Changes in the tests"`
    patchCommitId=`git log --format=format:%H --grep="Human patch"`
    endCommitId=`git log --format=format:%H --grep="End of the bug and patch reproduction process"`

    checkCommit "$bugCommitId"
    checkCommit "$testCommitId"
    checkCommit "$patchCommitId"
    checkCommit "$endCommitId"

    parentEndCommit=`git log --pretty=%P -n 1 "$endCommitId"`
    parentPatchCommit=`git log --pretty=%P -n 1 "$testCommitId"`
    parentTestCommit=`git log --pretty=%P -n 1 "$patchCommitId"`

    checkParent "$parentEndCommit" "$patchCommitId"
    checkParent "$parentPatchCommit" "$testCommitId"
    checkParent "$parentTestCommit" "$bugCommitId"

    bugCommitId=`git log --format=format:%H --grep="Changes in the tests"`
fi

RESULT="$BRANCH_NAME [OK]"
echo -e "$GREEN $RESULT $NC"
