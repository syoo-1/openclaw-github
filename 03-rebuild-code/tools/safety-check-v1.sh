#!/bin/bash
set -u

FAIL=0
WARN=0

ok() { echo "✅ $1"; }
bad() { echo "❌ $1"; FAIL=$((FAIL+1)); }
warn() { echo "⚠️  $1"; WARN=$((WARN+1)); }

echo "===== SYOO1 Safety Check V1 ====="
date '+%Y-%m-%d %H:%M:%S'
echo

echo "===== 1. 端口检查 ====="
if lsof -nP -iTCP:12289 -sTCP:LISTEN >/dev/null 2>&1; then
  ok "Core 12289 正在监听"
else
  bad "Core 12289 未监听"
fi

if lsof -nP -iTCP:58789 -sTCP:LISTEN >/dev/null 2>&1; then
  ok "PG 58789 正在监听"
else
  bad "PG 58789 未监听"
fi

echo
echo "===== 2. LaunchAgent 检查 ====="
for label in \
  com.syoo1.syoo1-core \
  com.syoo1.syoo1-pg \
  com.syoo1.pg-guard-core \
  com.syoo1.sync-core-brain-to-02 \
  com.syoo1.sync-pg-full-chain \
  com.syoo1.sync-system-snapshots-github
do
  if launchctl list | grep -q "$label"; then
    ok "$label 已加载"
  else
    bad "$label 未加载"
  fi
done

echo
echo "===== 3. 旧残留检查 ====="
if [ -f "$HOME/Library/LaunchAgents/com.syoo1.watch-pg-v1.plist" ]; then
  bad "旧 watch-pg-v1 plist 仍在 LaunchAgents"
else
  ok "旧 watch-pg-v1 已不在 LaunchAgents"
fi

if grep -Rni "SYOO1-SYNC" "$HOME/Library/LaunchAgents" 2>/dev/null | grep -q .; then
  bad "LaunchAgents 仍有 SYOO1-SYNC 引用"
else
  ok "LaunchAgents 无 SYOO1-SYNC 引用"
fi

echo
echo "===== 4. 搜索体系检查 ====="
for f in \
  "$HOME/System-Snapshots/03-rebuild-code/tools/router-search-v1.sh" \
  "$HOME/System-Snapshots/03-rebuild-code/tools/brain-search-v3.sh" \
  "$HOME/System-Snapshots/03-rebuild-code/tools/memory-search-v1.sh" \
  "$HOME/System-Snapshots/03-rebuild-code/tools/refresh-memory-index-v1.sh" \
  "$HOME/System-Snapshots/03-rebuild-code/search/search-index.tsv" \
  "$HOME/System-Snapshots/03-rebuild-code/search/memory-index.tsv"
do
  if [ -e "$f" ]; then
    ok "存在：$f"
  else
    bad "缺失：$f"
  fi
done

echo
echo "===== 5. 搜索路由冒烟测试 ====="

if "$HOME/System-Snapshots/03-rebuild-code/tools/router-search-v1.sh" --role global 协同 记忆 闭环 Core PG 2>/dev/null \
  | grep -q "调用：brain-search-v3"; then
  ok "协同闭环题正确路由到 brain-search-v3"
else
  bad "协同闭环题未正确路由到 brain-search-v3"
fi

if "$HOME/System-Snapshots/03-rebuild-code/tools/router-search-v1.sh" 当前 主线 2>/dev/null \
  | grep -q "调用：memory-search-v1"; then
  ok "当前主线题正确路由到 memory-search-v1"
else
  bad "当前主线题未正确路由到 memory-search-v1"
fi

if "$HOME/System-Snapshots/03-rebuild-code/tools/memory-search-v1.sh" PG 自动触发 2>/dev/null \
  | grep -q "PG 自动触发当前现实"; then
  ok "长期记忆搜索可命中 PG CURRENT-REALITY"
else
  bad "长期记忆搜索未命中 PG CURRENT-REALITY"
fi

echo
echo "===== 6. Git 状态检查 ====="
cd "$HOME/System-Snapshots" || exit 1

branch="$(git branch --show-current 2>/dev/null || true)"
if [ "$branch" = "main" ]; then
  ok "System-Snapshots 当前分支为 main"
else
  bad "System-Snapshots 当前分支不是 main：$branch"
fi

if git status --short | grep -q .; then
  warn "System-Snapshots 有未提交变更"
  git status --short
else
  ok "System-Snapshots 工作区干净"
fi

echo
echo "===== 总结 ====="
echo "FAIL=$FAIL"
echo "WARN=$WARN"

if [ "$FAIL" -eq 0 ]; then
  if [ "$WARN" -eq 0 ]; then
    echo "结论：通过。当前系统处于绿色状态。"
    exit 0
  else
    echo "结论：基本通过。有警告，需要人工确认。"
    exit 0
  fi
else
  echo "结论：不通过。存在硬故障，不建议继续执行恢复以外的主线。"
  exit 1
fi
