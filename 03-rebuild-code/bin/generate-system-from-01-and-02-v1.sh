#!/bin/bash
set -euo pipefail

SYSTEM_NAME="${1:?usage: generate-system-from-01-and-02-v1.sh <SYSTEM_NAME> <SRC_02> [DST_BASE] }"
SRC_02="${2:?usage: generate-system-from-01-and-02-v1.sh <SYSTEM_NAME> <SRC_02> [DST_BASE] }"
DST_BASE="${3:-$HOME}"

SRC_01="$HOME/System-Snapshots/01-shell/runtime-base"
DST_SYSTEM="$DST_BASE/$SYSTEM_NAME"
SYSTEM_SLUG="$(printf '%s' "$SYSTEM_NAME" | tr '[:upper:]' '[:lower:]')"

case "$SYSTEM_NAME" in
  SYOO1-Core) PORT="38789" ;;
  SYOO1-PG)   PORT="58789" ;;
  *)
    echo "FAIL: unsupported SYSTEM_NAME: $SYSTEM_NAME"
    echo "currently supported: SYOO1-Core / SYOO1-PG"
    exit 1
    ;;
esac

echo "=== generate system from 01 and 02 v1 ==="
date
echo
echo "SYSTEM_NAME=$SYSTEM_NAME"
echo "SRC_01=$SRC_01"
echo "SRC_02=$SRC_02"
echo "DST_SYSTEM=$DST_SYSTEM"
echo "PORT=$PORT"
echo

echo "=== step 1: source check ==="
[ -d "$SRC_01" ] || { echo "FAIL: missing 01"; exit 1; }
[ -d "$SRC_02" ] || { echo "FAIL: missing 02"; exit 1; }
[ -f "$SRC_01/openclaw.json" ] || { echo "FAIL: 01 openclaw.json missing"; exit 1; }
[ -f "$SRC_01/.openclaw/openclaw.json" ] || { echo "FAIL: 01 .openclaw/openclaw.json missing"; exit 1; }
[ -d "$SRC_01/workspace" ] || { echo "FAIL: 01 workspace missing"; exit 1; }
[ -f "$SRC_02/README.md" ] || { echo "FAIL: 02 README missing"; exit 1; }
echo "OK"

echo
echo "=== step 2: reset target ==="
rm -rf "$DST_SYSTEM"
mkdir -p "$DST_SYSTEM/runtime"
echo "OK"

echo
echo "=== step 3: copy 01 runtime-base ==="
rsync -a \
  "$SRC_01/.openclaw" \
  "$SRC_01/workspace" \
  "$SRC_01/openclaw.json" \
  "$DST_SYSTEM/runtime/"
echo "OK"

echo
echo "=== step 4: rewrite workspace entry files ==="
cat > "$DST_SYSTEM/runtime/workspace/BOOTSTRAP.md" <<EOF
# BOOTSTRAP.md

你当前进入的是 **$SYSTEM_NAME**。

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
- 当前目标是承接正式 01 / 02 / 03 生成独立系统
- 不继承旧实例运行态
- 不走默认新生引导
- 不把运行态反写回 01 / 02 / 03
- 不把旧测试口、旧施工区、旧运行时口径带入新实例
EOF

cat > "$DST_SYSTEM/runtime/workspace/IDENTITY.md" <<EOF
# IDENTITY.md

当前身份以正式 02 脑母本真源中的身份层为准：

$SRC_02/01-IDENTITY/ASSISTANT_IDENTITY.md
EOF

cat > "$DST_SYSTEM/runtime/workspace/USER.md" <<EOF
# USER.md

当前用户画像以正式 02 脑母本真源中的用户层为准：

$SRC_02/01-IDENTITY/USER_PROFILE.md
EOF

cat > "$DST_SYSTEM/runtime/workspace/SOUL.md" <<EOF
# SOUL.md

