#!/bin/bash
set -euo pipefail

SHELL_BASE="$HOME/OpenClaw-MinShell-V1"
BRAIN_PATH_FILE="$SHELL_BASE/brain-link/BRAIN.path"
BRAIN_GITHUB_URL_FILE="$SHELL_BASE/sync-links/brain-github.url"
BRAIN_GITHUB_BRANCH_FILE="$SHELL_BASE/sync-links/brain-github.branch"

if [ ! -f "$BRAIN_PATH_FILE" ]; then
  echo "FAIL: BRAIN.path missing"
  exit 1
fi

BRAIN_ROOT="$(cat "$BRAIN_PATH_FILE")"

echo "=== attach brain v1 ==="
echo "brain root: $BRAIN_ROOT"
echo

if [ -d "$BRAIN_ROOT" ] \
  && [ -f "$BRAIN_ROOT/CURRENT.md" ] \
  && [ -d "$BRAIN_ROOT/identity" ] \
  && [ -d "$BRAIN_ROOT/longterm" ] \
  && [ -d "$BRAIN_ROOT/trigger_handoff" ] \
  && [ -d "$BRAIN_ROOT/recovery" ]; then

  echo "LOCAL_BRAIN_READY=YES"
  echo "ATTACH_MODE=local"
  echo "RESULT=Brain can be attached from local root"
  exit 0
fi

echo "LOCAL_BRAIN_READY=NO"
echo

if [ -f "$BRAIN_GITHUB_URL_FILE" ] && [ -f "$BRAIN_GITHUB_BRANCH_FILE" ]; then
  echo "GITHUB_FALLBACK_READY=YES"
  echo "GITHUB_URL=$(cat "$BRAIN_GITHUB_URL_FILE")"
  echo "GITHUB_BRANCH=$(cat "$BRAIN_GITHUB_BRANCH_FILE")"
  echo "RESULT=Local brain not ready; GitHub fallback should be used next"
  exit 2
fi

echo "GITHUB_FALLBACK_READY=NO"
echo "RESULT=Neither local brain nor GitHub fallback is ready"
exit 3
