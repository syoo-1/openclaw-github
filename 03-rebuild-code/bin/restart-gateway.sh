#!/bin/bash
set -euo pipefail
"$HOME/OpenClaw-MinShell-V1/bin/stop-gateway.sh" || true
sleep 1
exec "$HOME/OpenClaw-MinShell-V1/bin/start-gateway.sh"
