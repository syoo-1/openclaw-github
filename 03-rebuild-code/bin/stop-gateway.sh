#!/bin/bash
set -euo pipefail
pkill -f "openclaw gateway --allow-unconfigured --port 18789" || true
pkill -f "node.*18789" || true
