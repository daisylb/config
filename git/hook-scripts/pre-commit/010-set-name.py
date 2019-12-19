#!/usr/bin/env python3
from pathlib import Path
from os.path import commonpath
from subprocess import check_output, check_call

WORK_DIR = Path.home() / 'CMV'
WORK_EMAIL = 'leigh.brenecki@cmv.com.au'

def is_parent(alleged_parent, alleged_child):
    return commonpath((alleged_parent.resolve(),)) == commonpath((alleged_parent.resolve(), alleged_child.resolve()))

if is_parent(Path.home() / 'CMV', Path.cwd()):
    if check_output(('git', 'config', 'user.email')) != WORK_EMAIL.encode('utf8') + b'\n':
        print(f"Setting user email to {WORK_EMAIL}")
        check_call(('git', 'config', 'user.email', WORK_EMAIL))
