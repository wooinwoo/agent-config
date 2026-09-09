#!/usr/bin/env python3
"""Mirror [mcp_servers.*] from codex/config.toml into Claude Code (user scope).

codex/config.toml is the single source of truth for MCP servers.
Codex-only keys (startup_timeout_sec, tool_timeout_sec, tools.*,
default_tools_approval_mode) are dropped; Claude has no equivalent.
"""
import json
import subprocess
import sys
import tomllib
from pathlib import Path

CONFIG = Path(__file__).resolve().parents[1] / "codex" / "config.toml"


def claude(*args):
    return subprocess.run(["claude", "mcp", *args], capture_output=True, text=True)


def to_claude_spec(server):
    if "url" in server:
        return {"type": "http", "url": server["url"]}
    return {
        "type": "stdio",
        "command": server["command"],
        "args": server.get("args", []),
        "env": server.get("env", {}),
    }


def main():
    servers = tomllib.loads(CONFIG.read_text()).get("mcp_servers", {})
    failed = 0
    for name, server in servers.items():
        claude("remove", "-s", "user", name)  # ignore "not found"
        if server.get("enabled", True) is False:
            print(f"off  {name}")
            continue
        result = claude("add-json", "-s", "user", name, json.dumps(to_claude_spec(server)))
        ok = result.returncode == 0
        failed += not ok
        print(f"{'ok  ' if ok else 'FAIL'} {name}")
        if not ok:
            print((result.stderr or result.stdout).strip(), file=sys.stderr)
    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()
