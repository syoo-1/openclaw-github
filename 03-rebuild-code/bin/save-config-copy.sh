#!/bin/bash
set -euo pipefail
mkdir -p "$HOME/OpenClaw-MinShell-V1/state"
cp "$HOME/.openclaw/openclaw.json" "$HOME/OpenClaw-MinShell-V1/state/openclaw.json.current"
echo "Saved:"
echo "$HOME/OpenClaw-MinShell-V1/state/openclaw.json.current"
