#!/usr/bin/env -S ${HOME}/Config/scripts/global-python

from sys import argv, exit, stdout
from os import isatty
from os.path import exists
from subprocess import check_output, call

_, prev_head, curr_head, is_branch = argv

if is_branch != "1":
    exit(0)

if prev_head != "0000000000000000000000000000000000000000":
    diff_output: str = (
        check_output(("git", "diff", "--name-only", prev_head, curr_head))
        .decode("utf8")
        .strip()
    )
    changed_files = set(diff_output.splitlines())


def changed(file_name) -> bool:
    if prev_head != "0000000000000000000000000000000000000000":
        return file_name in changed_files
    return exists(file_name)


commands = []

if changed(".tool-versions") or changed(".python-version"):
    commands.append(("asdf", "install"))

if changed("poetry.lock"):
    commands.append(("poetry", "install"))

if changed("Pipfile.lock"):
    commands.append(("pipenv", "install"))

if changed("yarn.lock"):
    commands.append(("yarn", "install"))

if changed("package-lock.json"):
    commands.append(("npm", "install"))

if changed("requirements.dev.txt"):
    commands.append(("pip", "install", "-r", "requirements.dev.txt"))

if not commands:
    exit(0)

print("Changes were made to dependencies, and the following need to be run:")
for command in commands:
    print(" ".join(command))

if not isatty(stdout.fileno()):
    exit(0)

tty = open("/dev/tty")
# if not isatty(tty.fileno()): exit(0)

print("Run them now? [y/n]", end=" ")
stdout.flush()

answer: str = tty.readline().strip()

if answer != "y":
    exit(0)

for command in commands:
    call(command)
