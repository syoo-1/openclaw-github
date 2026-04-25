#!/bin/bash
set -euo pipefail

LLAMA="$HOME/LLM-Shell/llama.cpp/build/bin/llama-cli"
MODEL="$HOME/LLM-Shell/models/gemma4-e4b-it-q4_k_m.gguf"

if [ $# -lt 1 ]; then
  echo "用法：pg-call-gemma4.sh 任务内容"
  exit 1
fi

TASK="$*"

SYS="你是 PG 系统的外部能力模型 Gemma4。

硬规则：
1. 你不是近一。
2. 你不是主脑。
3. 你不是裁判。
4. 你不判断身份、关系、主权、阶段、达标、放行。
5. 你只完成交给你的具体任务。
6. 最终输出只给答案。
7. 不输出 thinking、analysis、思考过程、推理过程。
8. 如果任务涉及主权、身份、关系、系统边界，必须提醒交回 Kimi / 近一裁定。
9. 中文输出，短、清楚、可执行。"

"$LLAMA" \
  -m "$MODEL" \
  -ngl 99 \
  -c 4096 \
  -n 512 \
  --temp 0.3 \
  --top-p 0.9 \
  --no-display-prompt \
  -st \
  -rea off \
  -sys "$SYS" \
  -p "$TASK" 2>/tmp/pg-gemma4.err | \
awk '
  /\[Start thinking\]/ {skip=1; next}
  /\[End thinking\]/ {skip=0; next}
  /^Loading model/ {next}
  /^available commands:/ {next}
  /^▄▄/ {next}
  /^██/ {next}
  /^build[[:space:]]*:/ {next}
  /^model[[:space:]]*:/ {next}
  /^modalities[[:space:]]*:/ {next}
  /^\[ Prompt:/ {next}
  /^> / {next}
  skip==0 {print}
'
