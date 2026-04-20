#!/bin/bash
set -euo pipefail
lsof -nP -iTCP:18789 -sTCP:LISTEN || true
echo
lsof -nP -iTCP:18791 -sTCP:LISTEN || true
