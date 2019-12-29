#!/bin/sh
export PATH=$HOME/.pyenv/versions/$(cat .python-version)/bin:$HOME/.poetry/bin:$HOME/.local/bin:$PATH
if ! command -v brew; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
if ! command -v pyenv; then
    brew install pyenv
fi
PY_VERSION=$(cat .python-version)
if ! test -d ~/.pyenv/versions/$PY_VERSION; then
    pyenv install $PY_VERSION
fi
if ! command -v poetry; then
    curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | ~/.pyenv/versions/$PY_VERSION/bin/python
fi
python --version
cd configsync
poetry install
poetry run configsync $*
