#!/usr/bin/env python
import subprocess


def get_output(*args, **kwargs) -> str:
    kwargs.setdefault("check", True)
    return subprocess.run(*args, stdout=subprocess.PIPE, **kwargs).stdout.decode("utf8")


current_commit = get_output(("git", "rev-parse", "HEAD")).strip()
previous_commit = get_output(("git", "rev-parse", "HEAD@{1}")).strip()
print(f"{current_commit=} {previous_commit=}")

exit(0)


branch_name = (
    get_output(("git", "symbolic-ref", "HEAD")).removeprefix("refs/heads/").strip()
)

if ".stack/" not in branch_name:
    print(f"Branch {branch_name} is not part of a stack")
    exit(0)

stack_name = branch_name.split(".stack/")[0]

stack_branches = [
    x.strip()
    for x in get_output(
        (
            "git",
            "log",
            "--topo-order",
            "--reverse",
            "--format=%S",
            f"--branches={stack_name}.stack/*",
            stack_name,
            f"^{previous_commit}",
        )
    )
    .strip()
    .splitlines()
]
print(f"{stack_branches=}")

for stack_branch in stack_branches:
    cmd = ("git", "rebase", "--onto", current_commit, previous_commit, stack_branch)
    print(f"{cmd=}")
    subprocess.run(cmd, check=True)

subprocess.run(("git", "switch", branch_name))
