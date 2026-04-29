#!/bin/bash
set -euo pipefail

OPENCLAW_STATE_DIR="$HOME/SYOO1-PG/runtime/.openclaw" \
OPENCLAW_CONFIG_PATH="$HOME/SYOO1-PG/runtime/.openclaw/openclaw.json" \
openclaw "$@"
