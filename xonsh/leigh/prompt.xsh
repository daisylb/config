import pygit2
import rich.console
import sys
from io import StringIO

def get_status():
	console_strio = StringIO()
	console = rich.console.Console(file=console_strio, force_terminal=True)
	repo = pygit2.Repository(pygit2.discover_repository('.'))
	statuses = {
		'I+': 0,
		'IM': 0,
		'I-': 0,
		'W+': 0,
		'WM': 0,
		'W-': 0,
		'C': 0,
	}
	for _, status in repo.status().items():
		if status & pygit2.GIT_STATUS_INDEX_NEW:
			statuses['I+'] += 1
		if status & pygit2.GIT_STATUS_INDEX_MODIFIED:
			statuses['IM'] += 1
		if status & pygit2.GIT_STATUS_INDEX_DELETED:
			statuses['I-'] += 1
		if status & pygit2.GIT_STATUS_WT_NEW:
			statuses['W+'] += 1
		if status & pygit2.GIT_STATUS_WT_MODIFIED:
			statuses['WM'] += 1
		if status & pygit2.GIT_STATUS_WT_DELETED:
			statuses['W-'] += 1
		if status & pygit2.GIT_STATUS_CONFLICTED:
			statuses['C'] += 1
	
	for status, count in statuses.items():
		if count == 0: continue
		color = {
			'W': 'dark_orange',
			'I': 'cyan3',
			'C': 'blue_violet',
		}[status[0]]
		code = f'[bold {color}]{status}{count}[/]'
		console.print(code, end=' ')
	v = console_strio.getvalue()
	sys.stdout.write(v)
