# Brain-Canonical

这是林国伟当前的唯一主记忆仓库。

## 目标
- 让记忆脱离 OpenClaw 单独存在
- 支持未来迁移到其他工具
- 支持快速恢复，不再花大量时间找记忆

## 当前已收录
- inbox/AGENTS.md
- inbox/IDENTITY.md
- inbox/SOUL.md
- inbox/重建记忆库.md
- inbox/2026-03-03.md
- inbox/2026-03-05.md
- recovery/RESTORE.md

## 当前原则
- Brain-Canonical 是主记忆本体
- ~/.openclaw/workspace 是当前工作镜像
- ~/.openclaw/agents/main/sessions 是会话现场
- ~/.openclaw/memory/main.sqlite 是内部索引库，不是主记忆真源

## 后续待完成
- 从 sessions 中提炼重要历史
- 建立 handoff（交接备忘录）
- 建立 projects（项目运行记录）
- 建立 longterm（长期记忆）
- 建立一键打包脚本
- 建立一键恢复脚本

## 归档规则
- handoff 只保留当前有效交接与少量近期记录
- 旧 handoff 移入 archive/handoff
- projects 只保留当前项目主记录
- 旧项目版本或阶段性旧记录移入 archive/projects
- longterm 只保留当前有效版本
- 被替换或失效的长期记忆移入 archive/longterm
- 主脑常驻内容应保持精简，避免无限堆积
