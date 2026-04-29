#!/bin/bash
set -euo pipefail

TASK_ID=""
MESSAGE=""
TIMEOUT=300

usage() {
  cat <<USAGE
用法：
  core-dispatch-pg-v1.sh --task-id <任务ID> --message <任务内容> [--timeout 秒]

作用：
  通过 PG gateway 后台把摘要 / 回报交给 PG。
  不要求打开 PG UI。
  不写脑，不自动入库，只返回 PG 接收结果。
USAGE
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --task-id) TASK_ID="${2:-}"; shift 2 ;;
    --message) MESSAGE="${2:-}"; shift 2 ;;
    --timeout) TIMEOUT="${2:-300}"; shift 2 ;;
    --help|-h) usage ;;
    --*) echo "未知参数：$1"; usage ;;
    *) echo "未知输入：$1"; usage ;;
  esac
done

[[ -n "$TASK_ID" ]] || { echo "缺少 --task-id"; exit 1; }
[[ -n "$MESSAGE" ]] || { echo "缺少 --message"; exit 1; }

PG="$HOME/System-Snapshots/03-rebuild-code/tools/pg-openclaw.sh"
[[ -x "$PG" ]] || { echo "缺少 PG 固定入口：$PG"; exit 1; }

SESSION_ID="core-to-pg-$TASK_ID"

echo "===== Core → PG Dispatch V1 ====="
echo "task_id: $TASK_ID"
echo "session_id: $SESSION_ID"
echo "target: PG gateway"
echo

"$PG" agent \
  --session-id "$SESSION_ID" \
  --message "$MESSAGE" \
  --timeout "$TIMEOUT"

echo
echo "===== Dispatch Done ====="
echo "PG session: $SESSION_ID"
