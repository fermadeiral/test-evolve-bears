#!/usr/bin/env bash

if [ "$#" -ne 2 ]; then
    echo "Usage: ./check_branches.sh <branch name> <1 for buggy commit, 0 for patched commit>"
    exit 2
fi

BRANCH_NAME=$1
IS_BUGGY_COMMIT=$2

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

MAVEN_TEST_ARGS="-Denforcer.skip=true -Dcheckstyle.skip=true -Dcobertura.skip=true -DskipITs=true -Drat.skip=true -Dlicense.skip=true -Dfindbugs.skip=true -Dgpg.skip=true -Dskip.npm=true -Dskip.gulp=true -Dskip.bower=true"

cd pr

bugCommitId=""

case=$(cat bears.json | sed 's/.*"type": "\(.*\)".*/\1/;t;d')
echo "Branch from case $case"
if [ "$case" == "failing_passing" ]; then
    bugCommitId=`git log --format=format:%H --grep="Bug commit"`
else
    bugCommitId=`git log --format=format:%H --grep="Changes in the tests"`
fi

patchCommitId=`git log --format=format:%H --grep="Human patch"`

if [ "$IS_BUGGY_COMMIT" -eq 1 ]; then

    echo "Checking out the bug commit: $bugCommitId"
    git log --format=%B -n 1 $bugCommitId

    git checkout -q $bugCommitId

    mvn install -V -DskipTests=true -B  $MAVEN_TEST_ARGS

    timeout 1800s mvn -B test $MAVEN_TEST_ARGS

    status=$?
    if [ "$status" -eq 124 ]; then
        RESULT="$BRANCH_NAME [FAILURE] (bug reproduction timeout)"
        >&2 echo -e "$RED $RESULT $NC"
        exit 1
    elif [ "$status" -eq 0 ]; then
        RESULT="$BRANCH_NAME [FAILURE] (bug reproduction - status = $status)"
        >&2 echo -e "$RED $RESULT $NC"
        exit 1
    fi

else

    echo "Checking out the patch commit: $patchCommitId"
    git log --format=%B -n 1 $patchCommitId

    git checkout -q $patchCommitId

    mvn install -V -DskipTests=true -B  $MAVEN_TEST_ARGS

    timeout 1800s mvn -B test $MAVEN_TEST_ARGS

    status=$?
    if [ "$status" -eq 124 ]; then
        RESULT="$BRANCH_NAME [FAILURE] (patch reproduction timeout)"
        >&2 echo -e "$RED $RESULT $NC"
        exit 1
    elif [ "$status" -ne 0 ]; then
        RESULT="$BRANCH_NAME [FAILURE] (patch reproduction - status = $status)"
        >&2 echo -e "$RED $RESULT $NC"
        exit 1
    fi
fi

RESULT="$BRANCH_NAME [OK]"
echo -e "$GREEN $RESULT $NC"
