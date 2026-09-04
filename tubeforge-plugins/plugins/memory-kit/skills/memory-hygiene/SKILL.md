---
name: memory-hygiene
description: Use when CLAUDE.md has grown past ~40 lines, contains contradictions, or the user asks to clean up project memory.
---

CLAUDE.md is read on every session start, so its length is a recurring cost.

When reviewing one:

1. **Delete what the code already says.** File structure, framework names and
   scripts are discoverable. Keep only what is non-obvious or counter-intuitive.
2. **Merge contradictions.** Two lines that disagree make the file worse than
   having neither — resolve it with the user rather than keeping both.
3. **Cut stale rules.** A rule about a folder that no longer exists is noise
   that costs tokens every session.
4. **Split by scope.** Rules that apply to one package belong in that package's
   CLAUDE.md, not the root.

Target: under 40 lines at the root. Report what you would remove and why
before removing anything.
