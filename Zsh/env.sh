source $HOME/.poetry/env
export ASDF_DIR=/usr/local/opt/asdf/libexec
export ASDF_DATA_DIR=$HOME/Library/asdf
source "$HOME/.cargo/env"
if [ -e /Users/leigh/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/leigh/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer