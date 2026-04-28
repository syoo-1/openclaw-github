# 03 Core 密钥与前层降权修复记录 V1

## 修复背景

Core UI 能打开，但模型调用失败，报错为 Moonshot / OpenAI auth failed。

同时发现 Core 与 PG 的模型主备结构一致，但 Core 缺少 PG 已验证过的前层降权控制项。

## 已确认问题

1. Core 使用旧密钥
   - Core .env.local 中的 MOONSHOT_API_KEY / OPENAI_API_KEY 与 PG 当前有效 key 不一致
   - Core runtime 中 models.json / auth-profiles.json 存在旧认证缓存

2. Core 前层控制不完整
   - 缺少 contextInjection: always
   - 缺少 startupContext.enabled: false
   - 缺少 compaction.memoryFlush.enabled: false
   - 缺少 skills: []

3. Core 启动脚本不如 PG 稳
   - 已由硬 source 改为参照 PG 的安全 source 结构

## 已执行修复

1. 备份 Core 现场到：
   ~/扔掉/core-rebuild-backup-2026-04-28/

2. 修正 Core 启动脚本：
   ~/SYOO1-Core/bin/start-core.sh

3. 补齐 Core openclaw.json 前层降权控制项：
   - contextInjection: always
   - startupContext.enabled: false
   - compaction.memoryFlush.enabled: false
   - skills: []

4. 移走 Core 旧认证缓存：
   - models.json
   - auth-profiles.json

5. 建立通用密钥同步工具：
   ~/System-Snapshots/03-rebuild-code/tools/sync-env-keys.sh

6. 使用 PG 当前有效模型密钥同步到 Core：
   - MOONSHOT_API_KEY
   - OPENAI_API_KEY

## 同步工具边界

sync-env-keys.sh 只同步模型服务密钥。

当前默认同步：
- MOONSHOT_API_KEY
- OPENAI_API_KEY

不纳入：
- TELEGRAM_BOT_TOKEN
- OLLAMA_API_KEY

原因：
- Telegram token 属于通道密钥，不属于模型密钥
- Ollama 后续大概率卸载，本地路线转向 MLX / oMLX

## 修复后验收

Core 重启后：

1. 12289 正常监听
2. com.syoo1.syoo1-core 正常运行
3. Core / PG 模型 key hash 一致
4. Core UI 可正常回答
5. 身份题通过：
   - “我是小一，你是老林，我们是老搭档。”
6. 前层降权题通过：
   - 能说明前层是临时执行壳
   - 能说明前层过重会导致记忆幻觉、身份漂移、主线断裂
   - 能说明后层母脑负责身份、主线和关系连续性

## 当前结论

Core 已从旧密钥认证失败状态恢复。

Core 已参照 PG 补齐关键前层降权控制项。

当前仍需后续继续验收：
1. Core 主脑检索能力
2. Core oMLX 工具调用能力
3. Core Telegram 通道
4. Core 与 PG 分工不串位
