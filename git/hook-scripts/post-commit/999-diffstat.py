#!/usr/bin/env -S ${HOME}/Config/scripts/global-python
import subprocess

if subprocess.run(('git', 'show-ref', '--verify', '--quiet', 'refs/heads/main'), stdout=subprocess.DEVNULL).returncode == 0:
    main_branch = 'main'
else:
    main_branch = 'master'
    
merge_base = subprocess.run(('git', 'merge-base', main_branch, 'HEAD'), stdout=subprocess.PIPE, encoding='utf8').stdout.strip()
print(subprocess.run(('git', 'diff', '--shortstat', merge_base), stdout=subprocess.PIPE, encoding='utf8').stdout)