#!/bin/bash
set -euo pipefail
ps aux | grep openclaw | grep -v grep || true
echo
ps aux | grep 'node.*18789' | grep -v grep || true
