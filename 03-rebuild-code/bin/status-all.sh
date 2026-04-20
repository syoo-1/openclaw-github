#!/bin/bash
set -euo pipefail
echo "=== shell tree ==="
"$HOME/OpenClaw-MinShell-V1/bin/tree-shell.sh"
echo
echo "=== config copy ==="
ls -l "$HOME/OpenClaw-MinShell-V1/state/openclaw.json.current" 2>/dev/null || true
echo
echo "=== runtime ==="
"$HOME/OpenClaw-MinShell-V1/bin/show-ip.sh"
echo
"$HOME/OpenClaw-MinShell-V1/bin/show-ports.sh"
echo
"$HOME/OpenClaw-MinShell-V1/bin/show-openclaw-proc.sh"
