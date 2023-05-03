from collections import Counter
from os.path import expanduser
import tempfile

#$EDITOR = 'code --wait --new-window'
#$EDITOR = 'subl --wait --new-window'
$EDITOR = 'nova --wait'
$PAGER = 'sp'

xontrib load direnv # abbrevs

$HOMEBREW_PREFIX = p'/opt/homebrew'

$PATH.add(p'~/.poetry/bin')
$PATH.add(p'~/.local/bin')
$PATH.add(p'~/.cargo/bin')
$PATH.insert(0, $HOMEBREW_PREFIX / 'bin')
$PNPM_HOME=p'~/Library/pnpm'
$PATH.add($PNPM_HOME)
$PATH.add(p'~/.config/yarn/global/node_modules/.bin/')
$PATH.add(p'~/Library/Application Support/edgedb/bin')

$ANDROID_HOME = p'~/Library/Android/sdk'
$PATH.add($ANDROID_HOME / 'tools')
$PATH.add($ANDROID_HOME / 'platform-tools')

$LIBRARY_PATH = [$HOMEBREW_PREFIX / 'opt/openssl/lib', $HOMEBREW_PREFIX / 'opt/libmemcached/lib', $HOMEBREW_PREFIX / 'lib']
$LD_LIBRARY_PATH = $LIBRARY_PATH
$INCLUDE_PATH = [$HOMEBREW_PREFIX / 'opt/openssl/include', $HOMEBREW_PREFIX / 'opt/libmemcached/include', $HOMEBREW_PREFIX / 'include']


$AUTO_CD = True
$AUTO_SUGGEST_IN_COMPLETIONS = True
$CASE_SENSITIVE_COMPLETIONS = False
$CDPATH = ('~', '~/Octopus', '~/Developer')
# in iTerm, set profile -> Terminal -> Report scroll wheel events to off
$MOUSE_SUPPORT = True
$PROMPT_REFRESH_INTERVAL = 1.0
$SHELL_TYPE = 'prompt_toolkit'
$XONSH_AUTOPAIR = True
$XONSH_HISTORY_MATCH_ANYWHERE = True
$PROMPT = "{BOLD_INTENSE_CYAN}❯{RESET} "
$XONSH_STYLE_OVERRIDES['bottom-toolbar'] = 'noreverse'
$UPDATE_PROMPT_ON_KEYPRESS = True
$PROMPT_TOOLKIT_COLOR_DEPTH = 'DEPTH_24_BIT'
$BASH_COMPLETIONS = ( $HOMEBREW_PREFIX / 'etc/bash_completion',)
$XONSH_HISTORY_BACKEND = 'sqlite'
$COMPLETIONS_CONFIRM=True

# import leigh.npm

def _join(parts, joiner=' '):
    return joiner.join(x for x in parts if x)

def _git_statuses():
    from leigh.prompt.git import get_git_status
    return get_git_status($PWD)
    return ""
    
    
def _tb_len(stri):
    from wcwidth import wcswidth
    import re
    return wcswidth(re.sub(r'\{[^\}]\}', '', stri))
    

def _tb_join(*parts, width=None, joiner='{FAINT_BLACK} • '):
    from wcwidth import wcswidth
    from uniseg.graphemecluster import grapheme_clusters
    parts = tuple(x for x in parts if x)
    if width is None:
        import os
        width = os.get_terminal_size().columns
        
    joiner_len = _tb_len(joiner) * (len(parts) - 1)
    part_widths = (_tb_len(x) for x in parts)
    sum_width = sum(part_widths) + joiner_len
    
    if sum_width > width:
        max_width = width // len(parts)
        parts = tuple(x[:max_width] for x in parts)
    
    return joiner.join(parts)
    


def _bottom_toolbar():
    parts = []
    parts.append("{PURPLE}{cwd}")

    if _py_envs:
        parts.append("{{GREEN}}🐍  {}".format(', '.join(_py_envs)))
    
    # parts.append(_git_statuses())

    if 'ANDROID_SERIAL' in ${...}: 
        parts.append("{{GREEN}}🤖  {}".format($ANDROID_SERIAL))

    return _join(parts, joiner='{FAINT_BLACK} • ')

