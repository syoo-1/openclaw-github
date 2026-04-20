#!/bin/bash
set -euo pipefail

SRC_01="$HOME/System-Snapshots/01-shell/runtime-base"
SRC_02="$HOME/System-Snapshots/02-brain"
DST_BASE="$HOME"
DST_CORE_NEW="$DST_BASE/CORE核心-SYSTEM.new"

echo "=== generate Core from 01 and 02 v1 ==="
date
echo
echo "SRC_01=$SRC_01"
echo "SRC_02=$SRC_02"
echo "DST_CORE_NEW=$DST_CORE_NEW"
echo

echo "=== step 1: source check ==="
[ -d "$SRC_01" ] || { echo "FAIL: missing 01 runtime-base"; exit 1; }
[ -d "$SRC_02" ] || { echo "FAIL: missing 02"; exit 1; }
[ -f "$SRC_01/openclaw.json" ] || { echo "FAIL: 01 openclaw.json missing"; exit 1; }
[ -d "$SRC_01/.openclaw" ] || { echo "FAIL: 01 .openclaw missing"; exit 1; }
[ -d "$SRC_01/workspace" ] || { echo "FAIL: 01 workspace missing"; exit 1; }
[ -f "$SRC_02/README.md" ] || { echo "FAIL: 02 README missing"; exit 1; }
[ -f "$SRC_02/00-GOVERNANCE/CURRENT-STAGE.md" ] || { echo "FAIL: 02 CURRENT-STAGE missing"; exit 1; }
[ -f "$SRC_02/00-GOVERNANCE/CURRENT-REALITY.md" ] || { echo "FAIL: 02 CURRENT-REALITY missing"; exit 1; }
[ -f "$SRC_02/01-IDENTITY/ASSISTANT_IDENTITY.md" ] || { echo "FAIL: 02 ASSISTANT_IDENTITY missing"; exit 1; }
[ -f "$SRC_02/01-IDENTITY/USER_PROFILE.md" ] || { echo "FAIL: 02 USER_PROFILE missing"; exit 1; }
echo "OK"

echo
echo "=== step 2: reset target ==="
rm -rf "$DST_CORE_NEW"
mkdir -p "$DST_CORE_NEW/runtime"
echo "OK"

echo
echo "=== step 3: copy 01 shell runtime-base ==="
rsync -a \
  "$SRC_01/.openclaw" \
  "$SRC_01/workspace" \
  "$SRC_01/openclaw.json" \
  "$DST_CORE_NEW/runtime/"
echo "OK"

echo
echo "=== step 4: rewrite bootstrap to use promoted 02 ==="
cat > "$DST_CORE_NEW/runtime/workspace/BOOTSTRAP.md" <<EOF
# BOOTSTRAP.md

你当前进入的是 **Core 独立体实例**。

不要走默认身份引导，不要询问“我是谁、你是谁”。

## 当前唯一脑源
$SRC_02

## 先读取
1. $SRC_02/README.md
2. $SRC_02/00-GOVERNANCE/CURRENT-STAGE.md
3. $SRC_02/00-GOVERNANCE/CURRENT-REALITY.md
4. $SRC_02/01-IDENTITY/ASSISTANT_IDENTITY.md
5. $SRC_02/01-IDENTITY/USER_PROFILE.md

## 当前原则
- 当前目标是承接已扶正的正式 02 真源
- 不继承旧 Core 实例运行态
- 不走默认新生引导
- 不把运行态反写回 01 / 02 / 03
EOF
echo "OK"

echo
echo "=== step 5: rewrite workspace entry cards ==="
cat > "$DST_CORE_NEW/runtime/workspace/IDENTITY.md" <<EOF
# IDENTITY.md

当前身份以正式 02 脑母本真源中的身份层为准：

$SRC_02/01-IDENTITY/ASSISTANT_IDENTITY.md
EOF

cat > "$DST_CORE_NEW/runtime/workspace/USER.md" <<EOF
# USER.md

当前用户画像以正式 02 脑母本真源中的用户层为准：

$SRC_02/01-IDENTITY/USER_PROFILE.md
EOF

cat > "$DST_CORE_NEW/runtime/workspace/SOUL.md" <<EOF
# SOUL.md

当前协作口径以正式 02 脑母本真源为准，优先读取：
1. $SRC_02/README.md
2. $SRC_02/00-GOVERNANCE/CURRENT-STAGE.md
3. $SRC_02/00-GOVERNANCE/CURRENT-REALITY.md
4. $SRC_02/00-GOVERNANCE/VALIDATION-SUMMARY-02.md
5. $SRC_02/01-IDENTITY/ASSISTANT_IDENTITY.md
6. $SRC_02/01-IDENTITY/USER_PROFILE.md
EOF
echo "OK"

echo
echo "=== step 6: set Core independent defaults ==="
python3 - <<EOF
from pathlib import Path
import json

files = [
    Path("$DST_CORE_NEW/runtime/openclaw.json"),
    Path("$DST_CORE_NEW/runtime/.openclaw/openclaw.json"),
]

for p in files:
    data = json.loads(p.read_text())
    if "gateway" in data:
        data["gateway"]["port"] = 38789
        data["gateway"].setdefault("controlUi", {})
        data["gateway"]["controlUi"]["allowedOrigins"] = ["http://127.0.0.1:38789"]
    if str(p).endswith("/runtime/.openclaw/openclaw.json"):
        data["agents"]["defaults"]["workspace"] = "$DST_CORE_NEW/runtime/workspace"
    p.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n")
EOF
echo "OK"

echo
echo "=== step 7: write Core readme ==="
cat > "$DST_CORE_NEW/README.md" <<EOF
# CORE核心-SYSTEM.new

本实例由以下源件生成：

- 01: $HOME/System-Snapshots/01-shell
- 02: $SRC_02
- 03: $HOME/System-Snapshots/03-rebuild-code

实例角色：
- Core 待生成体
- 目标端口：38789

生成时间：
$(date)
EOF
echo "OK"

echo
echo "=== result ==="
echo "GENERATED_CORE_NEW=$DST_CORE_NEW"
echo "NEXT: validate CORE核心-SYSTEM.new under the promoted 01/02/03 baseline."
