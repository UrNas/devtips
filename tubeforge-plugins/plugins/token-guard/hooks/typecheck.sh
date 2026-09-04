#!/usr/bin/env bash
[ -f tsconfig.json ] || exit 0
npx --no-install tsc --noEmit --pretty 2>&1 | head -30
exit 0
