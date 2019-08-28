set -gx PATH /usr/local/bin $PATH
status --is-interactive; and source (pyenv init -|psub)
set -gx PATH ~/config/fish/scripts ~/.local/bin ~/.cargo/bin ~/.npm-global/bin ~/.go-global/bin  ~/.gem/ruby/*/bin $PATH
source ~/.poetry/env

if test -d /usr/local/opt/android-sdk
    set -gx ANDROID_HOME /usr/local/opt/android-sdk
end

if which rbenv
    rbenv rehash >/dev/null ^&1
end

set -gx PYTHONDONTWRITEBYTECODE

set -gx EDITOR "vim"


set -x GLOBAL_GOPATH $HOME/.go-global/
set -x GOPATH $GLOBAL_GOPATH

if test $TERM_PROGRAM = "iTerm.app" -a -e {$HOME}/.iterm2_shell_integration.fish
    source {$HOME}/.iterm2_shell_integration.fish
    function __it2_pyenv_integration --on-variable PWD --on-variable PYENV_VERSION
        iterm2_set_user_var pyenvVersion (command pyenv version-name | tr ":" " ")
    end
    __it2_pyenv_integration
    function pyenv
        command pyenv $argv
        __it2_pyenv_integration
    end
end

if test -d $HOME/Library/Android/sdk
    set -x ANDROID_HOME $HOME/Library/Android/sdk
    set -x PATH $PATH $ANDROID_HOME/tools $ANDROID_HOME/platform-tools
end

functions -e open # turn off Fish's open command, it's not necessary on OS X
function __check_git_email --on-variable PWD
	if test -d .git -a (count (git config user.email)) -eq 0
        echo (set_color red)"You need to set a Git user.email!"
        echo "Run the following command:"
        echo
        echo "    git config user.email <email>"
        echo (set_color normal)
    end
end
