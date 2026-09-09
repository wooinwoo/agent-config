#!/usr/bin/env bash
# Links this repo into ~/.claude and ~/.codex, installs shared plugins, mirrors MCP servers.
# Safe to re-run. Run after cloning on a new machine.
set -euo pipefail
R="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() { mkdir -p "$(dirname "$2")"; ln -sfn "$1" "$2"; }

# Git: keep machine-local Codex state (trusted projects, hook hashes) out of commits
git -C "$R" config filter.codex-config.clean "python3 $R/scripts/clean-codex-config.py"
git -C "$R" config filter.codex-config.smudge cat

# Instructions and personal notes (personal/ is git-ignored and may be empty on a fresh clone)
mkdir -p "$R/personal/skills"
link "$R/AGENTS.md" "$HOME/.codex/AGENTS.md"
link "$R/AGENTS.md" "$HOME/.claude/CLAUDE.md"
link "$R/personal"  "$HOME/.codex/personal"
link "$R/personal"  "$HOME/.claude/personal"

# Skills: one link per skill into both agents. Keeps ~/.codex/skills/.system intact
# and lets private skills under personal/skills/ ride along.
[ -L "$HOME/.claude/skills" ] && rm "$HOME/.claude/skills"
mkdir -p "$HOME/.claude/skills" "$HOME/.codex/skills"
for d in "$R"/skills/*/ "$R"/plugins/wooinwoo/skills/*/ "$R"/personal/skills/*/; do
  [ -f "$d/SKILL.md" ] || continue
  d="${d%/}"
  link "$d" "$HOME/.claude/skills/$(basename "$d")"
  link "$d" "$HOME/.codex/skills/$(basename "$d")"
done

# MCP launcher wrappers, referenced by bare name from codex/config.toml
for f in "$R"/bin/*; do link "$f" "$HOME/.local/bin/$(basename "$f")"; done

# Settings and hooks
link "$R/claude/settings.json" "$HOME/.claude/settings.json"
link "$R/codex/config.toml"    "$HOME/.codex/config.toml"
link "$R/codex/hooks.json"     "$HOME/.codex/hooks.json"

# Shared plugins (caveman, ponytail); both agents support them natively
if command -v claude >/dev/null 2>&1; then
  claude plugin marketplace add JuliusBrussee/caveman   >/dev/null 2>&1 || true
  claude plugin marketplace add DietrichGebert/ponytail >/dev/null 2>&1 || true
  claude plugin install caveman@caveman   -s user >/dev/null 2>&1 || true
  claude plugin install ponytail@ponytail -s user >/dev/null 2>&1 || true
fi
if command -v codex >/dev/null 2>&1; then
  codex plugin marketplace add JuliusBrussee/caveman   >/dev/null 2>&1 || true
  codex plugin marketplace add DietrichGebert/ponytail >/dev/null 2>&1 || true
  codex plugin add caveman@caveman   >/dev/null 2>&1 || true
  codex plugin add ponytail@ponytail >/dev/null 2>&1 || true
fi

# MCP: codex/config.toml is the source of truth; mirror it into Claude
if command -v claude >/dev/null 2>&1; then
  python3 "$R/mcp/sync-to-claude.py"
fi

echo "agent-config linked."
