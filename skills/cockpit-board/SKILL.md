---
name: cockpit-board
description: Manage the Cockpit canvas sticky note and ID-based checklist through a deterministic local CLI. Use when the user asks Codex to view, list, add, edit, complete, reopen, or delete Cockpit tasks; refers to a T-xxxx task ID; or asks to read, replace, or append the Cockpit sticky memo.
---

# Cockpit Board

Use the bundled `scripts/cockpit-board.mjs` CLI. It uses the localhost API when available and otherwise falls back to the bundled, trusted file service against Cockpit's durable user-data file.

## Workflow

1. Run `list` before changing an existing task unless the user supplied an exact `T-xxxx` ID and the action is unambiguous.
2. Execute the narrowest matching command.
3. Report the returned task ID and final state concisely.
4. Never edit `.cockpit-board.json` manually. Do not restart Cockpit to perform a board operation.

## Commands

Run the script with Node from this skill directory:

```bash
node scripts/cockpit-board.mjs list
node scripts/cockpit-board.mjs task add "터미널 스크롤 버그 확인"
node scripts/cockpit-board.mjs task done T-0001
node scripts/cockpit-board.mjs task reopen T-0001
node scripts/cockpit-board.mjs task edit T-0001 "수정된 태스크 내용"
node scripts/cockpit-board.mjs task delete T-0001
node scripts/cockpit-board.mjs note get
node scripts/cockpit-board.mjs note set "메모 전체 교체"
node scripts/cockpit-board.mjs note append "기존 메모 아래에 추가"
```

Pass `--url http://127.0.0.1:PORT` when Cockpit uses a non-default URL. Set `COCKPIT_BOARD_FILE` only for an explicitly isolated board file, such as a test fixture.

Treat delete and `note set` as destructive within the board. Require clear user intent; prefer `note append` when the user says to add something to the memo.
