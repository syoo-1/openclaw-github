#!/bin/bash
set -euo pipefail
mkdir -p "$HOME/.openclaw" "$HOME/OpenClaw-MinShell-V1/logs"
exec openclaw gateway --allow-unconfigured --port 18789 2>&1 | tee -a "$HOME/OpenClaw-MinShell-V1/logs/gateway.log"
