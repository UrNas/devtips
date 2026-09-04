#!/usr/bin/env bash
# Block obviously destructive commands before they run.
# Exit 2 tells Claude Code to stop and reconsider.
INPUT=$(cat)
if printf "%s" "$INPUT" | grep -Eq "rm -rf (/|~|\\\$HOME)|git push --force( |$)|DROP TABLE|:(){:|:&};:"; then
  echo "safety-guard: refusing a destructive command. Run it yourself if you meant it." >&2
  exit 2
fi
exit 0
