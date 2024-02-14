#!/usr/bin/env zsh
cd ~ # ensure that we use the global python version from asdf
pipx install xonsh
pipx inject xonsh xonsh-direnv prompt-toolkit