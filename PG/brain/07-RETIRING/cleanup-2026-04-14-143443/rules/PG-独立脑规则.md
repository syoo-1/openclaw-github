# PG 独立脑规则

## 目标
SYOO1-PG 是与 SYOO1-Core 并列的监管系统。
PG 必须使用自己的独立脑，不再把共享脑作为主来源。

## 主脑位置
PG 主脑固定在：
- `~/SYOO1-PG/brain/identity/`
- `~/SYOO1-PG/brain/memory/`
- `~/SYOO1-PG/brain/reference/`（仅参考）

## 主读取顺序
1. `brain/identity/`
2. `brain/memory/`
3. `brain/reference/`（只参考，不覆盖主人格）

## 明确断开
以下路径不再作为 PG 的主脑来源：
- `~/.openclaw/memory/main.sqlite`
- `~/.openclaw/workspace/`
- `~/.openclaw/workspace-syoo1-core/`

## 允许参考
如需借鉴 Core 或旧共享脑内容，只允许人工挑选后复制进入：
- `~/SYOO1-PG/brain/identity/`
- `~/SYOO1-PG/brain/memory/`
- `~/SYOO1-PG/brain/reference/`

禁止继续直接挂用共享源。

## 原则
- PG 有自己的脑
- PG 不吃共享脑作为主来源
- PG 可参考 Core，但不被 Core 污染
- PG 以后新增记忆，应优先写入自己的脑目录
