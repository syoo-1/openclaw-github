# 03 Core 密钥与前层降权修复记录 V1

## 定位

本卡是历史修复记录，不是当前规则入口。

当前判断以以下入口为准：

- 前层降权：`00-前层降权固定验收题.md`
- 读取 / 分流：`03-总入口分流读取停止总卡-V1.md`
- 当前端口 / 现实：`02-brain/00-GOVERNANCE/UI-INSTANCE-REALITY-01.md`
- 最终收口：`00-最终七件套收口验收卡.md`

---

## 一、当时问题

当时 Core UI 能打开，但模型调用失败，报 Moonshot / OpenAI auth failed。

同时确认：

1. Core 使用旧模型密钥。
2. Core runtime 中存在旧认证缓存。
3. Core 前层降权控制项不完整。
4. Core 启动脚本不如 PG 稳。

---

## 二、当时修复

已执行：

1. 备份 Core 现场到：
   `~/扔掉/core-rebuild-backup-2026-04-28/`

2. 修正 Core 启动脚本：
   `~/SYOO1-Core/bin/start-core.sh`

3. 补齐 Core openclaw.json 前层降权控制项。

4. 移走旧认证缓存：
   - `models.json`
   - `auth-profiles.json`

5. 建立模型密钥同步工具：
   `~/System-Snapshots/03-rebuild-code/tools/sync-env-keys.sh`

---

## 三、密钥同步边界

`sync-env-keys.sh` 只同步模型服务密钥：

- `MOONSHOT_API_KEY`
- `OPENAI_API_KEY`

不纳入：

- `TELEGRAM_BOT_TOKEN`
- `OLLAMA_API_KEY`

原因：

- Telegram 是通道密钥。
- Ollama / 本地模型路线不应混入云模型密钥同步工具。

---

## 四、当时验收

当时修复后确认：

1. Core `12289` 正常监听。
2. `com.syoo1.syoo1-core` 正常运行。
3. Core / PG 模型 key hash 一致。
4. Core UI 可正常回答。
5. 身份题通过。
6. 前层降权题通过。

---

## 五、当前结论

本卡只保留历史修复事实。

不得从本卡反向定义当前状态、当前尾巴、当前端口或当前验收结论。

当前状态以最新正式入口和验收卡为准。
