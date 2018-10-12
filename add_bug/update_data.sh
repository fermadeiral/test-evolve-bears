#!/usr/bin/env bash

set -e

git checkout pr-add-bug;
git config --replace-all remote.origin.fetch +refs/heads/*:refs/remotes/origin/*;
git fetch;
python add_bug/update_webpage.py "$NEW_BRANCH_NAME" "$TRAVIS_REPO_SLUG";
git checkout pr-add-bug;
python add_bug/update_releases_folder.py "$NEW_BRANCH_NAME";
