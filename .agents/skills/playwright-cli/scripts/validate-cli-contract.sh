#!/usr/bin/env bash
set -euo pipefail

skill_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cli=${PLAYWRIGHT_CLI:-playwright-cli}

fail() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

command -v "$cli" >/dev/null 2>&1 || fail "$cli is not installed"
version=$($cli --version 2>&1) || fail "could not read $cli version"
printf 'Validating Playwright CLI contract against version %s\n' "$version"

main_help=$($cli --help 2>&1)
for command_name in open attach close detach goto snapshot state-load requests tracing-start tracing-stop video-start video-stop; do
  grep -Eq "(^|[[:space:]])${command_name}([[:space:]]|$)" <<<"$main_help" \
    || fail "required command is unavailable: $command_name"
done

open_help=$($cli open --help 2>&1)
attach_help=$($cli attach --help 2>&1)
video_start_help=$($cli video-start --help 2>&1)
video_stop_help=$($cli video-stop --help 2>&1)

grep -q -- '--extension' <<<"$attach_help" || fail 'attach does not support --extension'
if grep -q -- '--extension' <<<"$open_help"; then
  fail 'unexpected contract change: open now advertises --extension; review the skill before updating it'
fi
grep -q '\[filename\]' <<<"$video_start_help" || fail 'video-start does not accept the output filename'
if grep -q '\[filename\]' <<<"$video_stop_help"; then
  fail 'unexpected contract change: video-stop now accepts a filename; review the skill before updating it'
fi

scan_root() {
  local pattern=$1
  local message=$2
  local scan_file
  scan_file=$(mktemp "${TMPDIR:-/tmp}/playwright-skill-scan.XXXXXX")
  if grep -R -n -E --include='*.md' "$pattern" "$skill_root/SKILL.md" "$skill_root/references" >"$scan_file" 2>/dev/null; then
    cat "$scan_file" >&2
    rm -f "$scan_file"
    fail "$message"
  fi
  rm -f "$scan_file"
}

scan_root 'playwright-cli.*open.*--extension' 'found invalid open --extension syntax'
scan_root 'playwright-cli.*open.*--attach' 'found invalid open --attach syntax'
scan_root 'playwright-cli.*[[:space:]]network([[:space:]]|$)' 'found obsolete network command; use requests'
scan_root 'playwright-cli.*video-stop[[:space:]]+[^#[:space:]]' 'found a filename or argument passed to video-stop'
scan_root 'playwright-cli.*cookie-list' 'found cookie-list, which can expose sensitive cookie values'

# Validate lifecycle ordering inside every executable Markdown shell block. Commands
# that need a browser must follow open/attach for the same named session.
python3 - "$skill_root" <<'PY'
from pathlib import Path
import re
import sys

root = Path(sys.argv[1])
files = [root / "SKILL.md", *sorted((root / "references").glob("*.md"))]
command = re.compile(r"^\s*playwright-cli\s+-s=([^\s]+)\s+(\S+)(?:\s+(.*))?$")
requires_browser = {"state-load", "tracing-start", "video-start"}
errors = []

for path in files:
    in_bash = False
    opened = set()
    for lineno, line in enumerate(path.read_text().splitlines(), 1):
        if line.startswith("```bash"):
            in_bash = True
            opened = set()
            continue
        if in_bash and line.startswith("```"):
            in_bash = False
            opened = set()
            continue
        if not in_bash:
            continue
        match = command.match(line)
        if not match:
            continue
        session, action, arguments = match.groups()
        if action in {"open", "attach"}:
            opened.add(session)
        elif action in {"close", "detach"}:
            opened.discard(session)
        elif action in requires_browser and session not in opened:
            errors.append(f"{path}:{lineno}: {action} appears before open/attach for session {session}")
        if action == "video-stop" and arguments and not arguments.lstrip().startswith("#"):
            errors.append(f"{path}:{lineno}: video-stop must not receive an argument")

if errors:
    print("\n".join(errors), file=sys.stderr)
    raise SystemExit(1)
PY

workdir=$(mktemp -d "${TMPDIR:-/tmp}/playwright-skill-contract.XXXXXX")
session="skill-contract-$(date +%s)-$$-$RANDOM"
state_file="$workdir/empty-state.json"
video_file="$workdir/contract.webm"

cleanup() {
  "$cli" -s="$session" close >/dev/null 2>&1 || true
  "$cli" -s="$session" delete-data >/dev/null 2>&1 || true
  rm -rf "$workdir"
}
trap cleanup EXIT INT TERM

printf '{"cookies":[],"origins":[]}\n' >"$state_file"

# Keep generated snapshots and artifacts out of the caller's repository.
cd "$workdir"
"$cli" -s="$session" open about:blank >/dev/null
"$cli" -s="$session" state-load "$state_file" >/dev/null
"$cli" -s="$session" tracing-start >/dev/null
"$cli" -s="$session" tracing-stop >/dev/null
"$cli" -s="$session" video-start "$video_file" >/dev/null
"$cli" -s="$session" video-stop >/dev/null
"$cli" -s="$session" requests >/dev/null
"$cli" -s="$session" close >/dev/null

printf 'Playwright CLI command contract passed.\n'
