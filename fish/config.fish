set -gx PATH ~/config/scripts ~/.local/bin /opt/homebrew/bin $PATH
status --is-interactive; and direnv hook fish | source

if test -d /usr/local/opt/android-sdk
    set -gx ANDROID_HOME /usr/local/opt/android-sdk
end

set -gx PYTHONDONTWRITEBYTECODE
set -gx EDITOR "code -w"

# turn off Fish's open command, it's not necessary on OS X
functions -e open

set -g fish_transient_prompt 1
