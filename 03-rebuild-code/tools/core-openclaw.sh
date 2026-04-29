#!/bin/bash
set -euo pipefail

OPENCLAW_STATE_DIR="$HOME/SYOO1-Core/runtime/.openclaw" \
OPENCLAW_CONFIG_PATH="$HOME/SYOO1-Core/runtime/.openclaw/openclaw.json" \
openclaw "$@"
