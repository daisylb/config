from tomlkit import parse
from os import symlink
from os.path import samefile
from pathlib import Path
from shutil import rmtree

PROJ = Path.cwd().parent
HOME = Path.home()

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
            raise Error(f'{dest} exists and is not a symlink!')
        print(f'Linking {src} <- {dest}')
        dest.symlink_to(src)

def run():
    with open('../config.toml', 'r') as f:
        doc = parse(f.read())
    do_symlinks(doc['symlinks'])

