#!/bin/sh
### lolcommits hook (begin) ###
if [ ! -d "$GIT_DIR/rebase-merge" ]; then
export LANG="en_AU.UTF-8"
export PATH="/usr/local/bin:/usr/local/bin:$PATH"
lolcommits --capture 
fi
###  lolcommits hook (end)  ###