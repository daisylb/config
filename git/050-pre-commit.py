#!/usr/bin/env python3
import subprocess
import sys

HOOK_TYPE = 'pre-commit'
CONFIG = '.pre-commit-config.yaml'
Z40 = '0' * 40

class EarlyExit(RuntimeError):
    pass

def _rev_exists(rev):
    return not subprocess.call(('git', 'rev-list', '--quiet', rev))

def _pre_push(stdin):
    remote = sys.argv[1]

    opts = ()
    for line in stdin.decode('UTF-8').splitlines():
        _, local_sha, _, remote_sha = line.split()
        if local_sha == Z40:
            continue
        elif remote_sha != Z40 and _rev_exists(remote_sha):
            opts = ('--origin', local_sha, '--source', remote_sha)
        else:
            # ancestors not found in remote
            ancestors = subprocess.check_output((
                'git', 'rev-list', local_sha, '--topo-order', '--reverse',
                '--not', '--remotes={}'.format(remote),
            )).decode().strip()
            if not ancestors:
                continue
            else:
                first_ancestor = ancestors.splitlines()[0]
                cmd = ('git', 'rev-list', '--max-parents=0', local_sha)
                roots = set(subprocess.check_output(cmd).decode().splitlines())
                if first_ancestor in roots:
                    # pushing the whole tree including root commit
                    opts = ('--all-files',)
                else:
                    cmd = ('git', 'rev-parse', '{}^'.format(first_ancestor))
                    source = subprocess.check_output(cmd).decode().strip()
                    opts = ('--origin', local_sha, '--source', source)

    if opts:
        return opts
    else:
        # An attempt to push an empty changeset
        raise EarlyExit()

def _opts(stdin):
    fns = {
        'prepare-commit-msg': lambda _: ('--commit-msg-filename', sys.argv[1]),
        'commit-msg': lambda _: ('--commit-msg-filename', sys.argv[1]),
        'pre-commit': lambda _: (),
        'pre-push': _pre_push,
    }
    stage = HOOK_TYPE.replace('pre-', '')
    return ('--config', CONFIG, '--hook-stage', stage) + fns[HOOK_TYPE](stdin)

subprocess.check_call(('pre-commit', 'run') + _opts(sys.stdin))