#!/bin/sh
set -euo pipefail
export ASDF_DIR=/opt/homebrew/opt/asdf/libexec
export ASDF_DATA_DIR=$HOME/Library/asdf

PYTHON_ROOT=$ASDF_DATA_DIR/installs/python/$(cat .python-version)
PYTHON_BIN=$PYTHON_ROOT/bin/python
POETRY_BIN=$HOME/.local/bin/poetry
export PATH=/opt/homebrew/bin:$PYTHON_ROOT/bin:$ASDF_DATA_DIR/shims:$HOME/.local/bin:$PATH

if ! command -v brew; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi
if ! command -v asdf; then
    brew install asdf
fi
# todo test for ~/Library/asdf/plugins/python
if ! test -d $ASDF_DATA_DIR/plugins/python; then
    asdf plugin add python
fi
PY_VERSION=$(cat .python-version)
if ! test -d $ASDF_DATA_DIR/installs/python/$PY_VERSION; then
    asdf install python $PY_VERSION
fi
if ! command -v poetry; then
    curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | $PYTHON_BIN
fi

cd ./configsync
$POETRY_BIN install
$POETRY_BIN run configsync $*
