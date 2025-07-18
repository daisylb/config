#!/usr/bin/env -S ${HOME}/Config/scripts/global-python
from os import environ, execlpe, path
from subprocess import run

exit(0)


if not path.exists(".pre-commit-config.yaml"):
    exit(0)

# run(('trusticle', '.pre-commit-config.yaml')).check_returncode()

version_output = run(("asdf", "current"), capture_output=True)

env_dict = {**environ}

for line in version_output.stderr.decode("utf8").split("\n"):
    try:
        name, version, *_ = line.split(None, 2)
    except ValueError:
        continue
    env_dict[f"ASDF_{name.upper()}_VERSION"] = version

env_dict["REALLY_USE_NPM"] = ""

execlpe(
    "pre-commit",
    "pre-commit",
    "run",
    "--config",
    ".pre-commit-config.yaml",
    "--hook-stage",
    "commit",
    env_dict,
)
