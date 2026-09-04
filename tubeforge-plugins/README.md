# tubeforge plugins

The token-saving Claude Code setup from [the TubeForge channel](https://youtube.com/@TubeForgeHQ),
as five installable plugins.

Companion to **"The 5 Claude Code plugins that cut my token bill."**

## Install

```
/plugin marketplace add UrNas/devtips
/plugin install token-guard@tubeforge
```

> `.claude-plugin/marketplace.json` is published at the **repo root**, not inside
> this folder — that is what makes `add UrNas/devtips` resolve. Its `source` paths
> are therefore repo-root-relative (`./tubeforge-plugins/plugins/...`).

Install only what you want — each plugin stands alone.

## What's in here

| Plugin | Ships | Replaces |
|---|---|---|
| `token-guard` | `hooks/hooks.json` + 5 hook scripts | hand-editing `~/.claude/settings.json` |
| `context-kit` | `.mcp.json` with 5 servers | wiring MCP servers per project |
| `review-crew` | 5 subagents in `agents/` | copying agent files between machines |
| `skill-pack` | 5 skills in `skills/` | re-typing the same instructions |
| `memory-kit` | `/remember` + a memory-hygiene skill | writing CLAUDE.md by hand |

### token-guard
`PostToolUse` runs prettier, eslint --fix, tsc and vitest on the file Claude just
touched. `PreToolUse` blocks obviously destructive bash before it runs. The point is
that fixes land *before* you read the diff, so you stop spending a turn asking for
them — and that turn costs a full context window.

Scripts use `${CLAUDE_PLUGIN_ROOT}` so they resolve wherever the plugin is installed.
Every hook exits 0 on missing tooling, so it can't fail your turn. The exception is
`safety-guard.sh`, which exits 2 deliberately to stop a destructive command.

### context-kit
context7 (live library docs), github, postgres, filesystem, playwright. `postgres`
expects `DATABASE_URL` in the environment.

### review-crew
reviewer, tester, doc-writer, researcher, migrator — each with its own tool list and
its own context window, so review and test work stops growing your main thread.

### skill-pack
auto-compactor, plan-or-stop, spec-first-coder, review-before-run, test-writer.
Loaded on relevance, not on every turn.

### memory-kit
`/remember` writes the correction you just made into the right `CLAUDE.md` — project,
user, or package — as one imperative line, and edits an existing line rather than
adding a contradictory one. The `memory-hygiene` skill keeps the file short, because
CLAUDE.md is read on every session start and length is a recurring cost.

## Plugin layout

```
plugin-name/
├── .claude-plugin/plugin.json   # manifest — must live here
├── commands/                    # slash commands
├── agents/                      # subagents
├── skills/<name>/SKILL.md       # agent skills
├── hooks/hooks.json             # event handlers
└── .mcp.json                    # MCP servers
```

Component folders sit at the plugin root, never inside `.claude-plugin/`.

## Verified

All five install cleanly and register their components (Claude Code 2.1.260).

## Related videos

- The 5 Claude Code Skills that cut my token bill in half
- The 5 MCP servers I use in every Claude Code session
- The 5 Claude Code subagents I run in parallel
- 5 Claude Code hooks that cut your token usage
- 5 CLAUDE.md tricks that save Claude Code tokens

MIT.
