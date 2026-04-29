#!/bin/bash
set -euo pipefail

ROLE="global"
MODE="and"
SCOPE="formal"
MAX_FILES=10
MAX_LINES=8

INDEX_FILE="$HOME/System-Snapshots/03-rebuild-code/search/search-index.tsv"

usage() {
  cat <<USAGE
用法：
  brain-search-v3.sh [--role pg|core|global] [--mode and|or] [--scope entry|formal|extended] 关键词1 [关键词2 ...]

例：
  brain-search-v3.sh --role core 前层 降权
  brain-search-v3.sh --role pg 协同 记忆 闭环
  brain-search-v3.sh --role global Kimi Gemma4 GPT-5.4 主判
USAGE
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --role) ROLE="${2:-}"; shift 2 ;;
    --mode) MODE="${2:-}"; shift 2 ;;
    --scope) SCOPE="${2:-}"; shift 2 ;;
    --help|-h) usage ;;
    --*) echo "未知参数：$1"; usage ;;
    *) break ;;
  esac
done

[[ $# -ge 1 ]] || usage
TERMS=("$@")

case "$ROLE" in pg|core|global) ;; *) echo "错误：--role 只能是 pg/core/global"; exit 1 ;; esac
case "$MODE" in and|or) ;; *) echo "错误：--mode 只能是 and/or"; exit 1 ;; esac
case "$SCOPE" in entry|formal|extended) ;; *) echo "错误：--scope 只能是 entry/formal/extended"; exit 1 ;; esac

ROOTS=()
add_root() { [[ -d "$1" ]] && ROOTS+=("$1"); }

if [[ "$ROLE" == "pg" ]]; then
  add_root "$HOME/SYOO1-PG/brain"
  add_root "$HOME/SYOO1-PG/status"
  add_root "$HOME/System-Snapshots/PG/brain"
  add_root "$HOME/System-Snapshots/03-rebuild-code/docs"
elif [[ "$ROLE" == "core" ]]; then
  add_root "$HOME/SYOO1-Core/brain"
  add_root "$HOME/System-Snapshots/02-brain/08-IMPORT-STAGING/FROM-CORE-LIVE"
  add_root "$HOME/System-Snapshots/03-rebuild-code/docs"
else
  add_root "$HOME/System-Snapshots/02-brain"
  add_root "$HOME/System-Snapshots/03-rebuild-code/docs"
  add_root "$HOME/System-Snapshots/PG/brain"
  add_root "$HOME/SYOO1-PG/brain"
  add_root "$HOME/SYOO1-Core/brain"
fi

if [[ "$SCOPE" == "extended" ]]; then
  [[ "$ROLE" == "pg" || "$ROLE" == "global" ]] && add_root "$HOME/SYOO1-PG/runtime/workspace"
  [[ "$ROLE" == "core" || "$ROLE" == "global" ]] && add_root "$HOME/SYOO1-Core/runtime/workspace"
fi

EXCLUDE_RE='/(runtime/\.openclaw/agents/main/sessions|cache|logs|media|tmp|node_modules|\.git|backup|backups|bak|old|archive|thrown|_retired|07-RETIRING|99-DEFERRED|PG-GUARD-SKILLS)/'
ENTRY_RE='/(CURRENT|CURRENT-STAGE|CURRENT-REALITY|BRAIN-ENTRY|IDENTITY|READ-ORDER|README|03-启动总入口|03-当前拼装入口|03-总入口分流读取停止总卡)'

layer_of() {
  local f="$1"
  case "$f" in
    *"/02-brain/00-GOVERNANCE/"*) echo "02-governance" ;;
    *"/02-brain/01-IDENTITY/"*) echo "02-identity" ;;
    *"/02-brain/02-MAINLINE/"*) echo "02-mainline" ;;
    *"/02-brain/03-LONGTERM/"*) echo "02-longterm" ;;
    *"/02-brain/04-COMPILED/"*) echo "02-compiled" ;;
    *"/02-brain/08-IMPORT-STAGING/"*) echo "02-import-staging" ;;
    *"/03-rebuild-code/docs/"*) echo "03-rule" ;;
    *"/System-Snapshots/PG/brain/"*) echo "pg-brain-snapshot" ;;
    *"/SYOO1-PG/brain/"*) echo "pg-brain" ;;
    *"/SYOO1-PG/status/"*) echo "pg-status" ;;
    *"/SYOO1-Core/brain/"*) echo "core-brain" ;;
    *"/runtime/workspace/"*) echo "runtime-workspace-line" ;;
    *) echo "unknown" ;;
  esac
}

norm_path() {
  local f="$1"
  case "$f" in
    "$HOME/System-Snapshots/"*) echo "${f#$HOME/System-Snapshots/}" ;;
    "$HOME/SYOO1-PG/brain/"*) echo "PG/brain/${f#$HOME/SYOO1-PG/brain/}" ;;
    "$HOME/SYOO1-Core/brain/"*) echo "02-brain/08-IMPORT-STAGING/FROM-CORE-LIVE/${f#$HOME/SYOO1-Core/brain/}" ;;
    *) echo "$f" ;;
  esac
}

index_row() {
  local np
  np="$(norm_path "$1")"
  [[ -f "$INDEX_FILE" ]] || return 1
  awk -F '\t' -v p="$np" 'NR>1 && $5==p {print; exit}' "$INDEX_FILE"
}

index_field() {
  local row
  row="$(index_row "$1" || true)"
  [[ -n "$row" ]] && echo "$row" | awk -F '\t' -v n="$2" '{print $n}'
}

