#!/bin/bash
set -euo pipefail

SYSTEM_HOME="${1:-$HOME/SYOO1-Core}"
RUNTIME_DIR="$SYSTEM_HOME/runtime"
ENV_FILE="$SYSTEM_HOME/.env.local"
LAUNCH_AGENT="${2:-}"
START_TARGET_HINT="${3:-}"

if [ ! -d "$RUNTIME_DIR/.openclaw" ]; then
  echo "ERROR: runtime dir invalid: $RUNTIME_DIR"
  exit 1
fi

echo "=== validate-system-runtime-v1 ==="
echo "SYSTEM_HOME=$SYSTEM_HOME"
echo "RUNTIME_DIR=$RUNTIME_DIR"
echo

test -f "$ENV_FILE" && echo "OK   .env.local" || { echo "MISS .env.local"; exit 1; }

if [ -n "$START_TARGET_HINT" ]; then
  test -f "$RUNTIME_DIR/$START_TARGET_HINT" && echo "OK   runtime/$START_TARGET_HINT" || { echo "MISS runtime/$START_TARGET_HINT"; exit 1; }
fi

grep -q "$RUNTIME_DIR/workspace" "$RUNTIME_DIR/.openclaw/openclaw.json" && echo "OK   workspace" || { echo "FAIL workspace"; exit 1; }
grep -q "$SYSTEM_HOME/brain" "$RUNTIME_DIR/workspace/BOOTSTRAP.md" && echo "OK   bootstrap brain" || { echo "FAIL bootstrap brain"; exit 1; }

if [ -n "$LAUNCH_AGENT" ]; then
  test -f "$LAUNCH_AGENT" && echo "OK   launchagent file" || { echo "MISS launchagent file"; exit 1; }
  if [ -n "$START_TARGET_HINT" ]; then
    grep -q "$START_TARGET_HINT" "$LAUNCH_AGENT" && echo "OK   launchagent target" || { echo "FAIL launchagent target"; exit 1; }
  fi
fi

echo
echo "=== PASS ==="
