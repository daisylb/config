from tomlkit import parse, dumps
from os import symlink, environ
from os.path import samefile
from pathlib import Path
from shutil import rmtree
import subprocess
from sys import argv

from .homebrew import do_homebrew
from .rust import do_rust

PROJ = Path.cwd().parent
HOME = Path.home()
ASDF_DATA_DIR = HOME / 'Library' / 'asdf'

def do_python(python_doc, mode):
	pip_bin = ASDF_DATA_DIR / 'shims' / 'pip'
	pipx_bin = HOME / '.local' / 'bin' / 'pipx'

	if pipx_bin.exists():
		print('Already installed pipx')
	else:
		print('Installing pipx')
		subprocess.check_call((str(pip_bin), 'install', '--user', 'pipx'))

	pipx_dir = HOME / '.local' / 'pipx' / 'venvs'
	if pipx_dir.exists():
		installed = {x.name for x in pipx_dir.iterdir()}
	else:
		installed = set()
	tool_install_env = {
		**environ,
		'LIBRARY_PATH': ':'.join(python_doc['library-path']),
		'PATH': ':'.join(python_doc['extra-path']) + ':' + environ['PATH'],
	}
	for tool in python_doc['tools']:
		if tool in installed:
			print(f'Already installed {tool}')
		else:
			print(f'Installing {tool}')
			subprocess.check_call(('pipx', 'install', tool), env=tool_install_env)
	for tool in installed.difference(python_doc['tools']):
		if mode == 'add':
			python_doc['tools'].append(tool)
		else:
			print(f'Uninstalling {tool}')
			subprocess.check_call(('pipx', 'uninstall', tool))
	print('Upgrading installed Python tools')
	subprocess.check_call(('pipx', 'upgrade-all'))