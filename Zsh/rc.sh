# This file is used for interactive shells only.

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Created by `userpath` on 2021-01-02 00:26:59
export PATH="$PATH:$HOME/.local/bin"

#source $HOME/.poetry/env
source "$HOME/.cargo/env"
export PATH=~/Config/scripts/:~/.local/bin:/opt/homebrew/bin:$PATH
if [ -e /Users/leigh/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/leigh/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
. "$HOME/.cargo/env"
eval "$(direnv hook zsh)"
eval "$(mise activate zsh)"

export EDITOR="code -w"

# pnpm
export PNPM_HOME="/Users/daisy.brenecki/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
