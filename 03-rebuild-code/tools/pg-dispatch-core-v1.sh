#!/bin/bash
set -euo pipefail

TASK_ID=""
MESSAGE=""
TIMEOUT=300

usage() {
  cat <<USAGE
用法：
  pg-dispatch-core-v1.sh --task-id <任务ID> --message <任务内容> [--timeout 秒]

作用：
  通过 Core gateway 后台派发任务给 Core。
  不要求打开 Core UI。
  不写脑，不自动入库，只返回 Core 执行结果。

例：
  pg-dispatch-core-v1.sh --task-id TEST-001 --message "请只回复一句：Core 已收到。"
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

CORE="$HOME/System-Snapshots/03-rebuild-code/tools/core-openclaw.sh"
[[ -x "$CORE" ]] || { echo "缺少 Core 固定入口：$CORE"; exit 1; }

SESSION_ID="pg-to-core-$TASK_ID"

echo "===== PG → Core Dispatch V1 ====="
echo "task_id: $TASK_ID"
echo "session_id: $SESSION_ID"
echo "target: Core gateway"
echo

"$CORE" agent \
  --session-id "$SESSION_ID" \
  --message "$MESSAGE" \
  --timeout "$TIMEOUT"

echo
echo "===== Dispatch Done ====="
echo "Core session: $SESSION_ID"
