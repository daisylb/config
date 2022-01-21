import trio
import json


class LineReader:
    def __init__(self, stream, max_line_length=200_000):
        self.stream = stream
        self._line_generator = self.generate_lines(max_line_length)

    @staticmethod
    def generate_lines(max_line_length):
        buf = bytearray()
        find_start = 0
        while True:
            newline_idx = buf.find(b"\n", find_start)
            if newline_idx < 0:
                # no b'\n' found in buf
                if len(buf) > max_line_length:
                    raise ValueError("line too long")
                # next time, start the search where this one left off
                find_start = len(buf)
                more_data = yield
            else:
                # b'\n' found in buf so return the line and move up buf
                line = buf[: newline_idx + 1]
                # Update the buffer in place, to take advantage of bytearray's
                # optimized delete-from-beginning feature.
                del buf[: newline_idx + 1]
                # next time, start the search from the beginning
                find_start = 0
                more_data = yield line

            if more_data is not None:
                buf += bytes(more_data)

    async def readline(self):
        line = next(self._line_generator)
        while line is None:
            more_data = await self.stream.receive_some(1024)
            if not more_data:
                return b""  # this is the EOF indication expected by my caller
            line = self._line_generator.send(more_data)
        return line


class WatchmanClient:
    has_started = None
    response_channel = None
    subscription_queues = None

    def __init__(self, nursery):
        self.has_started = trio.Event()
        self.subscription_queues = {}
        nursery.start_soon(self._connect)

    async def _connect(self):
        proc = await trio.run_process(("watchman", "get-sockname"), capture_stdout=True)
        sock_data = json.loads(proc.stdout)
        print(sock_data)

        send_channel, self.response_channel = trio.open_memory_channel(20)
        self.conn = await trio.open_unix_socket(sock_data["sockname"])
        self.has_started.set()
        reader = LineReader(self.conn)
        while True:
            pdu = await reader.readline()
            data = json.loads(pdu)
            if data.get("unilateral", False):
                self.subscription_queues[data["subscription"]].send(data)
            else:
                await send_channel.send(data)

    async def _send(self, data):
        await self.has_started.wait()
        send_awaitable = self.conn.send_all(json.dumps(data).encode("utf8") + b"\n")
        response_awaitable = self.response_channel.receive()
        await send_awaitable
        return await response_awaitable

    async def watch_dir(self, dir):
        project = await self._send(["watch-project", dir])
        watch_root = project["watch"]
        relative_path = project.get("relative_path", "")
        subscription = await self._send(
            [
                "subscribe",
                watch_root,
                "git-subscr",
                {
                    "expression": ["type", "f"],
                    "fields": [],
                    "empty_on_fresh_instance": True,
                    "relative_root": relative_path,
                },
            ]
        )
        send_side, recv_side = trio.open_memory_channel(20)
        return recv_side


async def main():
    async with trio.open_nursery() as nursery:
        watchman_client = WatchmanClient(nursery)
        await watch_dir("/Users/leigh/Octopus Energy/kraken-core", watchman_client)


async def watch_dir(path, client: WatchmanClient):
    await client.watch_dir(path)


trio.run(main)