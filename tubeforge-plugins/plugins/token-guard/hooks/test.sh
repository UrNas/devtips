#!/usr/bin/env bash
[ -z "${CLAUDE_FILE_PATHS:-}" ] && exit 0
npx --no-install vitest related --run "$CLAUDE_FILE_PATHS" 2>&1 | tail -20
exit 0
