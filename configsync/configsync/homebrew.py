import re
import tempfile
from pathlib import Path
import subprocess
from tomlkit import inline_table


BREW_LINE_RE = re.compile(r"^(tap|brew|cask) \"([^\"]+)\"(?:\w*,\w*([^\n]*)$)?")


def line_to_kv(line):
    match = BREW_LINE_RE.match(line)
    if match is None:
        raise ValueError(f"Don't understand line {line!r}")
    kind, name, arglist = ((x.strip() if x is not None else x) for x in match.groups())
    return kind, name, arglist or True


def kv_to_line(kind, name, args):
    if args is True:
        arg_str = ""
    elif isinstance(args, dict):
        arg_str = ", " + ", ".join(f"{k}: {v}" for k, v in args.items())
    elif isinstance(args, str):
        arg_str = f", {args}"
    else:
        raise ValueError(f"Homebrew package must be true or a table, got {args!r}")
    return f'{kind} "{name}"{arg_str}\n'


def do_homebrew(homebrew_doc, mode):
    with tempfile.TemporaryDirectory() as d:
        tempdir = Path(d)

        # If in add mode, we add/change (but don't delete) in the
        # config file based on the system state.
        if mode == "add":
            system_pkgs = {"tap": set(), "brew": set(), "cask": set()}
            outfile = tempdir / "Brewfile.out"
            subprocess.check_call(("brew", "bundle", "dump", f"--file={outfile}"))
            with outfile.open("r") as f:
                for line in f:
                    if line.startswith("mas"):
                        continue
                    kind, name, args = line_to_kv(line)
                    homebrew_doc[kind + "s"][name] = args

        # Then, add/change packages (but don't uninstall) based on the
        # config file contents.
        infile = tempdir / "Brewfile.in"
        with infile.open("w") as f:
            for tap, args in homebrew_doc["taps"].items():
                f.write(kv_to_line("tap", tap, args))
            for brew, args in homebrew_doc["brews"].items():
                f.write(kv_to_line("brew", brew, args))
            for cask, args in homebrew_doc["casks"].items():
                f.write(kv_to_line("cask", cask, args))
        subprocess.check_call(
            ("brew", "bundle", "install", "--no-upgrade", f"--file={infile}")
        )

        # If in uninstall mode, uninstall packages that are not in the
        # config file.
        if mode == "uninstall":
            subprocess.check_call(
                ("brew", "bundle", "cleanup", "--force", f"--file={infile}")
            )
