from os.path import exists
from readchar import readchar

CHECKS = (
	("npm", "package-lock.json"),
	("yarn", "yarn.lock"),
	("pnpm", "pnpm-lock.yaml"),
)

def _make_wrapper(tool):
	def wrapper(args):
		for maybe_intended_tool, lock_file in CHECKS:
			if maybe_intended_tool != tool and exists(lock_file):
				print(f"There is a {lock_file} here, are you sure you want {tool}? [y/n] ", end='')
				choice = readchar()
				print(choice)
				if choice != 'y':
					return
		return ![command @(tool) @(args)]
	return wrapper
	
for tool, _ in CHECKS:
	aliases[tool] = _make_wrapper(tool)
