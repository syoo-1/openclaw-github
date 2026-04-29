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

# PG Brain Read Order

## 默认最小读取
1. `brain/README.md`
2. `03-LONGTERM/IDENTITY/PG-IDENTITY.md`
3. `brain/handoff/模型切换交接流程-V2-热切换收口版.md`
4. `status/CURRENT.md`
5. `00-GOVERNANCE/RULES/PG-前台输出规则-V1.md`
6. `00-GOVERNANCE/RULES/PG-执行授权硬闸规则-V1.md`
7. `00-GOVERNANCE/RULES/PG-核查防漂移规则-V1.md`
8. `00-GOVERNANCE/RULES/PG-问题判明约束规则-V1.md`
9. `00-GOVERNANCE/RULES/PG-任务回报闭环规则-V1.md`
10. `03-LONGTERM/MEMORY/INDEX.md`（仅 PG 自身长期记忆索引；不作为 PG/Core 协同项目闭环入口）

## 按需展开
11. `00-GOVERNANCE/RULES/` 下相关规则卡
12. 涉及 skill / 监管 / 放行 / 03 达标扫描 时，进入 `brain/PG-GUARD-SKILLS/`
13. 当用户明确表达“按 03 的标准是不是已经达标了 / 按 03 的标准现在能不能放行 / 按 03 的标准还有没有尾巴”等意思时，优先进入 `brain/PG-GUARD-SKILLS/ACTIVE/002-PG-03-达标扫描-SKILL-v0.1.md`
14. 当当前主线已处于 03 扫描 / 升级 / 达标检查上下文中，用户再说“是否已经收口了 / 现在能放行了吗 / 还有尾巴吗”时，也优先进入 `brain/PG-GUARD-SKILLS/ACTIVE/002-PG-03-达标扫描-SKILL-v0.1.md`
15. `brain/memory/recent/` 下相关近期记忆（仅 PG 自身历史连续经历 / 监管摘要；禁止作为 PG/Core 协同项目记忆闭环默认入口）
16. `brain/reference/` 下相关参考文件

## 默认不读
- `brain/memory/archive/`（历史归档，仅参考，不作为现行协同闭环规则）

## 原则
先读短入口、短身份、短状态、短索引；只在必要时展开长内容，以节约 token。
