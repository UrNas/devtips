#!/usr/bin/env bash
# Format the file Claude just touched. Never fail the turn.
[ -z "${CLAUDE_FILE_PATHS:-}" ] && exit 0
npx --no-install prettier --write "$CLAUDE_FILE_PATHS" 2>&1 | tail -5
exit 0
