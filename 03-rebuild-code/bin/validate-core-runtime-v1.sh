#!/bin/bash
set -euo pipefail

CORE_RUNTIME="${1:-$HOME/SYOO1-Core/runtime}"

if [ ! -d "$CORE_RUNTIME/.openclaw" ]; then
  echo "ERROR: runtime dir invalid: $CORE_RUNTIME"
  exit 1
fi

echo "=== validate-core-runtime-v1 ==="
echo "CORE_RUNTIME=$CORE_RUNTIME"
echo

test -f "$HOME/SYOO1-Core/.env.local" && echo "OK   .env.local" || { echo "MISS .env.local"; exit 1; }
test -f "$HOME/SYOO1-Core/bin/start-core.sh" && echo "OK   start-core.sh" || { echo "MISS start-core.sh"; exit 1; }
test -f "$HOME/SYOO1-Core/bin/stop-core.sh" && echo "OK   stop-core.sh" || { echo "MISS stop-core.sh"; exit 1; }
test -f "$HOME/SYOO1-Core/bin/check-core.sh" && echo "OK   check-core.sh" || { echo "MISS check-core.sh"; exit 1; }
test -f "$HOME/SYOO1-Core/runtime/start-syoo1-core.sh" && echo "OK   runtime/start-syoo1-core.sh" || { echo "MISS runtime/start-syoo1-core.sh"; exit 1; }

grep -q '/Users/syoo1/SYOO1-Core/runtime/workspace' "$CORE_RUNTIME/.openclaw/openclaw.json" && echo "OK   workspace" || { echo "FAIL workspace"; exit 1; }
grep -q '/Users/syoo1/SYOO1-Core/brain' "$CORE_RUNTIME/workspace/BOOTSTRAP.md" && echo "OK   bootstrap brain" || { echo "FAIL bootstrap brain"; exit 1; }
grep -q 'start-syoo1-core.sh' "$HOME/Library/LaunchAgents/com.syoo1.syoo1-core.plist" && echo "OK   launchagent target" || { echo "FAIL launchagent target"; exit 1; }

echo
echo "=== PASS ==="
