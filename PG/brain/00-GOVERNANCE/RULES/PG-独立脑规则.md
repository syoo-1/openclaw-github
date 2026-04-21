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
- `~/SYOO1-PG/brain/memory/`
- `~/SYOO1-PG/brain/reference/`（仅参考）

## 主读取顺序
1. PG 本体规则优先：`00-GOVERNANCE/` → `02-MAINLINE/` → `03-LONGTERM/IDENTITY/`
2. `brain/memory/`
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
- `~/SYOO1-PG/brain/memory/`
- `~/SYOO1-PG/brain/reference/`

禁止继续直接挂用共享源。

## 原则
- PG 有自己的脑
- PG 不吃共享脑作为主来源
- PG 可参考 Core，但不被 Core 污染
- PG 以后新增记忆，应优先写入自己的脑目录
