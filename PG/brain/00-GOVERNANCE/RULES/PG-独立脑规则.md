## PG/Core 协同记忆闭环入口

凡涉及 PG/Core 协同任务结束、项目记忆闭环、PG 放行后回流 Core 入库、Core 是否保存完整项目记忆等问题时，必须读取：

- `~/System-Snapshots/03-rebuild-code/docs/03-Core-PG主判与外部工具权力结构-V1.md`
- 重点读取：`3-A. 协同任务记忆闭环`

PG 的 `brain/memory/` 仅作为 PG 自身历史连续经历 / 监管摘要，不作为 PG/Core 协同项目完整记忆入口。

---
【PG/Core 协同项目记忆闭环精确入口】
凡涉及 PG/Core 协同任务结束后的项目记忆闭环、Core 入库、PG 放行、03 是否记录等问题，必须优先读取：
- `~/System-Snapshots/03-rebuild-code/docs/03-Core-PG主判与外部工具权力结构-V1.md`
其中“3-A. 协同任务记忆闭环”为现行判尺。

# PG 独立脑规则

## 目标
SYOO1-PG 是与 SYOO1-Core 并列的监管系统。
PG 必须使用自己的独立脑，不再把共享脑作为主来源。

## 主判补强
- 前层不是主脑，只是短记忆与调度台。
- 后层才是 PG 的正式主判断层。
- 若出现冲突，按以下顺序处理：
  1. PG 正式 CURRENT / CURRENT-STAGE / CURRENT-REALITY
  2. PG 正式 GOVERNANCE / RULES / CONTINUITY
  3. PG 正式 MAINLINE
  4. PG 正式 LONGTERM
  5. 其他参考层
  6. 前层短记忆 / 现场临时材料
- 结论：前层与后层冲突，后层优先；临时现场与正式规则冲突，正式规则优先；参考层不得压过正式层。

## 主脑位置
PG 主脑固定在：
- `~/SYOO1-PG/brain/03-LONGTERM/IDENTITY/`
- `~/SYOO1-PG/brain/memory/`（仅 PG 自身历史连续经历 / 监管摘要，不作为 PG/Core 协同项目记忆闭环入口）
- `~/SYOO1-PG/brain/reference/`（仅参考）

## 主读取顺序
1. PG 本体规则优先：`00-GOVERNANCE/` → `02-MAINLINE/` → `03-LONGTERM/IDENTITY/`
2. `brain/memory/`（仅 PG 自身历史连续经历 / 监管摘要，不作为 PG/Core 协同项目记忆闭环入口）
3. `brain/reference/`（只参考，不覆盖主人格）

注：`03-LONGTERM/` 为长期稳定层与上位工艺/追根来源，非前台第一判尺。

## 明确断开
以下路径不再作为 PG 的主脑来源：
- `~/.openclaw/memory/main.sqlite`
- `~/.openclaw/workspace/`
- `~/.openclaw/workspace-syoo1-core/`

## 允许参考
如需借鉴 Core 或旧共享脑内容，只允许人工挑选后复制进入：
- `~/SYOO1-PG/brain/03-LONGTERM/IDENTITY/`
- `~/SYOO1-PG/brain/memory/`（仅 PG 自身历史连续经历 / 监管摘要，不作为 PG/Core 协同项目记忆闭环入口）
- `~/SYOO1-PG/brain/reference/`

禁止继续直接挂用共享源。

## runtime 注入流边界
- `A new session was started via /new or /reset...`
- `Pre-compaction memory flush...`
- `openclaw:bootstrap-context:full`
以上均视为 runtime 会话级注入流。
- runtime 会话级注入流只能作为辅助提示，不得代行 PG 当前正式入口，不得主导身份、主线、边界、失控判定。
- 若 runtime 会话级注入流与 PG 当前前台硬闸、当前现实、正式主判断链冲突，以 PG 正式链为准。
- 若 runtime 会话级注入流导致默认新生壳开场、通用助手口吻、身份漂移、主线丢失、前层越位，默认先进入 `002-PG-03-达标扫描-SKILL-v0.1.md`。

## 原则
- PG 有自己的脑
- PG 不吃共享脑作为主来源
- PG 可参考 Core，但不被 Core 污染
- PG 以后新增自身监管摘要，可写入自己的脑目录；PG/Core 协同项目完整记忆，按 03 上位协同规则回流 Core 入库
