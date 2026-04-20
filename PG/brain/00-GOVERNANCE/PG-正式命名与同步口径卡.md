# PG-正式命名与同步口径卡

## 正式现实
- PG 现役运行脑：`~/SYOO1-PG/brain`
- PG 本机同步仓：`~/System-Snapshots/PG/brain`
- PG 远端分支：`pg-brain`

## 正式同步链
- 每天凌晨 3:00
- 顺序：`~/SYOO1-PG/brain` -> `~/System-Snapshots/PG/brain` -> `origin pg-brain`

## 正式分层位置
- `00-GOVERNANCE`：治理规则、连续性规则、命名口径
- `02-MAINLINE`：当前监管主线、当前现实
- `03-LONGTERM`：长期身份、长期记忆索引
- `07-RETIRING`：已退下的旧位、旧规则、旧目录
- `08-IMPORT-STAGING`：待筛选导入层
- `99-DEFERRED`：延后处理层

## 已过期旧叫法
- 把旧 `brain/continuity` 继续当正式位：过期
- 把旧 `brain/rules` 继续当正式位：过期
- 把旧 `brain/identity` 继续当正式位：过期
- 把旧 `brain/status` 继续当正式位：过期
- 把 `handoff` / `trigger_handoff` 当正式主权来源：过期

## 当前要求
- 后续文档、脚本、说明，一律以上述正式口径为准
- 发现旧叫法，直接改或移入 `07-RETIRING`
