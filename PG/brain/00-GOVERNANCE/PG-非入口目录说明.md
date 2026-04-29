# PG 非入口目录说明

## 定位

本卡用于防止后续 PG / Core / 助手把 PG 脑内的退役区、暂存区、延迟区误当成当前正式入口。

本卡不是新规则总纲，只是读取边界说明。

---

## 一、当前正式入口

判断 PG 当前现实、身份、读取顺序、监管规则时，优先读取：

- `PG/brain/README.md`
- `PG/brain/READ-ORDER.md`
- `PG/brain/02-MAINLINE/CURRENT-REALITY.md`
- `PG/brain/02-MAINLINE/CURRENT.md`
- `PG/brain/03-LONGTERM/IDENTITY/PG-IDENTITY.md`
- `PG/brain/03-LONGTERM/IDENTITY/USER.md`
- `PG/brain/00-GOVERNANCE/RULES/PG-独立脑规则.md`
- `PG/brain/00-GOVERNANCE/PG-分层治理总卡.md`

如涉及 PG/Core 协同、模型位、外部工具、Gemma4 / oMLX、横向流与纵向能力流，应回到：

- `03-rebuild-code/docs/03-Core-PG主判与外部工具权力结构-V1.md`

---

## 二、07-RETIRING

`07-RETIRING/` 是退役区，不是当前正式入口。

用途：

- 保存旧身份、旧规则、旧状态、旧参考材料
- 作为历史来源与回查材料
- 防止旧材料混在当前有效区

禁止：

- 不得把其中的 `PG-IDENTITY.md`、`USER.md`、`IDENTITY.md` 当成当前身份入口
- 不得把其中的 `CURRENT.md`、`CURRENT-REALITY.md`、`PG-AUTO-TRIGGER-CURRENT-REALITY.md` 当成当前现实入口
- 不得把其中旧端口、旧模型、旧路径原样恢复
- 不得从退役区反向定义 PG 当前身份、当前现实或当前监管边界

当前特别注意：

- 退役区中曾出现旧 Core 检查端口 `38789`
- 当前正式口径为：Core `12289`，PG `58789`
- `60789` 为旧测试口，不作为正式依据

---

## 三、08-IMPORT-STAGING

`08-IMPORT-STAGING/` 如存在，仅作为导入暂存池，不是当前正式入口。

用途：

- 存放候选材料
- 记录待筛选来源
- 作为未来人工升格前的暂存层

禁止：

- 不得直接作为 PG 当前身份或现实依据
- 不得绕过正式入口直接覆盖 PG 正式层

---

## 四、99-DEFERRED

`99-DEFERRED/` 如存在，仅作为延迟处理区，不是当前正式入口。

用途：

- 保存暂不处理的旧材料
- 作为历史回查来源

禁止：

- 不得作为当前 PG 主脑入口
- 不得参与当前阶段判断
- 不得从 deferred 反向定义当前 PG

---

## 五、正式区与退役区重叠的判断

PG 正式区与退役区存在大量内容重叠，这是正常现象。

含义：

- 正式区已经吸收了一部分旧材料
- 退役区保留旧来源与历史证据
- 重叠不代表要恢复退役区
- 重叠不代表正式区无效

处理原则：

- 当前判断以正式区为准
- 退役区只用于追溯来源
- 若正式区与退役区冲突，听正式区
- 若退役区出现旧端口、旧身份、旧路径，不自动回流

---

## 六、总原则

PG 当前入口只认正式层。

一句话：

`07` 是退役材料，`08` 是暂存材料，`99` 是延迟旧材料；它们都不是当前 PG 正式入口。
