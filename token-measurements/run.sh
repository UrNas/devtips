#!/usr/bin/env bash
# Measure what each "token saving" fix actually saves.
#
# Every condition runs the SAME task against the SAME fixture checkout, changing
# exactly one variable. Usage comes from `claude -p --output-format json`, which
# reports input/output tokens, cache reads, cost and turns — so anyone can
# re-run this and get their own numbers.
#
#   ./run.sh <condition> <rep>
set -euo pipefail
COND="${1:?condition}"; REP="${2:-1}"
ROOT="$(cd "$(dirname "$0")" && pwd)"
WORK="$ROOT/work/${COND}-${REP}"
OUT="$ROOT/runs/${COND}-${REP}.json"

# Fresh checkout per run: no leftover edits, no warm state.
rm -rf "$WORK"; mkdir -p "$(dirname "$WORK")"
cp -R "$ROOT/fixture" "$WORK"

TASK="Sessions never expire. Find the cause in this repo and fix it."

case "$COND" in
  baseline)
    PROMPT="$TASK"
    ;;
  scoped)
    PROMPT="$TASK

Before reading any file, grep for the relevant symbol and read ONLY the files that match. Do not read whole directories."
    ;;
  plan-first)
    PROMPT="$TASK

Before editing anything, output a 3-line plan: which files, in what order, and what is most likely to break. Then make the fix."
    ;;
  bloated-md)
    # Same task, but with a long CLAUDE.md — tests whether memory-file length is
    # a recurring cost, which is claim #3 in the limits video.
    python3 "$ROOT/gen_claude_md.py" long > "$WORK/CLAUDE.md"
    PROMPT="$TASK"
    ;;
  short-md)
    python3 "$ROOT/gen_claude_md.py" short > "$WORK/CLAUDE.md"
    PROMPT="$TASK"
    ;;
  big-direct|big-plan)
    # A deliberately under-specified task where the obvious implementation is
    # the wrong one. The correction is identical in both arms; only its timing
    # differs. This is the fair test of "plan first" that the small bug-fix
    # task could never be — there, planning is pure ceremony.
    T1="Add rate limiting to this API."
    [ "$COND" = "big-plan" ] && T1="$T1

First output a 3-line plan: which files, in what order, and what is most likely to break. Do NOT edit any files yet."
    CORRECTION="It has to be per-user and persisted in postgres, not in-memory. Implement it that way."

    cd "$WORK"
    S1=$(date +%s)
    claude -p "$T1" --output-format json --dangerously-skip-permissions > "$OUT.turn1" 2>"$OUT.err" || {
      echo "turn1 failed: $COND-$REP" >&2; exit 1; }
    SID=$(python3 -c "import json,sys;print(json.load(open('$OUT.turn1'))['session_id'])")
    claude -p "$CORRECTION" --resume "$SID" --output-format json --dangerously-skip-permissions > "$OUT.turn2" 2>>"$OUT.err" || {
      echo "turn2 failed: $COND-$REP" >&2; exit 1; }
    S2=$(date +%s)

    python3 - "$OUT" "$COND" "$REP" "$((S2-S1))" <<'PYEOF'
import json,sys
out,cond,rep,wall=sys.argv[1],sys.argv[2],sys.argv[3],int(sys.argv[4])
a=json.load(open(out+".turn1")); b=json.load(open(out+".turn2"))
def u(d,k): return d.get("usage",{}).get(k,0)
merged={"usage":{k:u(a,k)+u(b,k) for k in
         ["input_tokens","cache_creation_input_tokens","cache_read_input_tokens","output_tokens"]},
        "num_turns":a.get("num_turns",0)+b.get("num_turns",0),
        "total_cost_usd":a.get("total_cost_usd",0)+b.get("total_cost_usd",0),
        "_meta":{"condition":cond,"rep":int(rep),"wall_s":wall,"two_turn":True,
                 "turn1_cost":a.get("total_cost_usd",0),"turn2_cost":b.get("total_cost_usd",0)}}
json.dump(merged,open(out,"w"),indent=1)
uu=merged["usage"]
tot=uu["input_tokens"]+uu["cache_creation_input_tokens"]+uu["cache_read_input_tokens"]
print(f"{cond}-{rep}: total_in={tot} out={uu['output_tokens']} turns={merged['num_turns']} "
      f"cost=${merged['total_cost_usd']:.4f} (t1 ${a.get('total_cost_usd',0):.2f} + t2 ${b.get('total_cost_usd',0):.2f}) wall={wall}s")
PYEOF
    exit 0
    ;;
  *) echo "unknown condition: $COND" >&2; exit 1 ;;
esac

cd "$WORK"
START=$(date +%s)
claude -p "$PROMPT" --output-format json --dangerously-skip-permissions > "$OUT" 2>"$OUT.err" || {
  echo "run failed: $COND-$REP (see $OUT.err)" >&2; exit 1; }
END=$(date +%s)

python3 - "$OUT" "$COND" "$REP" "$((END-START))" <<'PY'
import json,sys
f,cond,rep,wall=sys.argv[1],sys.argv[2],sys.argv[3],sys.argv[4]
d=json.load(open(f)); u=d.get("usage",{})
d["_meta"]={"condition":cond,"rep":int(rep),"wall_s":int(wall)}
json.dump(d,open(f,"w"),indent=1)
tot=u.get("input_tokens",0)+u.get("cache_creation_input_tokens",0)+u.get("cache_read_input_tokens",0)
print(f"{cond}-{rep}: in={u.get('input_tokens',0)} cache_w={u.get('cache_creation_input_tokens',0)} "
      f"cache_r={u.get('cache_read_input_tokens',0)} out={u.get('output_tokens',0)} "
      f"total_in={tot} turns={d.get('num_turns')} cost=${d.get('total_cost_usd',0):.4f} wall={wall}s")
PY
