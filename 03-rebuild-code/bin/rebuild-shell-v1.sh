#!/bin/bash
set -euo pipefail

BASE="$HOME/OpenClaw-MinShell-V1"
LOG="$BASE/logs/rebuild.log"

mkdir -p "$BASE/logs" "$BASE/state" "$BASE/stage-snapshots" "$BASE/skills" "$BASE/sync-links"

exec > >(tee -a "$LOG") 2>&1

echo "=== Rebuild Shell V1 ==="
date
echo

echo "=== Step 1: base folders ==="
mkdir -p "$BASE/bin" "$BASE/docs" "$BASE/logs" "$BASE/state" "$BASE/stage-snapshots" "$BASE/skills" "$BASE/sync-links"
echo "OK"

echo
echo "=== Step 2: runtime check ==="
echo "openclaw: $(command -v openclaw || true)"
echo "tailscale: $(command -v tailscale || true)"
echo "git: $(command -v git || true)"
echo "node: $(command -v node || true)"
echo "npm: $(command -v npm || true)"

echo
echo "=== Step 3: version check ==="
openclaw --version || true
tailscale version 2>/dev/null || true
git --version || true
node -v 2>/dev/null || true
npm -v 2>/dev/null || true

echo
echo "=== Step 4: current shell snapshot of files ==="
find "$BASE" -maxdepth 2 | sort

echo
echo "=== Step 5: brain attach check ==="
if [ -x "$BASE/bin/attach-brain-v1.sh" ]; then
  "$BASE/bin/attach-brain-v1.sh" || true
else
  echo "attach-brain-v1.sh missing"
fi

echo
echo "=== Step 6: manual follow-ups ==="
echo "1. Confirm openclaw is 2026.2.26"
echo "2. Confirm gateway config exists in ~/.openclaw/openclaw.json"
echo "3. Confirm Tailscale connection state if needed"
echo "4. Confirm brain GitHub fallback URL/branch if you want remote recovery"
echo "5. Start shell with: $BASE/bin/oc.sh start"

echo
echo "Rebuild Shell V1 completed."
