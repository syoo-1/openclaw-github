#!/bin/bash
set -euo pipefail

ALLOW_REBOOT="${1:-}"

echo "=== clean: normal stop ==="
openclaw gateway stop 2>/dev/null || true

echo
echo "=== clean: process kill ==="
pkill -f "openclaw-gateway" || true
pkill -f "openclaw gateway --allow-unconfigured --port 18789" || true
pkill -f "node.*18789" || true

sleep 2

echo
echo "=== clean: force kill by port 18789 ==="
PIDS="$(lsof -tiTCP:18789 -sTCP:LISTEN 2>/dev/null || true)"
if [ -n "$PIDS" ]; then
  echo "force killing pid(s): $PIDS"
  kill -9 $PIDS || true
  sleep 2
fi

echo
echo "=== after clean ==="
if lsof -nP -iTCP:18789 -sTCP:LISTEN >/dev/null 2>&1; then
  echo "STILL_OCCUPIED"
  lsof -nP -iTCP:18789 -sTCP:LISTEN || true

  if [ "$ALLOW_REBOOT" = "--allow-reboot" ]; then
    echo
    echo "=== final fallback: reboot ==="
    echo "Port 18789 still occupied. Rebooting system..."
    sudo shutdown -r now
  else
    echo
    echo "REBOOT_FALLBACK_AVAILABLE=YES"
    echo "Run with: clean-start-state.sh --allow-reboot"
    exit 1
  fi
else
  echo "PORT_18789_FREE"
fi
