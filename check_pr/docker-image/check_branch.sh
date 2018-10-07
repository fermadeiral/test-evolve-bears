#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
    echo "Usage: ./check_branches.sh <branch name>"
    exit 2
fi

BRANCH_NAME=$1

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

MAVEN_TEST_ARGS="-Denforcer.skip=true -Dcheckstyle.skip=true -Dcobertura.skip=true -DskipITs=true -Drat.skip=true -Dlicense.skip=true -Dfindbugs.skip=true -Dgpg.skip=true -Dskip.npm=true -Dskip.gulp=true -Dskip.bower=true"

cd pr

git log

bugCommitId=""

case=$(cat bears.json | sed 's/.*"type": "\(.*\)".*/\1/;t;d')
echo "Branch from case $case"
if [ "$case" == "failing_passing" ]; then
    bugCommitId=`git log --format=format:%H --grep="Bug commit"`
else
    bugCommitId=`git log --format=format:%H --grep="Changes in the tests"`
fi

patchCommitId=`git log --format=format:%H --grep="Human patch"`

echo "Checking out the bug commit: $bugCommitId"
git log --format=%B -n 1 $bugCommitId

git checkout -q $bugCommitId

timeout 1800s mvn -q -B test -Dsurefire.printSummary=false $MAVEN_TEST_ARGS

status=$?
if [ "$status" -eq 0 ]; then
    RESULT="$BRANCH_NAME [FAILURE] (bug reproduction - status = $status)"
    >&2 echo -e "$RED $RESULT $NC"
    exit 1
elif [ "$status" -eq 124 ]; then
    RESULT="$BRANCH_NAME [FAILURE] (bug reproduction timeout)"
    >&2 echo -e "$RED $RESULT $NC"
    exit 1
fi

echo "Checking out the patch commit: $patchCommitId"
git log --format=%B -n 1 $patchCommitId

git checkout -q $patchCommitId

timeout 1800s mvn -q -B test -Dsurefire.printSummary=false $MAVEN_TEST_ARGS

status=$?
if [ "$status" -eq 0 ]; then
    RESULT="$BRANCH_NAME [FAILURE] (patch reproduction - status = $status)"
    >&2 echo -e "$RED $RESULT $NC"
    exit 1
elif [ "$status" -eq 124 ]; then
    RESULT="$BRANCH_NAME [FAILURE] (patch reproduction timeout)"
    >&2 echo -e "$RED $RESULT $NC"
    exit 1
fi

RESULT="$BRANCH_NAME [OK]"
echo -e "$GREEN $RESULT $NC"
