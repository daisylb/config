from collections import Counter
from os.path import expanduser
import tempfile

$EDITOR = 'code --wait'

xontrib load direnv abbrevs

$PATH.add(p'~/.poetry/bin')
$PATH.add(p'~/.local/bin')
$PATH.add(p'~/.cargo/bin')
$PATH.add(p'/usr/local/bin')

$ANDROID_HOME = p'~/Library/Android/sdk'
$PATH.add($ANDROID_HOME / 'tools')
$PATH.add($ANDROID_HOME / 'platform-tools')

$LIBRARY_PATH = '/usr/local/opt/openssl/lib/'


$AUTO_CD = True
$AUTO_SUGGEST_IN_COMPLETIONS = True
$CASE_SENSITIVE_COMPLETIONS = False
$CDPATH = ('~', '~/CMV', '~/Projects')
# in iTerm, set profile -> Terminal -> Report scroll wheel events to off
$MOUSE_SUPPORT = True
$PROMPT_REFRESH_INTERVAL = 10.0
$SHELL_TYPE = 'prompt_toolkit'
$XONSH_AUTOPAIR = True
$XONSH_HISTORY_MATCH_ANYWHERE = True
$PROMPT = "{BOLD_INTENSE_CYAN}❯{NO_COLOR} "
$PTK_STYLE_OVERRIDES['bottom-toolbar'] = 'noreverse'
$UPDATE_PROMPT_ON_KEYPRESS = True
$PROMPT_TOOLKIT_COLOR_DEPTH = 'DEPTH_24_BIT'
$BASH_COMPLETIONS = ('/usr/local/etc/bash_completion',)
$XONSH_HISTORY_BACKEND = 'sqlite'
$COMPLETIONS_CONFIRM=True

def _join(parts, joiner=' '):
    return joiner.join(x for x in parts if x)

def _git_statuses():
    gsp = !(git status --porcelain --branch 2>/dev/null)
    if not gsp:
        return None

    staged = Counter()
    unstaged = Counter()
    branch = None
    for line in gsp:
        if line.startswith('##'):
            branch = line[3:-1]
            continue
    
        staged_v = line[0]
        unstaged_v = line[1]
        if staged_v not in (' ', '?'):
            staged[staged_v] += 1
        if unstaged_v != ' ':
            unstaged[unstaged_v] += 1
    
    output = []
    output.append("{{BLUE}}🗂️  {}".format(branch))
    if staged:
        output.append("{YELLOW}staged: " + ' '.join(f'{k}{c}' for k, c in staged.items()))
    if unstaged:
        output.append("{RED}unstaged: " + ' '.join(f'{k}{c}' for k, c in unstaged.items()))
    return _join(output)


def _bottom_toolbar():
    parts = []
    parts.append("{PURPLE}{cwd}")

    if _py_envs:
        parts.append("{{GREEN}}🐍  {}".format(', '.join(_py_envs)))
    
    parts.append(_git_statuses())

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
$ASDF_DIR = p'/usr/local/opt/asdf'
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

abbrevs['pr'] = 'poetry run'
abbrevs['pa'] = 'poetry add'
abbrevs['appsup'] = '"' + str(p'~/Library/Application Support')

$COLOR_INPUT = True
$COLOR_RESULTS = True

$PATH.add(p'~/config/scripts', front=True, replace=True)