from tomlkit import parse, dumps
from os import symlink
from os.path import samefile
from pathlib import Path
from shutil import rmtree
import subprocess
from sys import argv
import tempfile
import re

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


BREW_LINE_RE = re.compile(r'^(tap|brew|cask) "([^"]+)"$')

def do_homebrew(homebrew_doc, mode):
    with tempfile.TemporaryDirectory() as d:
        tempdir = Path(d)

        if mode == 'add':
            system_pkgs = {'tap': set(), 'brew': set(), 'cask': set()}
            outfile = tempdir / 'Brewfile.out'
            subprocess.check_call(('brew', 'bundle', 'dump', f'--file={outfile}'))
            with outfile.open('r') as f:
                for line in f:
                    if line.startswith('mas'): continue
                    match = BREW_LINE_RE.match(line)
                    if match is None:
                        raise Error(f"Don't understand line {line}")
                    kind, name = match.groups()
                    system_pkgs[kind].add(name)
            
            for tap in system_pkgs['tap'].difference(homebrew_doc['taps']):
                homebrew_doc['taps'].append(tap)
            for brew in system_pkgs['brew'].difference(homebrew_doc['brews']):
                homebrew_doc['brews'].append(brew)
            for cask in system_pkgs['cask'].difference(homebrew_doc['casks']):
                homebrew_doc['casks'].append(cask)
        
        infile = tempdir / 'Brewfile.in'
        with infile.open('w') as f:
            for tap in homebrew_doc['taps']:
                f.write(f'tap "{tap}"\n')
            for brew in homebrew_doc['brews']:
                f.write(f'brew "{brew}"\n')
            for cask in homebrew_doc['casks']:
                f.write(f'cask "{cask}"\n')
        subprocess.check_call(('brew', 'bundle', 'install', f'--file={infile}'))
        if mode == 'uninstall':
            subprocess.check_call(('brew', 'bundle', 'cleanup', '--force', f'--file={infile}'))



def do_vscode_extensions(vscode_doc, mode):
    installed_exts = command_set('code', '--list-extensions')
    for ext in vscode_doc['extensions']:
        if ext in installed_exts:
            print(f'Already installed {ext}')
        else:
            print(f'Installing {ext}')
            subprocess.check_call('code', '--install-extension', ext)
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
    do_vscode_extensions(doc['vscode'], mode)

    with open('../config.toml', 'w') as f:
        f.write(dumps(doc))

