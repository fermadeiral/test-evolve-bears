#!/usr/bin/env bash

if [ "$#" -ne 2 ]; then
    echo "Usage: ./check_with_maven.sh <branch name> <1 for buggy commit, 0 for patched commit>"
    exit 2
fi

BRANCH_NAME=$1
IS_BUGGY_COMMIT=$2

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

MAVEN_TEST_ARGS="-Denforcer.skip=true -Dcheckstyle.skip=true -Dcobertura.skip=true -DskipITs=true -Drat.skip=true -Dlicense.skip=true -Dfindbugs.skip=true -Dgpg.skip=true -Dskip.npm=true -Dskip.gulp=true -Dskip.bower=true"

cd pr

buggyCommitId=""

case=$(cat bears.json | sed 's/.*"type": "\(.*\)".*/\1/;t;d')
echo "Branch from case $case"
if [ "$case" == "failing_passing" ]; then
    buggyCommitId=`git log --format=format:%H --grep="Bug commit"`
else
    buggyCommitId=`git log --format=format:%H --grep="Changes in the tests"`
fi

patchedCommitId=`git log --format=format:%H --grep="Human patch"`

if [ "$IS_BUGGY_COMMIT" -eq 1 ]; then

    echo "Checking out the buggy commit: $buggyCommitId"
    git log --format=%B -n 1 $buggyCommitId

    git checkout -q $buggyCommitId

    mvn install -V -DskipTests=true -B  $MAVEN_TEST_ARGS

    mvn -B test $MAVEN_TEST_ARGS

    status=$?
    if [ "$status" -eq 0 ]; then
        RESULT="$BRANCH_NAME [FAILURE] (bug reproduction - status = $status)"
        >&2 echo -e "$RED $RESULT $NC"
        exit 1
    fi

else

    echo "Checking out the patched commit: $patchedCommitId"
    git log --format=%B -n 1 $patchedCommitId

    git checkout -q $patchedCommitId

    mvn install -V -DskipTests=true -B  $MAVEN_TEST_ARGS

    mvn -B test $MAVEN_TEST_ARGS

    status=$?
    if [ "$status" -ne 0 ]; then
        RESULT="$BRANCH_NAME [FAILURE] (patch reproduction - status = $status)"
        >&2 echo -e "$RED $RESULT $NC"
        exit 1
    fi
fi

RESULT="$BRANCH_NAME [OK]"
echo -e "$GREEN $RESULT $NC"
