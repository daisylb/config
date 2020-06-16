set -gx PATH /usr/local/bin $PATH
status --is-interactive; and source (pyenv init -|psub)
set -gx PATH ~/config/fish-config/scripts ~/.local/bin ~/.cargo/bin ~/.n/bin ~/.go-global/bin  ~/.gem/ruby/*/bin $PATH
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

set -x N_PREFIX $HOME/.n

if test $TERM_PROGRAM = "iTerm.app" -a -e {$HOME}/.iterm2_shell_integration.fish
    source {$HOME}/.iterm2_shell_integration.fish
    function __it2_pyenv_integration --on-variable PWD --on-variable PYENV_VERSION
        set pyver (command pyenv version-name | tr ":" " ")
        if test -n $pyver
            iterm2_set_user_var pyenvVersion "pyenv: $pyver"
        else
            iterm2_set_user_var pyenvVersion
        end
    end
    __it2_pyenv_integration
    function pyenv
        command pyenv $argv
        __it2_pyenv_integration
    end
    function __it2_java_integration --on-variable JAVA_HOME
        if set -q JAVA_HOME
            iterm2_set_user_var javaVersion "java: "(basename (dirname (dirname $JAVA_HOME)))
        else
            iterm2_set_user_var javaVersion
        end
    end
    __it2_java_integration
    function __it2_android_serial --on-variable ANDROID_SERIAL
        if set -q ANDROID_SERIAL
            iterm2_set_user_var androidSerial "android: $ANDROID_SERIAL"
        else
            iterm2_set_user_var androidSerial
        end
    end
    __it2_android_serial
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
