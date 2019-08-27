# Local machine configuration

## What this repo configures, and how

Note that presently nothing described here is implemented yet.

- Homebrew itself, Git, Pyenv (via Homebrew), and Poetry (installed via `get-poetry.py` [at present][poetry-homebrew]) are installed by the bootstrap script, because they are needed for configsync to run.
- Homebrew packages, Homebrew Casks and Mac App Store packages are stored in the `Brewfile`. This file is updated by running `brew bundle dump` to a temporary file, then merging that file into the existing file. It is applied by running `brew bundle install` to install the listed packages, then `brew bundle cleanup` to remove non-listed ones.
- Python packages are stored in `python-packages.toml`, and installed with `pipx`. `pipx` itself is installed with `pip install --user`.
- Node packages are not installed ahead of time; I run them as needed with `npx`, which is now part of Node.
- Visual Studio Code extensions are stored in `vscode-extensions.toml`.
- Configuration directories for various tools are symlinked into this directory.

[poetry-homebrew]: https://github.com/Homebrew/homebrew-core/pull/41055