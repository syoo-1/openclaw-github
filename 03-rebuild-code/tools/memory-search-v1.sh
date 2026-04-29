#!/bin/bash
set -euo pipefail

MODE="and"
MAX_FILES=8
MAX_LINES=8
INDEX="$HOME/System-Snapshots/03-rebuild-code/search/memory-index.tsv"

usage() {
  cat <<USAGE
用法：
  memory-search-v1.sh [--mode and|or] 关键词1 [关键词2 ...]

说明：
  只搜索 memory-index.tsv 中列入的长期记忆核心文件。
  不默认搜索 archive / 99-DEFERRED / runtime / staging。
USAGE
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode) MODE="${2:-}"; shift 2 ;;
    --help|-h) usage ;;
    --*) echo "未知参数：$1"; usage ;;
    *) break ;;
  esac
done

[[ $# -ge 1 ]] || usage
TERMS=("$@")

case "$MODE" in and|or) ;; *) echo "错误：--mode 只能是 and/or"; exit 1 ;; esac
[[ -f "$INDEX" ]] || { echo "缺少索引：$INDEX"; exit 1; }

RULE_HINT_RE="协同|闭环|主判|模型|工具|权力|Gemma4|oMLX|GPT|Kimi|放行|裁定"
for term in "${TERMS[@]}"; do
  if [[ "$term" =~ $RULE_HINT_RE ]]; then
    echo "===== 主脑记忆搜索 V1 / memory-index backend ====="
    echo "mode: $MODE"
    echo "terms: ${TERMS[*]}"
    echo
    echo "提示：该问题更像规则 / 协同 / 权力结构题，不适合走长期记忆搜索。"
    echo "建议改用："
    echo "$HOME/System-Snapshots/03-rebuild-code/tools/brain-search-v3.sh --role global ${TERMS[*]}"
    exit 0
  fi
done

TMP=$(mktemp)
SCORED=$(mktemp)
trap 'rm -f "$TMP" "$SCORED" 2>/dev/null || true' EXIT

tail -n +2 "$INDEX" | while IFS=$'\t' read -r priority source layer state path title; do
  [[ -f "$path" ]] || continue

  ok=0
  hay="$title"

  if [[ "$MODE" == "and" ]]; then
    ok=1
    for term in "${TERMS[@]}"; do
      if ! grep -qi -- "$term" "$path" 2>/dev/null && ! grep -qi -- "$term" <<< "$hay"; then
        ok=0
        break
      fi
    done
  else
    for term in "${TERMS[@]}"; do
      if grep -qi -- "$term" "$path" 2>/dev/null || grep -qi -- "$term" <<< "$hay"; then
        ok=1
        break
      fi
    done
  fi

  if [[ "$ok" == "1" ]]; then
    printf "%03d\t%s\t%s\t%s\t%s\t%s\n" "$priority" "$source" "$layer" "$state" "$path" "$title"
  fi
done > "$TMP"

COUNT=$(wc -l < "$TMP" | tr -d ' ')

echo "===== 主脑记忆搜索 V1 / memory-index backend ====="
echo "mode: $MODE"
echo "terms: ${TERMS[*]}"
echo "count: $COUNT"
echo

if [[ "$COUNT" == "0" ]]; then
  echo "未在长期记忆核心索引中找到。"
  echo "建议："
  echo "- 减少关键词"
  echo "- 使用 --mode or"
  echo "- 若要查旧材料，再单独查 archive / 99-DEFERRED / runtime"
  exit 0
fi

awk -F '\t' -v terms="${TERMS[*]}" '
{
  score=$1+0
  path=$5
  title=$6

  if (terms ~ /当前|主线|阶段/) {
    if (path ~ /CURRENT\.md$/) score += 30
    if (path ~ /CURRENT-STAGE\.md$/) score += 28
    if (path ~ /CURRENT-REALITY\.md$/) score += 26
    if (path ~ /ACTIVE-THREADS\.md$/) score += 20
    if (path ~ /OPEN-QUESTIONS\.md$/) score += 15
    if (path ~ /MEMORY-LAYERS\.md$/) score -= 25
  }

  printf "%03d\t%s\t%s\t%s\t%s\t%s\n", score, $2, $3, $4, $5, $6
}' "$TMP" | sort -nr -k1,1 > "$SCORED"

shown=0
while IFS=$'\t' read -r priority source layer state path title; do
  shown=$((shown+1))

  echo "候选 $shown"
  echo "优先级：$priority"
  echo "来源：$source"
  echo "层级：$layer"
  echo "状态：$state"
  echo "标题：$title"
  echo "文件：$path"
  echo "关键行："

  for term in "${TERMS[@]}"; do
    grep -ni -- "$term" "$path" 2>/dev/null | head -"$MAX_LINES" || true
  done | awk '!seen[$0]++' | head -"$MAX_LINES"

  echo "建议动作：必要时读取该文件相关段落。"
  echo

  [[ "$shown" -ge "$MAX_FILES" ]] && break
done < "$SCORED"

echo "===== 结束 ====="
