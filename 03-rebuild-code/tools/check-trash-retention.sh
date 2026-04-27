#!/bin/bash
set -euo pipefail

TRASH="$HOME/扔掉"

echo "===== 扔掉 总体规模 ====="
du -sh "$TRASH" 2>/dev/null || { echo "没有 $TRASH"; exit 0; }

echo
echo "===== 一级项目数量 ====="
find "$TRASH" -mindepth 1 -maxdepth 1 2>/dev/null | wc -l

echo
echo "===== 文件总数 ====="
find "$TRASH" -type f 2>/dev/null | wc -l

echo
echo "===== 最大的前 20 个一级项目 ====="
du -sk "$TRASH"/* 2>/dev/null | sort -nr | head -20 | awk '
{
  size=$1; $1=""; path=$0;
  if (size > 1024*1024) printf "%.2f GB%s\n", size/1024/1024, path;
  else if (size > 1024) printf "%.2f MB%s\n", size/1024, path;
  else printf "%d KB%s\n", size, path;
}'

echo
echo "===== 超过 90 天候选：普通退役物 ====="
find "$TRASH" -mindepth 1 -maxdepth 1 -mtime +90 -print 2>/dev/null || true

echo
echo "===== 超过 180 天候选：系统快照 / 事故备份 / 可回滚运行体 ====="
find "$TRASH" -mindepth 1 -maxdepth 1 -mtime +180 -print 2>/dev/null || true

echo
echo "===== 超过 30 天的一级空目录候选 ====="
find "$TRASH" -mindepth 1 -maxdepth 1 -type d -empty -mtime +30 -print 2>/dev/null || true

echo
echo "===== 说明 ====="
echo "本脚本只列候选，不删除任何文件。"
