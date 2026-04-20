#!/bin/bash
set -euo pipefail

echo "=== binaries ==="
command -v tailscale || true
command -v tailscaled || true

echo
echo "=== version ==="
tailscale version 2>/dev/null || true

echo
echo "=== status ==="
tailscale status 2>/dev/null || true

echo
echo "=== launch agents/services ==="
ls ~/Library/LaunchAgents 2>/dev/null | grep -i tailscale || true
launchctl list | grep -i tailscale || true
