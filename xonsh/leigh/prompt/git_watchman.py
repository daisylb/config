import json
import socket
from io import BufferedReader
from queue import Empty, Queue
from subprocess import PIPE, run
from time import sleep
from typing import List


class LineReader:
    sock: socket.socket
    lines: Queue
    partial_line = b""

    def __init__(self, sock: socket.socket):
        self.sock = sock
        self.lines = Queue()

    def get_line(self, block=False):
        # If there's already lines enqueued, we just return them
        try:
            return self.lines.get(block=False)
        except Empty:
            pass
        # If the queue is empty, we need to put stuff in it
        self.sock.setblocking(block)
        while self.lines.empty():
            try:
                data = self.sock.recv(1024).split(b"\n")
            except BlockingIOError:
                break
            if len(data) > 1:
                [start, *middle, end] = data
                self.lines.put(self.partial_line + start)
                for line in middle:
                    self.lines.put(line)
                self.partial_line = end
            else:
                self.partial_line += data[0]
        try:
            return self.lines.get(block=False)
        except Empty:
            return None


class WatchmanClient:
    sock: socket.socket
    reader: LineReader
    unilateral_msgs: Queue
    watch_counter = 0

    def __init__(self):
        watchman_sock_data = json.loads(
            run(("watchman", "get-sockname"), stdout=PIPE).stdout
        )
        self.sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        self.sock.connect(watchman_sock_data["unix_domain"])
        self.reader = LineReader(self.sock)
        self.unilateral_msgs = Queue()

    def send(self, cmd):
        self.sock.send(json.dumps(cmd).encode("utf8") + b"\n")
        while True:
            line = self.reader.get_line(block=True)
            data = json.loads(line.decode("utf8"))
            if data.get("unilateral", False):
                self.unilateral_msgs.put(data)
            else:
                return data

    def watch_project(self, path):
        this_watch_id = str(self.watch_counter)
        self.watch_counter += 1
        watch_project_resp = self.send(["watch-project", dir])
        watch_resp = self.send(
            [
                "subscribe",
                watch_project_resp["watch"],
                this_watch_id,
                {
                    "expression": ["type", "f"],
                    "fields": [],
                    "empty_on_fresh_instance": True,
                    "relative_root": watch_project_resp.get("relative-path", ""),
                },
            ]
        )


client = WatchmanClient()
client.watch_project("/Users/leigh/Octopus Energy/kraken-core")