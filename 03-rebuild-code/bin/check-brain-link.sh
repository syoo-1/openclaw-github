#!/bin/bash
set -euo pipefail

BRAIN_PATH_FILE="$HOME/OpenClaw-MinShell-V1/brain-link/BRAIN.path"

if [ ! -f "$BRAIN_PATH_FILE" ]; then
  echo "BRAIN.path missing"
  exit 1
fi

BRAIN_ROOT="$(cat "$BRAIN_PATH_FILE")"

echo "=== brain root ==="
echo "$BRAIN_ROOT"

echo
echo "=== exists ==="
if [ -d "$BRAIN_ROOT" ]; then
  echo "YES"
else
  echo "NO"
fi

echo
echo "=== key files ==="
for p in \
  "$BRAIN_ROOT/CURRENT.md" \
  "$BRAIN_ROOT/identity" \
  "$BRAIN_ROOT/longterm" \
  "$BRAIN_ROOT/trigger_handoff" \
  "$BRAIN_ROOT/recovery"
do
  if [ -e "$p" ]; then
    echo "OK  $p"
  else
    echo "MISS $p"
  fi
done