当前协作口径以正式 02 脑母本真源为准，优先读取：
1. $SRC_02/README.md
2. $SRC_02/00-GOVERNANCE/CURRENT-STAGE.md
3. $SRC_02/00-GOVERNANCE/CURRENT-REALITY.md
4. $SRC_02/00-GOVERNANCE/VALIDATION-SUMMARY-02.md
5. $SRC_02/01-IDENTITY/ASSISTANT_IDENTITY.md
6. $SRC_02/01-IDENTITY/USER_PROFILE.md

## 当前原则
- 先按正式真源理解自己与用户
- 不把运行态当母本
- 不把旧施工区口径当正式体
- 不把旧测试口残留带入新实例
EOF
echo "OK"

echo
echo "=== step 5: set independent defaults ==="
python3 - <<EOF
from pathlib import Path
import json

files = [
    Path("$DST_SYSTEM/runtime/openclaw.json"),
    Path("$DST_SYSTEM/runtime/.openclaw/openclaw.json"),
]

for p in files:
    data = json.loads(p.read_text())
    if "gateway" in data:
        data["gateway"]["port"] = int("$PORT")
        data["gateway"].setdefault("controlUi", {})
        data["gateway"]["controlUi"]["allowedOrigins"] = [f"http://127.0.0.1:{int('$PORT')}"]
        data["gateway"].setdefault("auth", {})
        data["gateway"]["auth"]["mode"] = "token"
    if str(p).endswith("/runtime/.openclaw/openclaw.json"):
        data.setdefault("agents", {}).setdefault("defaults", {})
        data["agents"]["defaults"]["workspace"] = "$DST_SYSTEM/runtime/workspace"
    p.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n")
EOF
echo "OK"

echo
echo "=== step 6: write post-assembly files ==="
cat > "$DST_SYSTEM/.env.local" <<EOF
export PATH="/opt/homebrew/opt/node@22/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
# export MOONSHOT_API_KEY="..."
# export OPENAI_API_KEY="..."
# export KIMI_API_KEY="..."
EOF
chmod 600 "$DST_SYSTEM/.env.local"

cat > "$DST_SYSTEM/runtime/start-$SYSTEM_SLUG.sh" <<EOF
#!/bin/bash
set -euo pipefail

export OPENCLAW_HOME="$DST_SYSTEM/runtime"
export PATH="/opt/homebrew/opt/node@22/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
[ -f "$DST_SYSTEM/.env.local" ] && source "$DST_SYSTEM/.env.local"

cd "$OPENCLAW_HOME"
exec /opt/homebrew/bin/openclaw gateway --port $PORT
EOF
chmod +x "$DST_SYSTEM/runtime/start-$SYSTEM_SLUG.sh"

cat > "$DST_SYSTEM/POST-ASSEMBLY-SECRETS.md" <<EOF
# POST-ASSEMBLY SECRETS CARD

## 必填环境变量
- MOONSHOT_API_KEY
- OPENAI_API_KEY
- KIMI_API_KEY

## 可选通道/令牌
- TELEGRAM_BOT_TOKEN
- GATEWAY_TOKEN

## 当前实例
- SYSTEM_NAME: $SYSTEM_NAME
- PORT: $PORT
- ENV_FILE: $DST_SYSTEM/.env.local
- START_SCRIPT: $DST_SYSTEM/runtime/start-$SYSTEM_SLUG.sh

## 当前默认模型
- primary: moonshot/kimi-k2.5

## 装配后检查
1. .env.local 已填入真实 key
2. runtime/start-$SYSTEM_SLUG.sh 可执行
3. openclaw.json 中端口为 $PORT
4. workspace 指向实例自身
5. BOOTSTRAP 指向目标脑目录
EOF
echo "OK"

echo
echo "=== step 7: write readme ==="
cat > "$DST_SYSTEM/README.md" <<EOF
# $SYSTEM_NAME

本实例由以下源件生成：

- 01: $SRC_01
- 02: $SRC_02
- 03: $HOME/System-Snapshots/03-rebuild-code

实例角色：
- 独立系统生成结果
- 目标端口：$PORT

生成时间：
$(date)
EOF
echo "OK"

echo
echo "=== result ==="
echo "GENERATED_SYSTEM=$DST_SYSTEM"
