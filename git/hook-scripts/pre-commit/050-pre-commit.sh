#!/bin/zsh
if [[ -f pre-commit-config.yaml ]]; then
    pre-commit run --config pre-commit-config.yaml --hook-stage commit
fi