import subprocess
import re

INSTALLED_RE = re.compile(r'^(?P<package>\W+) (?P<version>\W+)(?: \((?P<path>.*)\)):\n$')

def do_rust(rust_doc, mode):
    # Install Rust
    subprocess.check_call(('rustup-init', '-y'))

    # Get installed packages list
    for line in subprocess.check_output(('cargo', 'install', '--list')).decode('utf8').split('\n'):
        print(repr(line))
        m = INSTALLED_RE.match(line)
        if m:
            print(m.groups())