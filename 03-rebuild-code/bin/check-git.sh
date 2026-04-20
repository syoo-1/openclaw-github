#!/bin/bash
set -euo pipefail

TARGET="${1:-$HOME/OpenClaw-MinShell-V1}"

echo "=== target ==="
echo "$TARGET"

echo
echo "=== git version ==="
git --version || true

echo
echo "=== repo root ==="
git -C "$TARGET" rev-parse --show-toplevel 2>/dev/null || echo "Not a git repo"

echo
echo "=== remote ==="
git -C "$TARGET" remote -v 2>/dev/null || true

echo
echo "=== branch ==="
git -C "$TARGET" branch --show-current 2>/dev/null || true

echo
echo "=== status ==="
git -C "$TARGET" status --short 2>/dev/null || true

echo
echo "=== last commits ==="
git -C "$TARGET" log --oneline -5 2>/dev/null || true
