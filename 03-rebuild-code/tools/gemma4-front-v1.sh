#!/bin/zsh
set -euo pipefail

MESSAGE=""
IMAGE=""
MODE="text"
TASK_ID="gemma4-front-test"
TO_PG="no"
TIMEOUT=300

usage() {
  cat <<USAGE
用法：
  gemma4-front-v1.sh --message <老林原始输入> [--task-id ID] [--to-pg yes|no]
  gemma4-front-v1.sh --image <图片路径> --message <补充说明> [--task-id ID] [--to-pg yes|no]

作用：
  oMLX / Gemma4 前置承接桥 V1。
  先让 oMLX Gemma4 承接老林输入，整理成标准任务包。
  默认只输出任务包；--to-pg yes 时再交给 PG/Kimi 主判。

V1：
  处理文字输入。
  处理图片输入。
  暂不处理语音、视频。
  不写脑，不自动入库，不自动修改 03。
USAGE
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --message) MESSAGE="${2:-}"; shift 2 ;;
    --image) IMAGE="${2:-}"; MODE="image"; shift 2 ;;
    --task-id) TASK_ID="${2:-gemma4-front-test}"; shift 2 ;;
    --to-pg) TO_PG="${2:-no}"; shift 2 ;;
    --timeout) TIMEOUT="${2:-300}"; shift 2 ;;
    --help|-h) usage ;;
    --*) echo "未知参数：$1"; usage ;;
    *) echo "未知输入：$1"; usage ;;
  esac
done

if [[ "$MODE" == "text" ]]; then
  [[ -n "$MESSAGE" ]] || { echo "缺少 --message"; exit 1; }
elif [[ "$MODE" == "image" ]]; then
  [[ -n "$IMAGE" ]] || { echo "缺少 --image"; exit 1; }
  [[ -f "$IMAGE" ]] || { echo "图片不存在：$IMAGE"; exit 1; }
  [[ -n "$MESSAGE" ]] || MESSAGE="请先理解这张图片，整理成交给 PG/Kimi 主判的任务包。"
else
  echo "未知模式：$MODE"
  exit 1
fi

OMLX="$HOME/MLX/oMLX/omlx-tool.sh"
PG="$HOME/System-Snapshots/03-rebuild-code/tools/pg-openclaw.sh"

[[ -x "$OMLX" ]] || { echo "缺少 oMLX 统一入口：$OMLX"; exit 1; }

if [[ "$MODE" == "image" ]]; then
  PROMPT=$(cat <<PROMPT_EOF
请直接观察图片内容，并按下面格式输出。不要解释你的角色，不要说等待图片。

【Gemma4 前置任务包】
输入类型：image
老林原始意图：$MESSAGE
关键信息：
图片/材料观察：
可能需要的动作：
是否建议交给 PG 主判：是
是否可能需要 Core 执行：
注意事项：
PROMPT_EOF
)
else
  PROMPT=$(cat <<PROMPT_EOF
你是 Gemma4 前置承接层，不是 PG，不是近一，不是主判。

你的任务：
把老林输入的文字整理成交给 PG/Kimi 主判的标准任务包。

硬规则：
1. 不裁定身份、主权、阶段、达标、放行。
2. 不替 PG 做最终判断。
3. 不展开长篇解释。
4. 只输出下面格式。

【Gemma4 前置任务包】
输入类型：text
老林原始意图：
关键信息：
图片/材料观察：
可能需要的动作：
是否建议交给 PG 主判：是
是否可能需要 Core 执行：
注意事项：

老林补充说明：
$MESSAGE
PROMPT_EOF
)
fi

echo "===== oMLX Gemma4 Front V1 ====="
echo "task_id: $TASK_ID"
echo "mode: $MODE"
echo

if [[ "$MODE" == "image" ]]; then
  PACKAGE="$("$OMLX" image "$IMAGE" "$PROMPT")"
else
  PACKAGE="$("$OMLX" text "$PROMPT")"
fi

echo "$PACKAGE"

if [[ "$TO_PG" == "yes" ]]; then
  [[ -x "$PG" ]] || { echo "缺少 PG 固定入口：$PG"; exit 1; }

  echo
  echo "===== Dispatch to PG / Kimi ====="

  "$PG" agent \
    --session-id "omlx-gemma4-front-to-pg-$TASK_ID" \
    --message "以下是 Gemma4 前置任务包。请先只做短主判，不展开长篇流程。

硬限制：
1. 只确认接包、分类、下一步。
2. 不得进入后层读取。
3. 不得做达标、放行、固化结论。
4. 不得调用 002/03 扫描。
5. 不得扩展分析。
6. 只输出三行：

接包：是/否
类型：
下一步：

===== GEMMA4_TASK_PACKAGE_BEGIN =====
$PACKAGE
===== GEMMA4_TASK_PACKAGE_END =====" \
    --timeout "$TIMEOUT"
fi
