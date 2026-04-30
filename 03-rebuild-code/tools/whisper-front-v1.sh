#!/bin/zsh
set -euo pipefail

AUDIO=""
MESSAGE=""
TASK_ID="whisper-front-test"
TO_PG="no"
TIMEOUT=300
MODEL="turbo"
LANGUAGE="Chinese"

usage() {
  cat <<USAGE
用法：
  whisper-front-v1.sh --audio <音频路径> [--message 补充说明] [--task-id ID] [--to-pg yes|no]

作用：
  语音前置承接桥 V1。
  音频 → Whisper 转文字 → oMLX/Gemma4 整理任务包 → 可选交给 PG/Kimi。

V1：
  处理音频输入。
  不写脑，不自动入库，不自动修改 03。
USAGE
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --audio) AUDIO="${2:-}"; shift 2 ;;
    --message) MESSAGE="${2:-}"; shift 2 ;;
    --task-id) TASK_ID="${2:-whisper-front-test}"; shift 2 ;;
    --to-pg) TO_PG="${2:-no}"; shift 2 ;;
    --timeout) TIMEOUT="${2:-300}"; shift 2 ;;
    --model) MODEL="${2:-turbo}"; shift 2 ;;
    --language) LANGUAGE="${2:-Chinese}"; shift 2 ;;
    --help|-h) usage ;;
    --*) echo "未知参数：$1"; usage ;;
    *) echo "未知输入：$1"; usage ;;
  esac
done

[[ -n "$AUDIO" ]] || { echo "缺少 --audio"; exit 1; }
[[ -f "$AUDIO" ]] || { echo "音频不存在：$AUDIO"; exit 1; }

OMLX="$HOME/MLX/oMLX/omlx-tool.sh"
PG="$HOME/System-Snapshots/03-rebuild-code/tools/pg-openclaw.sh"

[[ -x "$OMLX" ]] || { echo "缺少 oMLX 统一入口：$OMLX"; exit 1; }

TMPDIR="$(mktemp -d /tmp/syoo1-whisper-front.XXXXXX)"
trap 'rm -rf "$TMPDIR"' EXIT

echo "===== Whisper Front V1 ====="
echo "task_id: $TASK_ID"
echo "mode: audio"
echo "audio: $AUDIO"
echo

/opt/homebrew/bin/whisper "$AUDIO" \
  --model "$MODEL" \
  --language "$LANGUAGE" \
  --task transcribe \
  --output_format txt \
  --output_dir "$TMPDIR" \
  --verbose False >/dev/null

TXT="$(find "$TMPDIR" -maxdepth 1 -type f -name '*.txt' | head -1)"
[[ -n "$TXT" && -f "$TXT" ]] || { echo "Whisper 失败：未生成 txt"; exit 1; }

TRANSCRIPT="$(cat "$TXT")"

echo "===== Whisper 转写 ====="
echo "$TRANSCRIPT"
echo

[[ -n "$MESSAGE" ]] || MESSAGE="请把这段语音转写内容整理成交给 PG/Kimi 主判的任务包。"

PROMPT=$(cat <<PROMPT_EOF
请根据 Whisper 转写文本，整理成交给 PG/Kimi 主判的前置任务包。
不要解释你的角色，不要做最终裁定。

【Gemma4 前置任务包】
输入类型：audio
老林原始意图：$MESSAGE
关键信息：
语音转写摘要：
可能需要的动作：
是否建议交给 PG 主判：是
是否可能需要 Core 执行：
注意事项：

Whisper 转写文本：
$TRANSCRIPT
PROMPT_EOF
)

PACKAGE="$("$OMLX" text "$PROMPT")"

echo "===== Gemma4 前置任务包 ====="
echo "$PACKAGE"

if [[ "$TO_PG" == "yes" ]]; then
  [[ -x "$PG" ]] || { echo "缺少 PG 固定入口：$PG"; exit 1; }

  echo
  echo "===== Dispatch to PG / Kimi ====="

  "$PG" agent \
    --session-id "whisper-front-to-pg-$TASK_ID" \
    --message "以下是 Whisper + Gemma4 前置任务包。请只输出三行。

接包：是/否
类型：
下一步：

===== AUDIO_TASK_PACKAGE_BEGIN =====
$PACKAGE
===== AUDIO_TASK_PACKAGE_END =====" \
    --timeout "$TIMEOUT"
fi
