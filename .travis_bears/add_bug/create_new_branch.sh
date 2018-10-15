#!/usr/bin/env bash

set -e

BUGGY_COMMIT_ID=$(git log --format=format:%H --grep="$BUGGY_COMMIT_MESSAGE_PATTERN")
TEST_COMMIT_ID=$(git log --format=format:%H --grep="$TEST_COMMIT_MESSAGE_PATTERN")
PATCHED_COMMIT_ID=$(git log --format=format:%H --grep="$PATCHED_COMMIT_MESSAGE_PATTERN")
END_COMMIT_ID=$(git log --format=format:%H --grep="$END_COMMIT_MESSAGE_PATTERN")

git checkout --orphan "$NEW_BRANCH_NAME"
git reset .
git clean -fd
git cherry-pick "$BUGGY_COMMIT_ID"
git cherry-pick "$TEST_COMMIT_ID"
git cherry-pick "$PATCHED_COMMIT_ID"
git cherry-pick "$END_COMMIT_ID"
git push github "$NEW_BRANCH_NAME":"$NEW_BRANCH_NAME"

git checkout pr-add-bug
python ./.travis_bears/add_bug/update_bears_json_file.py "$NEW_BRANCH_NAME"
