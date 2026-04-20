#!/bin/bash
set -euo pipefail

BASE="$HOME/OpenClaw-MinShell-V1"
OUT="$BASE/stage-snapshots"
TS="$(date +%Y%m%d-%H%M%S)"
NAME="minshell-stage-$TS.tar.gz"

mkdir -p "$OUT"

tar -czf "$OUT/$NAME" \
  --exclude="OpenClaw-MinShell-V1/stage-snapshots/*.tar.gz" \
  -C "$HOME" \
  OpenClaw-MinShell-V1 \
  .openclaw

echo "Stage snapshot created:"
echo "$OUT/$NAME"
