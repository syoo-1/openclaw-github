#!/bin/bash
set -euo pipefail

ROLE="global"
MODE="and"
SCOPE="formal"
MAX_FILES=20
MAX_LINES=8

usage() {
  cat <<USAGE
用法：
  brain-search.sh [--role pg|core|global] [--mode and|or] [--scope entry|formal|extended] 关键词1 [关键词2 ...]

例：
  brain-search.sh --role core 前层 降权
  brain-search.sh --role pg 老林
  brain-search.sh --role global --scope entry 当前 阶段
USAGE
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --role)
      ROLE="${2:-}"; shift 2 ;;
    --mode)
      MODE="${2:-}"; shift 2 ;;
    --scope)
      SCOPE="${2:-}"; shift 2 ;;
    --help|-h)
      usage ;;
    --*)
      echo "未知参数：$1"; usage ;;
    *)
      break ;;
  esac
done

[[ $# -ge 1 ]] || usage
TERMS=("$@")

case "$ROLE" in pg|core|global) ;; *) echo "错误：--role 只能是 pg/core/global"; exit 1 ;; esac
case "$MODE" in and|or) ;; *) echo "错误：--mode 只能是 and/or"; exit 1 ;; esac
case "$SCOPE" in entry|formal|extended) ;; *) echo "错误：--scope 只能是 entry/formal/extended"; exit 1 ;; esac

ROOTS=()

add_root() {
  [[ -d "$1" ]] && ROOTS+=("$1")
}

if [[ "$ROLE" == "pg" ]]; then
  add_root "$HOME/SYOO1-PG/brain"
  add_root "$HOME/SYOO1-PG/status"
  add_root "$HOME/System-Snapshots/03-rebuild-code/docs"
elif [[ "$ROLE" == "core" ]]; then
  add_root "$HOME/SYOO1-Core/brain"
  add_root "$HOME/System-Snapshots/02-brain"
  add_root "$HOME/System-Snapshots/03-rebuild-code/docs"
else
  add_root "$HOME/System-Snapshots/02-brain"
  add_root "$HOME/System-Snapshots/03-rebuild-code/docs"
  add_root "$HOME/System-Snapshots/PG/brain"
  add_root "$HOME/SYOO1-PG/brain"
  add_root "$HOME/SYOO1-Core/brain"
fi

if [[ "$SCOPE" == "extended" ]]; then
  if [[ "$ROLE" == "pg" || "$ROLE" == "global" ]]; then
    add_root "$HOME/SYOO1-PG/runtime/workspace"
    add_root "$HOME/SYOO1-PG/status"
  fi
  if [[ "$ROLE" == "core" || "$ROLE" == "global" ]]; then
    add_root "$HOME/SYOO1-Core/runtime/workspace"
  fi
fi

EXCLUDE_RE='/(runtime/\.openclaw/agents/main/sessions|cache|logs|media|tmp|node_modules|\.git|backup|backups|bak|old|archive|thrown|_retired|07-RETIRING|99-DEFERRED|08-IMPORT-STAGING|PG-GUARD-SKILLS)/'
ENTRY_RE='/(CURRENT|CURRENT-STAGE|CURRENT-REALITY|BRAIN-ENTRY|IDENTITY|READ-ORDER|README|03-启动总入口|03-当前拼装入口|03-总入口分流读取停止总卡)'

layer_of() {
  local f="$1"
  case "$f" in
    *"/02-brain/README.txt"*) echo "02-root" ;;
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

TMP=$(mktemp)
MATCH=$(mktemp)
trap 'rm -f "$TMP" "$MATCH" "$TMP.entry" 2>/dev/null || true' EXIT

find "${ROOTS[@]}" -type f \( -name '*.md' -o -name '*.txt' \) 2>/dev/null \
  | grep -vE "$EXCLUDE_RE" > "$TMP" || true

if [[ "$SCOPE" == "entry" ]]; then
  grep -Ei "$ENTRY_RE" "$TMP" > "$TMP.entry" || true
  mv "$TMP.entry" "$TMP"
fi

: > "$MATCH"

while IFS= read -r f; do
  [[ -f "$f" ]] || continue

  ok=0
  if [[ "$MODE" == "and" ]]; then
    ok=1
    for term in "${TERMS[@]}"; do
      if ! grep -qi -- "$term" "$f" 2>/dev/null; then
        ok=0
        break
      fi
    done
  else
    for term in "${TERMS[@]}"; do
      if grep -qi -- "$term" "$f" 2>/dev/null; then
        ok=1
        break
      fi
    done
  fi

  [[ "$ok" == "1" ]] && echo "$f" >> "$MATCH"
done < "$TMP"

COUNT=$(wc -l < "$MATCH" | tr -d ' ')

echo "===== 主脑搜索 V2 / file backend ====="
echo "role: $ROLE"
echo "mode: $MODE"
echo "scope: $SCOPE"
echo "terms: ${TERMS[*]}"
echo "count: $COUNT"
echo

if [[ "$COUNT" == "0" ]]; then
  if [[ "$SCOPE" == "extended" ]]; then
    echo "未找到正式脑或运行现场线索。"
  else
    echo "未找到正式脑依据。"
    echo "建议：减少关键词，或使用 --scope extended 查运行现场线索。"
  fi
  exit 0
fi

shown=0
while IFS= read -r f; do
  shown=$((shown+1))
  echo "候选 $shown"
  echo "层级：$(layer_of "$f")"
  echo "文件：$f"
  echo "命中关键词：${TERMS[*]}"
  echo "关键行："

  for term in "${TERMS[@]}"; do
    grep -ni -- "$term" "$f" 2>/dev/null | head -"$MAX_LINES" || true
  done | awk '!seen[$0]++' | head -"$MAX_LINES"

  if [[ "$(layer_of "$f")" == "runtime-workspace-line" ]]; then
    echo "提示：运行现场线索，不等于正式主脑依据。"
  else
    echo "建议动作：必要时读取该文件相关段落。"
  fi

  echo
  [[ "$shown" -ge "$MAX_FILES" ]] && break
done < "$MATCH"

echo "===== 结束 ====="
echo "只返回候选线索；是否读取全文，由 PG / Core 继续判断。"
