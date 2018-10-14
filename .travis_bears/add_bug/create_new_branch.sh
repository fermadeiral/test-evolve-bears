#!/usr/bin/env bash

set -e

BUGGY_COMMIT_ID=$(git log --format=format:%H --grep="Bug commit")
TEST_COMMIT_ID=$(git log --format=format:%H --grep="Changes in the tests")
PATCHED_COMMIT_ID=$(git log --format=format:%H --grep="Human patch")
END_COMMIT_ID=$(git log --format=format:%H --grep="End of the bug and patch reproduction process")

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
