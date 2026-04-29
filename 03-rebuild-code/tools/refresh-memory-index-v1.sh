#!/bin/bash
set -euo pipefail

ROOT="$HOME/System-Snapshots"
OUT="$ROOT/03-rebuild-code/search/memory-index.tsv"
TMP="$(mktemp)"

mkdir -p "$ROOT/03-rebuild-code/search"

printf 'priority\tsource\tlayer\tstate\tpath\ttitle\n' > "$TMP"

find \
  "$HOME/SYOO1-Core/brain" \
  "$HOME/SYOO1-PG/brain" \
  "$HOME/System-Snapshots/02-brain" \
  -type f \( -name '*.md' -o -name '*.txt' \) 2>/dev/null \
| grep -Ev '/(runtime|sessions|07-RETIRING|archive|backup|backups|bak|old|thrown|\.git|node_modules|99-DEFERRED|PG-GUARD-SKILLS|08-IMPORT-STAGING|04-COMPILED|05-RAW|06-ADAPTERS|03-LONGTERM/IDENTITY)/' \
| grep -E '(/(02-MAINLINE|03-LONGTERM/MEMORY|00-GOVERNANCE/CURRENT|PROJECT-MEMORY|CURRENT|CURRENT-REALITY|CURRENT-STAGE|STABLE-REALITIES|PREFERENCES|METHODS|PRINCIPLES)/|/(INNER-MEMORY|MEMORY-LAYERS)\.md$)' \
| while IFS= read -r f; do
    title="$(grep -m1 -E '^# ' "$f" 2>/dev/null | sed 's/^# //' || true)"
    [ -z "$title" ] && title="$(basename "$f")"

    case "$f" in
      *"/SYOO1-Core/brain/INNER-MEMORY.md"*) priority=100; source="core-live"; layer="inner-memory"; state="current" ;;
      *"/SYOO1-Core/brain/MEMORY-LAYERS.md"*) priority=98; source="core-live"; layer="memory-layers"; state="current" ;;
      *"/SYOO1-Core/brain/PROJECT-MEMORY/"*) priority=100; source="core-live"; layer="project-memory"; state="current" ;;
      *"/SYOO1-PG/brain/02-MAINLINE/"*) priority=92; source="pg-live"; layer="mainline"; state="current" ;;
      *"/SYOO1-PG/brain/03-LONGTERM/MEMORY/"*) priority=88; source="pg-live"; layer="pg-memory-index"; state="current" ;;
      *"/System-Snapshots/02-brain/00-GOVERNANCE/CURRENT"*) priority=90; source="02-snapshot"; layer="current-governance"; state="current" ;;
      *"/System-Snapshots/02-brain/02-MAINLINE/"*) priority=88; source="02-snapshot"; layer="mainline"; state="current" ;;
      *"/System-Snapshots/02-brain/03-LONGTERM/"*) priority=84; source="02-snapshot"; layer="longterm"; state="current" ;;
      *) priority=50; source="unknown"; layer="unknown"; state="review" ;;
    esac

    printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$priority" "$source" "$layer" "$state" "$f" "$title" >> "$TMP"
  done

mv "$TMP" "$OUT"
