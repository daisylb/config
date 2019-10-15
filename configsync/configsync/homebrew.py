import re
import tempfile
from pathlib import Path
import subprocess


BREW_LINE_RE = re.compile(r'^(tap|brew|cask) "([^"]+)"$')


def do_homebrew(homebrew_doc, mode):
    with tempfile.TemporaryDirectory() as d:
        tempdir = Path(d)

        if mode == 'add':
            system_pkgs = {'tap': set(), 'brew': set(), 'cask': set()}
            outfile = tempdir / 'Brewfile.out'
            subprocess.check_call(('brew', 'bundle', 'dump', f'--file={outfile}'))
            with outfile.open('r') as f:
                for line in f:
                    if line.startswith('mas'): continue
                    match = BREW_LINE_RE.match(line)
                    if match is None:
                        raise ValueError(f"Don't understand line {line}")
                    kind, name = match.groups()
                    system_pkgs[kind].add(name)
            
            for tap in system_pkgs['tap'].difference(homebrew_doc['taps']):
                homebrew_doc['taps'].append(tap)
            for brew in system_pkgs['brew'].difference(homebrew_doc['brews']):
                homebrew_doc['brews'].append(brew)
            for cask in system_pkgs['cask'].difference(homebrew_doc['casks']):
                homebrew_doc['casks'].append(cask)
        
        infile = tempdir / 'Brewfile.in'
        with infile.open('w') as f:
            for tap in homebrew_doc['taps']:
                f.write(f'tap "{tap}"\n')
            for brew in homebrew_doc['brews']:
                f.write(f'brew "{brew}"\n')
            for cask in homebrew_doc['casks']:
                f.write(f'cask "{cask}"\n')
        subprocess.check_call(('brew', 'bundle', 'install', f'--file={infile}'))
        if mode == 'uninstall':
            subprocess.check_call(('brew', 'bundle', 'cleanup', '--force', f'--file={infile}'))
