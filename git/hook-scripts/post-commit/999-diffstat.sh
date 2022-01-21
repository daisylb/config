#!/usr/bin/env zsh
MAIN_BRANCH=master
if git show-ref --verify --quiet refs/heads/main; then
    MAIN_BRANCH=main
fi
printf "\x1B[1mChanges from \x1B[35m$MAIN_BRANCH\x1B[0;1m:\x1B[0m\n"
git --no-pager diff --shortstat $(git merge-base $MAIN_BRANCH HEAD)