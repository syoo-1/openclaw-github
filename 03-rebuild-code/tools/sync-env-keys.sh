#!/bin/zsh
set -euo pipefail

SRC_ENV="${1:-$HOME/SYOO1-PG/.env.local}"
DST_ENV="${2:-$HOME/SYOO1-Core/.env.local}"

# 默认只同步模型服务密钥。
# 以后新增模型，只在这里追加变量名；不要放 Telegram / Ollama。
KEYS=(
  MOONSHOT_API_KEY
  OPENAI_API_KEY
)

if [[ ! -f "$SRC_ENV" ]]; then
  echo "失败：源 env 不存在：$SRC_ENV"
  exit 1
fi

if [[ ! -f "$DST_ENV" ]]; then
  echo "失败：目标 env 不存在：$DST_ENV"
  exit 1
fi

BACKUP="$DST_ENV.bak.$(date +%Y%m%d-%H%M%S)"
cp -p "$DST_ENV" "$BACKUP"

python3 - "$SRC_ENV" "$DST_ENV" "${KEYS[@]}" <<'PY'
from pathlib import Path
import sys, hashlib

src_path = Path(sys.argv[1])
dst_path = Path(sys.argv[2])
keys = sys.argv[3:]

def read_env(path):
    lines = path.read_text().splitlines()
    data = {}
    for line in lines:
        s = line.strip()
        if not s or s.startswith("#") or "=" not in s:
            continue
        k, v = line.split("=", 1)
        data[k.strip()] = v
    return lines, data

src_lines, src = read_env(src_path)
dst_lines, dst = read_env(dst_path)

for k in keys:
    if k not in src or not src[k].strip():
        raise SystemExit(f"失败：源 env 缺少 {k}")

new_lines = []
seen = set()

for line in dst_lines:
    s = line.strip()
    if s and not s.startswith("#") and "=" in line:
        k = line.split("=", 1)[0].strip()
        if k in keys:
            new_lines.append(f"{k}={src[k]}")
            seen.add(k)
        else:
            new_lines.append(line)
    else:
        new_lines.append(line)

for k in keys:
    if k not in seen:
        new_lines.append(f"{k}={src[k]}")

dst_path.write_text("\n".join(new_lines) + "\n")

_, dst_after = read_env(dst_path)

print("同步完成：不显示密钥，只显示 hash")
for k in keys:
    src_v = src[k].strip().strip('"').strip("'")
    dst_v = dst_after[k].strip().strip('"').strip("'")
    print(k)
    print("  same:", src_v == dst_v)
    print("  hash:", hashlib.sha256(dst_v.encode()).hexdigest()[:16])
PY

echo
echo "已备份目标 env 到：$BACKUP"
