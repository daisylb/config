from tomlkit import parse, dumps
from os import symlink, environ
from os.path import samefile
from pathlib import Path
from shutil import rmtree
import subprocess
from sys import argv

from .homebrew import do_homebrew
from .rust import do_rust
from .python import do_python

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
    #do_homebrew(doc['homebrew'], mode)
    do_python(doc['python'], mode)
    #do_rust(doc['rust'], mode)
    #do_vscode_extensions(doc['vscode'], mode)

    with open('../config.toml', 'w') as f:
        f.write(dumps(doc))

