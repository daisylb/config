#!/usr/bin/env -S ${HOME}/Config/scripts/global-python
from os.path import commonpath
from pathlib import Path
from subprocess import check_call, check_output

WORK_DIR = Path.home() / "Octopus"
WORK_EMAIL = "daisy.brenecki@octopus.energy"


def is_parent(alleged_parent, alleged_child):
    return commonpath((alleged_parent.resolve(),)) == commonpath(
        (alleged_parent.resolve(), alleged_child.resolve())
    )


if is_parent(WORK_DIR, Path.cwd()):
    if (
        check_output(("git", "config", "user.email"))
        != WORK_EMAIL.encode("utf8") + b"\n"
    ):
        print(f"Setting user email to {WORK_EMAIL}")
        check_call(("git", "config", "user.email", WORK_EMAIL))
