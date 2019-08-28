#!/bin/sh
export PATH=$HOME/.pyenv/versions/$(cat .python-version)/bin:$HOME/.poetry/bin:$HOME/.local/bin:$PATH
python --version
cd configsync
poetry install
poetry run configsync $*