$BOTTOM_TOOLBAR = _bottom_toolbar

_py_envs = None

@events.on_chdir
def get_py_env(olddir, newdir):
    return
    global _py_envs
    _py_envs = $(pyenv version-name).strip().split(':')

def _cdtmp():
    dir = $(mktemp -d).strip()
    cd @(dir)

def _cdtmp_py():
    _cdtmp()
    poetry init -n >/dev/null
    poetry config --local virtualenvs.path @($(mktemp -d).strip())

aliases['cdtmp'] = _cdtmp
aliases['cdtmp-py'] = _cdtmp_py

def _android_device(args):
    (device,) = args
    hostport = f'{device}:11881'
    with open(expanduser(f'~/.config/android-device/{device}'), 'r') as f:
        serial = f.read().strip()
    !(adb -s @(serial) tcpip 11881)
    !(adb connect @(hostport))
    $ANDROID_SERIAL = hostport

aliases['android-device'] = _android_device

def _br(args):
    with tempfile.NamedTemporaryFile('r') as f:
        broot_res = ![broot --outcmd @(f.name) @(args)]
        if broot_res:
            the_cmd = f.read()
            execx(the_cmd)
        return broot_res.rtn
    
aliases['br'] = _br

aliases['clear-scrollback'] = "printf '\033[2J\033[3J\033[1;1H'"

# Nix
#nix_link = f'{$HOME}/.nix-profile'
#nix_user_profile = f'/nix/var/nix/profiles/per-user/{$USER}'
#$NIX_PATH = f'{$HOME}/.nix-defexpr/channels'
#$NIX_PROFILES="/nix/var/nix/profiles/default $HOME/.nix-profile"
#$NIX_SSL_CERT_FILE = f"{nix_link}/etc/ssl/certs/ca-bundle.crt"
#$PATH.append(f'{nix_link}/bin')

import re
_ASDF_EXPORT_RE = re.compile(r'export ([A-Z\_]+)="([^"]+)"|unset ([A-Z\_]+)')


# asdf
$ASDF_DIR =  $HOMEBREW_PREFIX / 'opt/asdf/libexec'
$ASDF_DATA_DIR = p'~/Library/asdf'
$PATH.add($ASDF_DATA_DIR / 'shims', front=True)
def _wrap_asdf(args):
    if args[0] == 'install':
        return ![env -i PATH=$PATH ASDF_DIR=$ASDF_DIR ASDF_DATA_DIR=$ASDF_DATA_DIR asdf @(args)]
    if args and args[0] == 'shell':
        for line in !(command asdf export-shell-version sh @(args[1:])):
            match_obj = _ASDF_EXPORT_RE.match(line.strip())
            if match_obj is None:
                print(line, end='')
                continue
            set_var_name, set_var_value, unset_var = match_obj.groups()
            if set_var_name is not None and set_var_value is not None:
                ${set_var_name} = set_var_value
            if unset_var is not None:
                del ${unset_var}
    else:
        return ![command asdf @(args)]

aliases['asdf'] = _wrap_asdf

if 'abbrevs' in globals():
    abbrevs['pr'] = 'poetry run'
    abbrevs['pa'] = 'poetry add'
    abbrevs['appsup'] = '"' + str(p'~/Library/Application Support')

$COLOR_INPUT = True
$COLOR_RESULTS = True

$PATH.add(p'~/config/scripts', front=True, replace=True)

aliases['invl'] = "inv -c tasks_local"

def _brew_setprefix(args):
    if 'LDFLAGS' not in ${...}:
        $LDFLAGS = ''
    if 'CPPFLAGS' not in ${...}:
        $CPPFLAGS = ''
    for arg in args:
        prefix = $(brew --prefix @(arg)).strip()
        $CPPFLAGS += f" -I{prefix}/include"
        $LDFLAGS += f" -L{prefix}/lib"

aliases['brew-set-prefix'] = _brew_setprefix