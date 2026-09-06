#!/usr/bin/env python3
"""Two CLAUDE.md files that say the SAME things — one terse, one padded.

The limits video claims CLAUDE.md length is a recurring per-session cost. This
isolates that: identical rules, different verbosity.
"""
import sys
RULES = [
    ("Package manager", "pnpm, never npm"),
    ("Tests", "vitest, in __tests__/ beside the source"),
    ("Style", "2-space indent, no semicolons omitted"),
    ("Imports", "never import from src/legacy/"),
    ("DB", "all queries go through src/db/client.ts"),
    ("Auth", "every endpoint calls requireAuth first"),
    ("Time", "use helpers in src/lib/time.ts, never raw ms literals"),
]
if sys.argv[1] == "short":
    print("# Conventions\n")
    for k, v in RULES:
        print(f"- {k}: {v}")
else:
    print("# Project conventions and engineering guidelines\n")
    print("This document describes the conventions used throughout this codebase.")
    print("Please read it carefully before making any changes.\n")
    for k, v in RULES:
        print(f"## {k}\n")
        print(f"The convention for {k.lower()} in this project is: {v}.")
        print(f"This is important because consistency in {k.lower()} makes the codebase")
        print(f"easier to maintain over time. If you are unsure about {k.lower()},")
        print(f"please follow the existing patterns you find in the code. Do not")
        print(f"deviate from this convention without discussing it first.\n")
    print("## General notes\n")
    for i in range(1, 26):
        print(f"{i}. Prefer clarity over cleverness in all code you write here.")
