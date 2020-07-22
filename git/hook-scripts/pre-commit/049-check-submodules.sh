#!/bin/sh
git submodule --quiet foreach "test \"\$(git branch -r --contains HEAD)\" != '' || { echo \$sm_path not in any remote; exit 1; }"