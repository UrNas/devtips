#!/usr/bin/env bash
[ -z "${CLAUDE_FILE_PATHS:-}" ] && exit 0
npx --no-install eslint --fix "$CLAUDE_FILE_PATHS" 2>&1 | tail -10
exit 0
