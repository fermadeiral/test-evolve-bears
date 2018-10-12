#!/usr/bin/env bash

set -e

git stash;
git checkout pr-add-bug;
parentsOfMergingCommit=$(git log --pretty=%P -n 1);
lastCommitBeforeMerging=${parentsOfMergingCommit%' '*};
git reset --hard "$lastCommitBeforeMerging";
git push -f github pr-add-bug;