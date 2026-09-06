# devtips
Short, practical developer tips — the code behind every TubeForge video.

[Click here to watch](https://www.youtube.com/@TubeForgeHQ)

## tubeforge-plugins

The whole setup as five installable Claude Code plugins:

```
/plugin marketplace add UrNas/devtips
/plugin install token-guard@tubeforge
```

`token-guard` (hooks) · `context-kit` (MCP) · `review-crew` (subagents) ·
`skill-pack` (skills) · `memory-kit` (`/remember`).
See [tubeforge-plugins/](tubeforge-plugins/).

## token-measurements

The raw data behind *"Everyone claims 90% token savings. I measured it."* —
21 runs, the harness that produced them, and the fixture repo.

Every number in that video traces to a file in
[token-measurements/](token-measurements/). Re-run it and check me.
