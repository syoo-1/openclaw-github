#!/bin/bash
set -euo pipefail

ROLE="global"
MODE="and"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --role) ROLE="${2:-}"; shift 2 ;;
    --mode) MODE="${2:-}"; shift 2 ;;
    --help|-h)
      echo "用法：router-search-v1.sh [--role pg|core|global] [--mode and|or] 关键词..."
      exit 0 ;;
    --*) echo "未知参数：$1"; exit 1 ;;
    *) break ;;
  esac
done

[[ $# -ge 1 ]] || { echo "缺少关键词"; exit 1; }

TERMS=("$@")
QUERY="${TERMS[*]}"

BRAIN="$HOME/System-Snapshots/03-rebuild-code/tools/brain-search-v3.sh"
MEMORY="$HOME/System-Snapshots/03-rebuild-code/tools/memory-search-v1.sh"

case "$ROLE" in pg|core|global) ;; *) echo "错误：--role 只能是 pg/core/global"; exit 1 ;; esac
case "$MODE" in and|or) ;; *) echo "错误：--mode 只能是 and/or"; exit 1 ;; esac

RULE_RE='协同|闭环|主判|模型|工具|权力|Gemma4|oMLX|GPT|Kimi|fallback|qwen|默认主判|放行|裁定|验收|规则|入口|03|同步|GitHub|System-Snapshots|2:00|3:00|4:00|2点|3点|4点'
MEMORY_RE='当前|主线|阶段|现实|自动触发|长期记忆|历史|以前|上次|当时|停点|下一步|未完成|已确认|CURRENT|CURRENT-STAGE|CURRENT-REALITY'

echo "===== 主脑路由搜索 V1 ====="
echo "role: $ROLE"
echo "mode: $MODE"
echo "terms: $QUERY"
echo

if [[ "$QUERY" =~ $RULE_RE ]]; then
  echo "路由判定：规则 / 入口 / 协同 / 权力结构 / 同步链题"
  echo "调用：brain-search-v3"
  echo
  exec "$BRAIN" --role "$ROLE" --mode "$MODE" "${TERMS[@]}"
fi

if [[ "$QUERY" =~ $MEMORY_RE ]]; then
  echo "路由判定：长期记忆 / 当前主线 / 阶段 / 已确认现实题"
  echo "调用：memory-search-v1"
  echo
  exec "$MEMORY" --mode "$MODE" "${TERMS[@]}"
fi

echo "路由判定：不明确，默认先走长期记忆搜索；若结果不足，再走规则搜索。"
echo "调用：memory-search-v1"
echo
exec "$MEMORY" --mode "$MODE" "${TERMS[@]}"
