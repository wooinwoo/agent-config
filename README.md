# agent-config

Claude Code와 Codex CLI가 같은 설정을 쓰도록 묶어 둔 설정 레포입니다. 실제 파일은 여기 있고, `~/.claude`와 `~/.codex`에는 심링크만 놓입니다. 개인 정보와 기기 종속 값은 레포 밖(`personal/`, 환경변수, git 필터)으로 빼 두어 그대로 공개할 수 있습니다.

## 구성

| 경로 | 용도 | 연결 위치 |
|---|---|---|
| `AGENTS.md` | 공용 지침 | `~/.codex/AGENTS.md`, `~/.claude/CLAUDE.md` |
| `plugins/wooinwoo/` | 공유용 플러그인. 스킬 4개 + MCP 서버 4개. 출처는 그 안의 `THIRD_PARTY.md` | 마켓플레이스로 설치. 내 기기에선 스킬만 심링크 |
| `.claude-plugin/marketplace.json` | 마켓플레이스 매니페스트. Claude·Codex 둘 다 이 파일을 읽음 | 실행용 |
| `skills/` | 개인 프로젝트 전용 스킬 (cockpit-board) | `~/.claude/skills/<이름>`, `~/.codex/skills/<이름>` |
| `claude/settings.json` | Claude Code 설정·훅 | `~/.claude/settings.json` |
| `codex/config.toml` | Codex 설정·MCP 서버. MCP의 단일 원본 | `~/.codex/config.toml` |
| `codex/hooks.json` | Codex 훅 | `~/.codex/hooks.json` |
| `bin/` | MCP 실행 래퍼. 설정 파일에 절대경로를 남기지 않기 위한 것 | `~/.local/bin/` |
| `mcp/sync-to-claude.py` | config.toml의 MCP 서버를 Claude에 복제 | 실행용 |
| `scripts/clean-codex-config.py` | git clean 필터. Codex가 써 넣는 기기 상태를 커밋에서 제외 | git 설정 |
| `personal/` | 사내 메모와 개인 스킬. git 추적 안 함 | `~/.codex/personal`, `~/.claude/personal` |

## 남과 공유하기

설정 전체가 아니라 스킬과 MCP 서버만 받고 싶은 사람은 플러그인으로 설치하면 됩니다. 자기 설정은 건드리지 않습니다.

```bash
# Claude Code
claude plugin marketplace add wooinwoo/agent-config
claude plugin install wooinwoo@agent-config
claude plugin install caveman@agent-config
claude plugin install ponytail@agent-config

# Codex CLI
codex plugin marketplace add wooinwoo/agent-config
codex plugin add wooinwoo@agent-config
codex plugin add caveman@agent-config
codex plugin add ponytail@agent-config
```

`caveman`과 `ponytail`은 원저자 저장소를 그대로 가리키는 통과 항목입니다. 마켓플레이스 하나로 세 개를 다 받을 수 있게 넣어 두었습니다. Obsidian 볼트 경로처럼 사람마다 다른 값은 설치할 때 넣습니다. 자세한 것은 `plugins/wooinwoo/README.md`에 있습니다. Claude Code용 `rust-analyzer-lsp`는 Anthropic 공식 마켓에만 있어 `claude plugin install rust-analyzer-lsp@claude-plugins-official`로 따로 받습니다.

## 새 기기에서

```bash
git clone https://github.com/wooinwoo/agent-config ~/agent-config
~/agent-config/install.sh
```

`install.sh`는 심링크를 만들고, caveman·ponytail 플러그인을 양쪽에 설치하고, MCP 서버를 Claude에 복제합니다. 여러 번 실행해도 안전합니다. `personal/`은 비어 있어도 동작하며, 필요하면 직접 채웁니다.

## 기기 종속 값 다루기

설정 파일에는 `/home/사용자` 같은 경로를 두지 않습니다.

- 훅 명령은 셸에서 실행되므로 `$HOME`을 그대로 씁니다.
- MCP 서버는 `bin/` 래퍼를 이름만으로 호출합니다. 래퍼가 실행 시점에 경로를 찾습니다.
  - `obsidian-mcp`: `OBSIDIAN_VAULT` (기본 `/mnt/c/Users/$USER/Documents/Obsidian Vault`)
  - `playwright-mcp`: Playwright가 받아 둔 최신 Chromium
  - `stitch-mcp`: `STITCH_API_KEY`. 키는 `personal/env.sh`에 `export`로 두면 래퍼가 실행 시 읽습니다.
- Codex가 `config.toml`에 써 넣는 `[projects.*]`, `[hooks.state.*]`, `[tui.*]`는 git clean 필터가 커밋에서 걷어냅니다. 작업 복사본에는 남아 있으므로 Codex 동작에는 영향이 없습니다.

## MCP 서버 추가하기

잠시 안 쓰는 서버는 지우지 말고 `codex/config.toml`의 해당 테이블에 `enabled = false`를 두면 됩니다. 동기화 스크립트가 Claude에서도 내립니다. 다시 켤 때는 값을 지우고 한 번 더 실행합니다.

`codex mcp add <name> -- <command...>`로 Codex에 추가한 뒤 `mcp/sync-to-claude.py`를 실행하면 Claude에도 같은 서버가 등록됩니다. `~/.claude.json`은 캐시와 인증 정보가 섞여 있어 추적하지 않습니다.

## 추적하지 않는 것

- `~/.claude/settings.local.json`, `~/.codex/rules/`, `~/.codex/auth.json`, `~/.claude.json`: 권한 누적 기록과 인증 정보
- `personal/`: 사내 메모, 개인 폴더 구조에 묶인 스킬
- 메모리: Claude는 `~/.claude/projects/*/memory/`, Codex는 sqlite. 서로 호환되지 않아 각자 둡니다.

## 주의

- `hermes codex-runtime migrate`를 실행하면 hermes가 `config.toml`에 `hermes-tools` MCP 블록을 절대경로로 다시 넣습니다. 쓰지 않으면 `codex mcp remove hermes-tools`로 지우면 됩니다.
- `codex/hooks.json` 내용이 바뀌면 Codex가 다음 실행 때 훅 신뢰 여부를 한 번 다시 묻습니다.