priority_of() {
  local f="$1" p
  p="$(index_field "$f" 1 || true)"
  if [[ -n "$p" ]]; then echo "$p"; return; fi

  case "$(layer_of "$f")" in
    03-rule) echo 60 ;;
    02-governance|02-mainline|02-compiled) echo 58 ;;
    pg-brain|core-brain|pg-brain-snapshot|02-import-staging) echo 50 ;;
    runtime-workspace-line) echo 5 ;;
    *) echo 20 ;;
  esac
}

kind_of() {
  local k
  k="$(index_field "$1" 2 || true)"
  [[ -n "$k" ]] && echo "$k" || echo "unindexed"
}

status_of() {
  local st
  st="$(index_field "$1" 3 || true)"
  [[ -n "$st" ]] && echo "$st" || echo "unknown"
}

note_of() {
  local n
  n="$(index_field "$1" 6 || true)"
  [[ -n "$n" ]] && echo "$n" || echo "-"
}

topic_of() {
  local t
  t="$(index_field "$1" 4 || true)"
  [[ -n "$t" ]] && echo "$t" || echo "-"
}

matches_text() {
  local text="$1"
  local ok=0

  if [[ "$MODE" == "and" ]]; then
    ok=1
    for term in "${TERMS[@]}"; do
      if ! grep -qi -- "$term" <<< "$text"; then
        ok=0
        break
      fi
    done
  else
    for term in "${TERMS[@]}"; do
      if grep -qi -- "$term" <<< "$text"; then
        ok=1
        break
      fi
    done
  fi

  [[ "$ok" == "1" ]]
}

TMP=$(mktemp)
MATCH=$(mktemp)
SCORED=$(mktemp)
trap 'rm -f "$TMP" "$MATCH" "$SCORED" "$TMP.entry" 2>/dev/null || true' EXIT

find "${ROOTS[@]}" -type f \( -name '*.md' -o -name '*.txt' \) 2>/dev/null \
  | grep -vE "$EXCLUDE_RE" > "$TMP" || true

if [[ "$SCOPE" == "entry" ]]; then
  grep -Ei "$ENTRY_RE" "$TMP" > "$TMP.entry" || true
  mv "$TMP.entry" "$TMP"
fi

: > "$MATCH"

# A. 先查索引：索引命中可以把文件拉入候选，即使正文没有全部关键词
if [[ -f "$INDEX_FILE" ]]; then
  while IFS=$'\t' read -r priority kind status topic path note; do
    [[ "$priority" == "priority" ]] && continue
    full="$HOME/System-Snapshots/$path"
    text="$topic $path $note"
    if [[ -f "$full" ]] && matches_text "$text"; then
      echo "$full" >> "$MATCH"
    fi
  done < "$INDEX_FILE"
fi

# B. 再查正文
while IFS= read -r f; do
  [[ -f "$f" ]] || continue
  if [[ "$MODE" == "and" ]]; then
    ok=1
    for term in "${TERMS[@]}"; do
      if ! grep -qi -- "$term" "$f" 2>/dev/null; then
        ok=0
        break
      fi
    done
  else
    ok=0
    for term in "${TERMS[@]}"; do
      if grep -qi -- "$term" "$f" 2>/dev/null; then
        ok=1
        break
      fi
    done
  fi
  [[ "$ok" == "1" ]] && echo "$f" >> "$MATCH"
done < "$TMP"

sort -u "$MATCH" -o "$MATCH"
COUNT=$(wc -l < "$MATCH" | tr -d ' ')

echo "===== 主脑搜索 V3 / index + file backend ====="
echo "role: $ROLE"
echo "mode: $MODE"
echo "scope: $SCOPE"
echo "terms: ${TERMS[*]}"
echo "count: $COUNT"
echo

if [[ "$COUNT" == "0" ]]; then
  echo "未找到正式脑依据。"
  echo "建议：减少关键词，或使用 --mode or / --scope extended。"
  exit 0
fi

: > "$SCORED"
while IFS= read -r f; do
  printf "%03d\t%s\n" "$(priority_of "$f")" "$f" >> "$SCORED"
done < "$MATCH"

sort -nr -k1,1 "$SCORED" -o "$SCORED"

shown=0
while IFS=$'\t' read -r score f; do
  shown=$((shown+1))
  kind="$(kind_of "$f")"
  status="$(status_of "$f")"
  note="$(note_of "$f")"
  topic="$(topic_of "$f")"

  echo "候选 $shown"
  echo "优先级：$score"
  echo "类型：$kind"
  echo "状态：$status"
  echo "层级：$(layer_of "$f")"
  echo "文件：$f"
  echo "说明：$note"
  echo "索引主题：$topic"
  echo "命中关键词：${TERMS[*]}"
  echo "关键行："

  for term in "${TERMS[@]}"; do
    grep -ni -- "$term" "$f" 2>/dev/null | head -"$MAX_LINES" || true
  done | awk '!seen[$0]++' | head -"$MAX_LINES"

  case "$kind" in
    current-rule) echo "提示：上位现行规则，优先读取。" ;;
    entry) echo "提示：本地入口锚点，应继续读取其指向的上位规则。" ;;
    test) echo "提示：验收题库 / 测试材料，不得当作上位规则。" ;;
    deprecated) echo "提示：历史旧口径 / 反例，不得当作现行规则。" ;;
    reference) echo "提示：参考或工具验收材料，低于上位规则。" ;;
    *) [[ "$(layer_of "$f")" == "runtime-workspace-line" ]] && echo "提示：运行现场线索，不等于正式主脑依据。" || echo "建议动作：必要时读取该文件相关段落。" ;;
  esac

  echo
  [[ "$shown" -ge "$MAX_FILES" ]] && break
done < "$SCORED"

echo "===== 结束 ====="
echo "只返回候选线索；是否读取全文，由 PG / Core 继续判断。"
