#!/bin/sh
export ASDF_DIR=/usr/local/opt/asdf 
export ASDF_DATA_DIR=$HOME/Library/asdf

PYTHON_ROOT=$ASDF_DATA_DIR/installs/python/$PY_VERSION
PYTHON_BIN=$PYTHON_ROOT/bin
export PATH=$PYTHON_BIN:$HOME/.poetry/bin:$HOME/.local/bin:$PATH

if ! command -v brew; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
if ! command -v asdf; then
    brew install asdf
fi
PY_VERSION=$(cat .python-version)
if ! test -d $ASDF_DATA_DIR/installs/python/$PY_VERSION; then
    asdf install python $PY_VERSION
fi
if ! command -v poetry; then
    curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | ~/.pyenv/versions/$PY_VERSION/bin/python
fi
python --version
cd ./configsync
poetry install
poetry run configsync $*
