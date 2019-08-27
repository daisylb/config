# Local machine configuration

This repository is essentially my dotfiles for my local machine, with a bit of extra configuration magic.

## How to use

- Clone this repository somewhere.
- Run `./run.sh list`.
- Look at the diff of `config.toml`, and remove unwanted packages.
- Run `./run.sh uninstall`.

`run.sh` invokes a Python project in the `configsync` subdirectory, whose behaviour is described in detail in the following section. It installs everything that is listed in `config.toml`; additionally, things that are not listed in `config.toml` are either added to that file (if `list` is passed) or uninstalled (if `uninstall` is passed).

## What this repo configures, and how

### Homebrew itself, Git, Pyenv, and Poetry

**Not implemented yet**

These are configured by the bootstrap script, because they are needed for configsync to run.

### Configuration files directories for tools

A handful of tools have configuration files or directories in this repo. Symlinks are created from their expected locations pointing here, controlled by the `[symlinks]` table of `config.toml`. Those tools are as follows:

- `vscode-config`: Visual Studio Code
- `fish-config`: Fish shell
- `git-{config,ignore,template,message}`: Git

### Homebrew packages, Homebrew Casks and Mac App Store packages

**Not implemented yet**

These are stored in the `Brewfile`. This file is updated by running `brew bundle dump` to a temporary file, then merging that file into the existing file. It is applied by running `brew bundle install` to install the listed packages, then `brew bundle cleanup` to remove non-listed ones.

### Python tools

**Not implemented yet**

These are stored in the `[python-tools]` table of `config.toml`, and installed with `pipx`. `pipx` is itself installed with `pip install --user -U`.

### Visual Studio Code extensions

These are stored in the `[vscode]` table of `config.toml`.

## What this project does not install

Node packages are not installed ahead of time; I run them as needed with `npx`, which is now part of Node.

[poetry-homebrew]: https://github.com/Homebrew/homebrew-core/pull/41055