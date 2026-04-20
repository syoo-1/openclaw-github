#!/bin/bash
set -euo pipefail

BASE="$HOME/OpenClaw-MinShell-V1/bin"

cat <<MENU
OpenClaw MinShell V1 Panel

Core
  $BASE/oc.sh start
  $BASE/oc.sh stop
  $BASE/oc.sh check
  $BASE/restart-gateway.sh
  $BASE/status-all.sh

Config
  $BASE/show-config.sh
  $BASE/save-config-copy.sh
  $BASE/tree-shell.sh

Runtime
  $BASE/show-ip.sh
  $BASE/show-ports.sh
  $BASE/show-openclaw-proc.sh
  $BASE/tail-gateway-log.sh

Snapshot
  $BASE/snapshot-shell.sh
  $BASE/restore-shell.sh /full/path/to/minshell-stage-xxxx.tar.gz
MENU
