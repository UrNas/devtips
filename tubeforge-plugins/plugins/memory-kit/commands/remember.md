---
description: Write the correction you just made into the right CLAUDE.md so it never has to be said again.
---

The user has just corrected you, or stated a preference worth keeping.

1. Identify the correction. If it isn't obvious from the last few turns, ask
   which one they mean — don't guess and write the wrong thing.

2. Decide where it belongs:
   - applies to this repo → `./CLAUDE.md`
   - applies to how they work everywhere → `~/.claude/CLAUDE.md`
   - applies to one package in a monorepo → `<that package>/CLAUDE.md`

3. Write it as one imperative line under the right heading. Not a story, not
   the conversation — the rule.

   Good:  Package manager: pnpm (never npm)
   Bad:   The user mentioned that they prefer pnpm because npm caused issues

4. If a line already covers it, EDIT that line instead of adding a second one.
   A CLAUDE.md that contradicts itself is worse than a short one.

5. Show the diff and wait for confirmation before writing.

Keep the file short. Every line is read on every session — a bloated CLAUDE.md
costs tokens on every single turn, which defeats the point.
