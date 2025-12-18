# This file is used for interactive shells only.

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Created by `userpath` on 2021-01-02 00:26:59
export PATH="$PATH:/Users/leigh/.local/bin"

export PNPM_HOME="/Users/leigh/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

eval "$(mise activate zsh)" 

#source $HOME/.poetry/env
source "$HOME/.cargo/env"
export PATH=~/Config/scripts/:~/.local/bin:/opt/homebrew/bin:$PATH
if [ -e /Users/leigh/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/leigh/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
. "$HOME/.cargo/env"
eval "$(direnv hook zsh)"
