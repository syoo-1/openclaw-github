#!/bin/bash
set -euo pipefail

BASE="$HOME/OpenClaw-MinShell-V1"
case "${1:-}" in
  start)
    exec "$BASE/bin/start-gateway.sh"
    ;;
  stop)
    exec "$BASE/bin/stop-gateway.sh"
    ;;
  check)
    exec "$BASE/bin/check-gateway.sh"
    ;;
  *)
    echo "Usage: $0 {start|stop|check}"
    exit 1
    ;;
esac
