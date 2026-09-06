# token-measurements

The raw data behind **"Everyone claims 90% token savings. I measured it."**

Every number in that video comes from these files. Re-run it and check me.

## What was measured

Five "token saving" techniques, each run against the same 15-file fixture repo
with the same task, changing exactly one variable, **3 repetitions each**.
21 runs total.

Usage comes from `claude -p --output-format json`, which reports input/output
tokens, cache reads, cost and turn count — so this is Claude Code measuring
itself, not my estimate.

## Results

**Small, well-specified task** (fix one bug):

| Condition | Cost | Range | Turns | vs baseline | Verdict |
|---|---|---|---|---|---|
| `scoped` — grep first, read only matches | $0.51 | 0.46–0.56 | 8.7 | **−16%** | holds, ±8% spread |
| `short-md` — terse CLAUDE.md | $0.56 | 0.44–0.71 | 9.3 | −7% | inside the noise |
| `baseline` | $0.60 | 0.51–0.68 | 12.0 | — | — |
| `bloated-md` — padded CLAUDE.md | $0.68 | 0.48–0.94 | 13.0 | +13% | **unproven**, ±29% |
| `plan-first` | $0.71 | 0.56–0.80 | 16.0 | **+18%** | costs more, every run |

**Large, ambiguous task** (add rate limiting, then a spec correction lands):

| Condition | Cost | Range | Turns | vs |
|---|---|---|---|---|
| `big-direct` | $2.02 | 1.70–2.29 | 25.3 | — |
| `big-plan` | $1.23 | 1.10–1.34 | 14.7 | **−39%**, ±8% |

## What that means

**Planning flips sign depending on the task.** It costs 18% more on a small,
clear job — the plan is ceremony when the work is obvious. It saves 39% on a
large, vague one, because the correction lands on a 3-line plan instead of 400
lines of implementation. Same technique, opposite result.

**The CLAUDE.md length claim did not survive.** I made that claim myself in an
earlier video. One run showed +78%. Three runs showed +13% with a ±29% spread —
individual runs ranged $0.48 to $0.94 for the *same condition*. So it ships as
unproven. It might be real; I haven't shown it.

**The re-reading is real.** The baseline logged 29,481 tokens written into cache
against 350,876 read back out across 14 turns — roughly 12×. That is the
mechanic behind every one of these fixes.

## Run it yourself

```bash
./run.sh baseline 1
./run.sh scoped 1
./run.sh plan-first 1
./run.sh short-md 1
./run.sh bloated-md 1
./run.sh big-direct 1     # two-turn: task, then a spec correction
./run.sh big-plan 1
```

Each run costs real money (~$0.50 on the small task, ~$2 on the large one).
21 runs cost $18.94.

Results land in `runs/<condition>-<rep>.json`. `summary.json` is the aggregate.

## Caveats, stated plainly

- **n=3.** Enough to catch the CLAUDE.md result as noise; not enough to settle a
  10% difference. Treat anything under ~15% with suspicion.
- **One task, one fixture.** A different codebase may behave differently.
- `/clear` and `/compact` are not tested here — they are interactive commands and
  this harness is headless. The `scoped` and session-level results are proxies.
- Costs are API prices at time of running and will drift.

If you re-run this and get something different, that is useful — say so.
