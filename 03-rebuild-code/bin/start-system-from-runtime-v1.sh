#!/bin/bash
set -euo pipefail

SYSTEM_HOME="${1:-$HOME/SYOO1-Core}"
RUNTIME_DIR="$SYSTEM_HOME/runtime"
PORT="${2:-38789}"

export PATH="/opt/homebrew/opt/node@22/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

if [ -f "$SYSTEM_HOME/.env.local" ]; then
  set -a
  source "$SYSTEM_HOME/.env.local"
  set +a
fi

cd "$RUNTIME_DIR" || exit 1
OPENCLAW_HOME="$PWD" /opt/homebrew/bin/openclaw gateway --allow-unconfigured --port "$PORT"
