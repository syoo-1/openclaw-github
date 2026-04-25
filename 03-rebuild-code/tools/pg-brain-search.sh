#!/bin/bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "用法：pg-brain-search.sh 关键词1 [关键词2 ...]"
  echo "例：pg-brain-search.sh 老林"
  echo "例：pg-brain-search.sh workspace"
  echo "例：pg-brain-search.sh 前层 降权"
  exit 1
fi

TERMS=("$@")

ROOTS=(
  "$HOME/SYOO1-PG/brain"
  "$HOME/SYOO1-PG/status"
  "$HOME/System-Snapshots/03-rebuild-code/docs"
)

EXCLUDE_RE='/(07-RETIRING|archive|backup|backups|bak|old|thrown|99-DEFERRED|node_modules|\.git)/'

echo "===== PG 主脑检索 V1.1 ====="
echo "关键词：${TERMS[*]}"
echo "模式：多关键词 AND；文件必须同时包含全部关键词"
echo "范围：PG brain / PG status / 03 docs"
echo "排除：RETIRING、archive、backup、old、thrown、99-DEFERRED、.git"
echo

TMP=$(mktemp)
trap 'rm -f "$TMP"' EXIT

find "${ROOTS[@]}" -type f \( -name '*.md' -o -name '*.txt' \) 2>/dev/null | \
  grep -vE "$EXCLUDE_RE" > "$TMP"

for term in "${TERMS[@]}"; do
  NEXT=$(mktemp)
  while IFS= read -r f; do
    if grep -qi -- "$term" "$f" 2>/dev/null; then
      echo "$f" >> "$NEXT"
    fi
  done < "$TMP"
  mv "$NEXT" "$TMP"
done

COUNT=$(wc -l < "$TMP" | tr -d ' ')
echo "候选文件数：$COUNT"
echo

if [ "$COUNT" = "0" ]; then
  echo "未找到同时包含全部关键词的正式脑文件。"
  echo "建议：减少关键词，或改用单关键词查。"
  exit 0
fi

shown=0
while IFS= read -r f; do
  echo "===== $f ====="
  for term in "${TERMS[@]}"; do
    grep -ni -- "$term" "$f" 2>/dev/null | head -8 || true
  done | awk '!seen[$0]++' | head -20
  echo
  shown=$((shown+1))
  [ "$shown" -ge 20 ] && break
done < "$TMP"

echo "===== 结束 ====="
echo "只返回候选线索；是否读取全文，由近一继续判断。"
