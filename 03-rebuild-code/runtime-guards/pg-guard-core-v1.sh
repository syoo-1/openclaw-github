#!/bin/bash
set -euo pipefail

LOG="$HOME/SYOO1-PG/logs/pg-guard-core.launchd.out.log"
LABEL="com.syoo1.syoo1-core"
PORT=12289

ts() { date '+%Y-%m-%d %H:%M:%S'; }

core_ok() {
  lsof -nP -iTCP:$PORT -sTCP:LISTEN >/dev/null 2>&1 || return 1
  return 0
}

mkdir -p "$HOME/SYOO1-PG/logs"

# 无异常静默：Core 正常时不写日志
if core_ok; then
  exit 0
fi

# 异常才进日志
echo "[$(ts)] Core suspect, wait 8s" >> "$LOG"
sleep 8

if core_ok; then
  echo "[$(ts)] Core recovered during wait" >> "$LOG"
  exit 0
fi

echo "[$(ts)] Core still suspect, kickstart once" >> "$LOG"
launchctl kickstart -k gui/$(id -u)/$LABEL >> "$LOG" 2>&1 || true

sleep 8

if core_ok; then
  echo "[$(ts)] Core recovered after kickstart" >> "$LOG"
else
  echo "[$(ts)] Core still failed after one kickstart" >> "$LOG"
fi
