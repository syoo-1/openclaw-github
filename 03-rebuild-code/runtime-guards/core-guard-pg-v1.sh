#!/bin/bash
set -euo pipefail

LOG="$HOME/SYOO1-Core/logs/core-guard-pg.launchd.out.log"
LABEL="com.syoo1.syoo1-pg"
PORT=58789

ts() { date '+%Y-%m-%d %H:%M:%S'; }

pg_ok() {
  lsof -nP -iTCP:$PORT -sTCP:LISTEN >/dev/null 2>&1 || return 1
  return 0
}

mkdir -p "$HOME/SYOO1-Core/logs"

# 无异常静默：PG 正常时不写日志
if pg_ok; then
  exit 0
fi

echo "[$(ts)] PG suspect, wait 8s" >> "$LOG"
sleep 8

if pg_ok; then
  echo "[$(ts)] PG recovered during wait" >> "$LOG"
  exit 0
fi

echo "[$(ts)] PG still suspect, kickstart once" >> "$LOG"
launchctl kickstart -k gui/$(id -u)/$LABEL >> "$LOG" 2>&1 || true

sleep 8

if pg_ok; then
  echo "[$(ts)] PG recovered after kickstart" >> "$LOG"
else
  echo "[$(ts)] PG still failed after one kickstart" >> "$LOG"
fi
