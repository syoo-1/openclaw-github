#!/bin/bash
export PATH="/opt/homebrew/opt/node@22/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
set -a
source "$HOME/SYOO1-Core/.env.local"
set +a
cd "${1:-$HOME/SYOO1-Core/runtime}" || exit 1
PORT="${2:-38789}"
OPENCLAW_HOME="$PWD" /opt/homebrew/bin/openclaw gateway --allow-unconfigured --port "$PORT"
