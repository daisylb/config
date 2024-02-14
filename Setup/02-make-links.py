#!/usr/bin/env python
from pathlib import Path

PROJ = Path(__file__).parent.parent


def do_symlink(src_s, dest_s):
    src = PROJ / src_s
    dest = Path.expanduser(Path(dest_s))
    dest.parent.mkdir(parents=True, exist_ok=True)
    if dest.is_symlink():
        if dest.resolve() == src:
            print(f"Already linked {src} <- {dest}")
            return
        else:
            dest.unlink()
    elif dest.exists():
        raise Exception(f"{dest} exists and is not a symlink!")
    print(f"Linking {src} <- {dest}")
    dest.symlink_to(src)


do_symlink("vscode", "~/Library/Application Support/Code/User")
do_symlink("fish", "~/.config/fish")
do_symlink("git/config", "~/.gitconfig")
do_symlink("xonsh/rc.xsh", "~/.xonshrc")
do_symlink("asdf/global-versions", "~/.tool-versions")
do_symlink("Hammerspoon", "~/.hammerspoon")
do_symlink("Zsh/rc.sh", "~/.zshrc")
do_symlink("Zsh/env.sh", "~/.zshenv")
do_symlink("Pip", "~/.config/pip")
