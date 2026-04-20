#!/bin/bash
set -euo pipefail
echo "=== openclaw ==="
openclaw --version
echo
echo "=== port 18789 ==="
lsof -nP -iTCP:18789 -sTCP:LISTEN || true
echo
echo "=== port 18791 ==="
lsof -nP -iTCP:18791 -sTCP:LISTEN || true
echo
echo "=== urls ==="
echo "Dashboard: http://127.0.0.1:18789/"
echo "Canvas:    http://127.0.0.1:18789/__openclaw__/canvas/"
echo "Browser:   http://127.0.0.1:18791/"
