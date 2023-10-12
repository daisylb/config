source $HOME/.poetry/env
export ASDF_DIR=/opt/homebrew/opt/asdf/libexec
export ASDF_DATA_DIR=$HOME/Library/asdf
source "$HOME/.cargo/env"
export PATH=~/Config/scripts/:~/Library/asdf/shims:~/.local/bin:/opt/homebrew/bin:$PATH
if [ -e /Users/leigh/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/leigh/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
. "$HOME/.cargo/env"
eval "$(direnv hook zsh)"