#!/bin/bash
set -euo pipefail

echo "=== app ==="
ls -d /Applications/Slack.app 2>/dev/null || true

echo
echo "=== processes ==="
ps aux | grep -i "[S]lack" || true
