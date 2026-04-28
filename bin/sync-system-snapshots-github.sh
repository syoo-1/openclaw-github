#!/bin/bash
set -euo pipefail

ROOT="$HOME/System-Snapshots"
LOG="/tmp/syoo1-system-snapshots-github-sync.log"

{
  echo "[$(date '+%F %T')] ===== System-Snapshots github sync start ====="

  cd "$ROOT"

  branch="$(git branch --show-current || true)"
  if [[ "$branch" != "main" ]]; then
    echo "[$(date '+%F %T')] STOP: branch is '$branch', not main"
    exit 0
  fi

  if [[ -n "$(git status --porcelain)" ]]; then
    git add .
    git commit -m "自动同步：System-Snapshots 整仓更新 $(date '+%F %T')" || true
  else
    echo "[$(date '+%F %T')] no changes"
  fi

  git push origin main
  echo "[$(date '+%F %T')] github sync ok"
} >> "$LOG" 2>&1
