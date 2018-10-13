#!/usr/bin/env bash

set -e

# git stash is used in the case that something wrong had happen in the previous scripts
# so it's still possible to reset the branch pr-add-bug
git stash;

git checkout pr-add-bug
PARENTS_OF_THE_MERGED_COMMIT=$(git log --pretty=%P -n 1)
LAST_COMMIT_BEFORE_MERGING=${PARENTS_OF_THE_MERGED_COMMIT%' '*}
git reset --hard "$LAST_COMMIT_BEFORE_MERGING"
git push -f github pr-add-bug
