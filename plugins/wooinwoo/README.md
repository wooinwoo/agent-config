# wooinwoo plugin

Skills and MCP servers I use in both Claude Code and Codex CLI, packaged so they install the same way in either tool.

## Install

```bash
# Claude Code
claude plugin marketplace add wooinwoo/agent-config
claude plugin install wooinwoo@agent-config

# Codex CLI
codex plugin marketplace add wooinwoo/agent-config
codex plugin add wooinwoo@agent-config
```

The same marketplace also lists `caveman` and `ponytail` (pass-through entries pointing at their upstream repos), so `claude plugin install caveman@agent-config` / `codex plugin add caveman@agent-config` work too.

## What you get

Skills: `adversarial-verifier`, `prompt-optimizer`, `impeccable`, `ui-ux-pro-max` (origins and licenses in `THIRD_PARTY.md`).

MCP servers: `context7`, `playwright`, `chrome-devtools`, `obsidian`.

## Configuring paths

The `obsidian` server exposes one folder and needs to know which one.

- Claude Code asks for it at install time (`obsidian_vault`), or pass it directly: `claude plugin install wooinwoo@agent-config --config obsidian_vault=/path/to/vault`.
- Codex reads the `OBSIDIAN_VAULT` environment variable. Export it in your shell profile before starting Codex.

Leave it unset if you do not use Obsidian; the other servers work regardless.

`chrome-devtools` attaches to a Chrome instance started with remote debugging enabled. Without one it stays idle.

## Optional: ripgrep

Codex (Linux builds), Claude Code and opencode ship their own `rg`, so nothing to install for them. The Windows npm build of Codex does not bundle it and falls back to your PATH, so on Windows run `winget install BurntSushi.ripgrep.MSVC` if you want fast search there.
