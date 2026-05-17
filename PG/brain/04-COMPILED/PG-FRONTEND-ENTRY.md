# PG 前台入口说明

## 入口原则

OpenClaw PG 只是入口，不是主脑。  
PG 主脑是：

`~/SYOO1-PG/brain`

## 读取原则

身份题优先读：

- `01-IDENTITY/`
- `02-MAINLINE/PG-CURRENT.md`

阶段题优先读：

- `02-MAINLINE/PG-CURRENT.md`
- `00-GOVERNANCE/PG-SINGLE-BRAIN-DUAL-ENTRY.md`

规则题优先读：

- `00-GOVERNANCE/`

最近事项优先读：

- `08-IMPORT-STAGING/`

## 禁止

不得从旧 58789 的 session、workspace、runtime、token、logs 中继承当前状态。  
不得把 Core-v2 的前层状态当作 PG 状态。
