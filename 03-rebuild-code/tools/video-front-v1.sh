#!/bin/zsh
set -euo pipefail

VIDEO=""
MESSAGE=""
TASK_ID="video-front-test"
TO_PG="no"
TIMEOUT=300
WHISPER_MODEL="turbo"
LANGUAGE="Chinese"
FRAME_COUNT=3

usage() {
  cat <<USAGE
用法：
  video-front-v1.sh --video <视频路径> [--message 补充说明] [--task-id ID] [--to-pg yes|no]

作用：
  视频前置承接桥 V1。
  视频 → 抽音频 → Whisper 转写 → 抽关键帧 → oMLX/Gemma4 看图 → 合成视频任务包 → 可选交给 PG/Kimi。

V1：
  处理视频输入。
  不写脑，不自动入库，不自动修改 03。
USAGE
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --video) VIDEO="${2:-}"; shift 2 ;;
    --message) MESSAGE="${2:-}"; shift 2 ;;
    --task-id) TASK_ID="${2:-video-front-test}"; shift 2 ;;
    --to-pg) TO_PG="${2:-no}"; shift 2 ;;
    --timeout) TIMEOUT="${2:-300}"; shift 2 ;;
    --help|-h) usage ;;
    --*) echo "未知参数：$1"; usage ;;
    *) echo "未知输入：$1"; usage ;;
  esac
done

[[ -n "$VIDEO" ]] || { echo "缺少 --video"; exit 1; }
[[ -f "$VIDEO" ]] || { echo "视频不存在：$VIDEO"; exit 1; }

OMLX="$HOME/MLX/oMLX/omlx-tool.sh"
PG="$HOME/System-Snapshots/03-rebuild-code/tools/pg-openclaw.sh"

[[ -x "$OMLX" ]] || { echo "缺少 oMLX 统一入口：$OMLX"; exit 1; }
command -v ffmpeg >/dev/null || { echo "缺少 ffmpeg"; exit 1; }
command -v whisper >/dev/null || { echo "缺少 whisper"; exit 1; }

TMPDIR="$(mktemp -d /tmp/syoo1-video-front.XXXXXX)"
trap 'rm -rf "$TMPDIR"' EXIT

AUDIO="$TMPDIR/audio.wav"
WHISPER_DIR="$TMPDIR/whisper"
FRAME_DIR="$TMPDIR/frames"
mkdir -p "$WHISPER_DIR" "$FRAME_DIR"

echo "===== Video Front V1 ====="
echo "task_id: $TASK_ID"
echo "mode: video"
echo "video: $VIDEO"
echo

echo "===== 1. 抽音频 ====="
ffmpeg -y -i "$VIDEO" -vn -ac 1 -ar 16000 "$AUDIO" >/dev/null 2>&1 || {
  echo "工具失败：ffmpeg 抽音频失败"
  exit 1
}
ls -lh "$AUDIO"

echo
echo "===== 2. Whisper 转写 ====="
/opt/homebrew/bin/whisper "$AUDIO" \
  --model "$WHISPER_MODEL" \
  --language "$LANGUAGE" \
  --task transcribe \
  --output_format txt \
  --output_dir "$WHISPER_DIR" \
  --verbose False >/dev/null

TXT="$(find "$WHISPER_DIR" -maxdepth 1 -type f -name '*.txt' | head -1)"
[[ -n "$TXT" && -f "$TXT" ]] || { echo "Whisper 失败：未生成 txt"; exit 1; }
TRANSCRIPT="$(cat "$TXT")"

echo "$TRANSCRIPT"
echo

echo "===== 3. 抽关键帧 ====="
ffmpeg -y -i "$VIDEO" \
  -vf "fps=1/5,scale=1280:-1" \
  -frames:v "$FRAME_COUNT" \
  "$FRAME_DIR/frame_%02d.png" >/dev/null 2>&1 || {
  echo "工具失败：ffmpeg 抽关键帧失败"
  exit 1
}

find "$FRAME_DIR" -type f -name 'frame_*.png' | sort

echo
echo "===== 4. Gemma4 观察关键帧 ====="
FRAME_OBS=""
i=0
for img in $(find "$FRAME_DIR" -type f -name 'frame_*.png' | sort); do
  i=$((i+1))
  echo "--- frame $i: $img ---"
  obs="$("$OMLX" image "$img" "请用中文简短描述这张视频关键帧。只说画面内容，不解释你的角色。")"
  echo "$obs"
  FRAME_OBS="${FRAME_OBS}

[关键帧 $i]
$obs"
done

[[ -n "$MESSAGE" ]] || MESSAGE="请把这个视频整理成交给 PG/Kimi 主判的任务包。"

echo
echo "===== 5. 合成视频前置任务包 ====="
PROMPT=$(cat <<PROMPT_EOF
你是视频前置整理层。根据下面的音频转写和关键帧观察，直接生成任务包。
禁止说“请补充”。禁止输出模板说明。禁止长篇分析。只输出以下 7 行。

输入类型：video
老林原始意图：$MESSAGE
音频摘要：
画面摘要：
可能需要的动作：
是否建议交给 PG 主判：是
注意事项：

Whisper 音频转写：
$TRANSCRIPT

Gemma4 关键帧观察：
$FRAME_OBS
PROMPT_EOF
)

PACKAGE="$("$OMLX" text "$PROMPT")"

echo "$PACKAGE"

if [[ "$TO_PG" == "yes" ]]; then
  [[ -x "$PG" ]] || { echo "缺少 PG 固定入口：$PG"; exit 1; }

  echo
  echo "===== Dispatch to PG / Kimi ====="

  "$PG" agent \
    --session-id "video-front-to-pg-$TASK_ID" \
    --message "以下是视频前置任务包。请只输出三行。

接包：是/否
类型：
下一步：

===== VIDEO_TASK_PACKAGE_BEGIN =====
$PACKAGE
===== VIDEO_TASK_PACKAGE_END =====" \
    --timeout "$TIMEOUT"
fi
