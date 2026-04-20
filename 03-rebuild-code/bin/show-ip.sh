#!/bin/bash
set -euo pipefail
echo "en0: $(ipconfig getifaddr en0 2>/dev/null || true)"
echo "en1: $(ipconfig getifaddr en1 2>/dev/null || true)"
