import pygit2
#import rich.console
import sys
from io import StringIO
import threading
from time import sleep
import pywatchman
from pathlib import Path
import typing as t

# Setup watchman client

"""
watch_client = pywatchman.client(timeout=10)
cli_lock = threading.Lock()

def _watch_client_read_thread():
	while threading.main_thread().is_alive():
		try:
			with cli_lock:
				val = watch_client.receive()
			if val:
				print(val)
		except pywatchman.SocketTimeout:
			pass
 
class Watch:
	_name = None
	_root = None
	_reldir = None   
	
	def __init__(self, path: t.Union[Path, str]):
		with cli_lock:
			projinfo = watch_client.query('watch-project', str(path))
		self._name = 'xshw'
		self._root = projinfo['watch']
		self._reldir = projinfo['relative_path']
		with cli_lock:
			subscrinfo = watch_client.query('subscribe', self._root, self._name, {
				"fields": ['name'],
				"relative_root": self._reldir,
				"dedup_results": True,
			})
	
	def get(self):
		return watch_client.getSubscription(self._name, self._reldir)

threading.Thread(target=_watch_client_read_thread).start()
"""

# Setup repo client
_repo_root = None
_repo_client = None
_current_status = None

SUBSCRIPTION_NAME = 'PROMPT_GIT_WD'

@events.on_chdir
def _setup_repo_client(olddir, newdir):
	global _repo_root, _repo_client, _current_status
	if _repo_root != (new_root := pygit2.discover_repository(newdir)):
		if new_root is None:
			_repo_client = None
			_current_status = ''
		else:
			_repo_client = pygit2.Repository(new_root)
			_current_status = None
			if _repo_root:
				pass
		_repo_root = new_root
		
@events.on_pre_prompt
def _reset_status():
	global _current_status
	_current_status = None

def get_status():
	global _current_status
	if _current_status is None:
		_current_status = _get_status()
	return _current_status

def _get_status():
	repo = _repo_client
	if repo is None:
		return ''
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
	
	strings = []
	for status, count in statuses.items():
		if count == 0: continue
		color = {
			'W': 'dark_orange',
			'I': 'cyan3',
			'C': 'blue_violet',
		}[status[0]]
		strings.append(f'{status}{count}')
	dirty_status = ''.join(strings)
	
	branch = repo.head.resolve()
	branch_name = branch.shorthand
	commit = str(repo.head.resolve().target)[:7]
	
	return f"{commit} {branch_name} {dirty_status}"
