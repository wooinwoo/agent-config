#!/usr/bin/env python3
"""Git clean filter for codex/config.toml.

Codex appends machine-local state to config.toml (trusted project paths, hook
trust hashes, TUI prompts). This filter drops those tables from what git stores
while leaving the working copy untouched. Wired up by install.sh via
`git config filter.codex-config.clean`.
"""
import re
import sys

DROP = re.compile(r'^\[(projects\.|hooks\.state|tui\.)')

skip = False
out = []
for line in sys.stdin:
    if line.startswith("["):
        skip = bool(DROP.match(line))
    if not skip:
        out.append(line)

text = "".join(out).rstrip("\n") + "\n"
sys.stdout.write(re.sub(r"\n{3,}", "\n\n", text))
