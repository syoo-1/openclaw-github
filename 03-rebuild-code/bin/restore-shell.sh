#!/bin/bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 /full/path/to/minshell-xxxx.tar.gz"
  exit 1
fi

ARCHIVE="$1"
HOME_DIR="$HOME"

if [ ! -f "$ARCHIVE" ]; then
  echo "Archive not found: $ARCHIVE"
  exit 1
fi

tar -xzf "$ARCHIVE" -C "$HOME_DIR"
echo "Restore completed from:"
echo "$ARCHIVE"
