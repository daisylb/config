from tomlkit import parse, dumps
from os import symlink, environ
from os.path import samefile
from pathlib import Path
from shutil import rmtree
import subprocess
from sys import argv

from .homebrew import do_homebrew
from .rust import do_rust

PROJ = Path.cwd().parent
HOME = Path.home()

def command_set(*args):
    output = subprocess.check_output(args).decode('utf8')
    return {x.strip() for x in output.split('\n') if x.strip()}


def do_symlinks(symlink_doc):
    for src_s, dest_s in symlink_doc.items():
        src = PROJ / src_s
        dest = Path.expanduser(Path(dest_s))
        dest.parent.mkdir(parents=True, exist_ok=True)
        if dest.is_symlink():
            if dest.resolve() == src:
                print(f'Already linked {src} <- {dest}')
                continue
            else:
                dest.unlink()
        elif dest.exists():
            raise Exception(f'{dest} exists and is not a symlink!')
        print(f'Linking {src} <- {dest}')
        dest.symlink_to(src)


def do_python(python_doc, mode):
    pipx_bin = HOME / '.local' / 'bin' / 'pipx'

    if pipx_bin.exists():
        print('Already installed pipx')
    else:
        print('Installing pipx')
        subprocess.check_call(('pip', 'install', '--user', 'pipx'))

    pipx_dir = HOME / '.local' / 'pipx' / 'venvs'
    if pipx_dir.exists():
        installed = {x.name for x in pipx_dir.iterdir()}
    else:
        installed = set()
    tool_install_env = {
        **environ,
        'LIBRARY_PATH': ':'.join(python_doc['library-path']),
        'PATH': ':'.join(python_doc['extra-path']) + ':' + environ['PATH'],
    }
    for tool in python_doc['tools']:
        if tool in installed:
            print(f'Already installed {tool}')
        else:
            print(f'Installing {tool}')
            subprocess.check_call(('pipx', 'install', tool), env=tool_install_env)
    for tool in installed.difference(python_doc['tools']):
        if mode == 'add':
            python_doc['tools'].append(tool)
        else:
            print(f'Uninstalling {tool}')
            subprocess.check_call(('pipx', 'uninstall', tool))
    print('Upgrading installed Python tools')
    subprocess.check_call(('pipx', 'upgrade-all'))


def do_vscode_extensions(vscode_doc, mode):
    installed_exts = command_set('code', '--list-extensions')
    for ext in vscode_doc['extensions']:
        if ext in installed_exts:
            print(f'Already installed {ext}')
        else:
            print(f'Installing {ext}')
            subprocess.check_call(('code', '--install-extension', ext))
    for ext in installed_exts.difference(vscode_doc['extensions']):
        if mode == 'add':
            print(f'Adding {ext} to config')
            vscode_doc['extensions'].append(ext)
        else:
            print(f'Uninstalling {ext}')
            subprocess.check_call(('code', '--uninstall-extension', ext))

def run():
    if len(argv) < 2 or argv[1] not in ('add', 'uninstall'):
        raise Exception('Usage: configsync add|uninstall')
    mode = argv[1]

    with open('../config.toml', 'r') as f:
        doc = parse(f.read())

    do_symlinks(doc['symlinks'])
    do_homebrew(doc['homebrew'], mode)
    do_python(doc['python'], mode)
    do_rust(doc['rust'], mode)
    do_vscode_extensions(doc['vscode'], mode)

    with open('../config.toml', 'w') as f:
        f.write(dumps(doc))

