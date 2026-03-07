# Brain-Canonical 恢复说明

## 唯一主记忆仓库
~/Brain-Canonical

## 当前原则
- Brain-Canonical 是主记忆本体
- ~/.openclaw/workspace 是当前工作镜像
- ~/.openclaw/agents/main/sessions 是会话现场
- ~/.openclaw/memory/main.sqlite 是内部索引库，不是主记忆真源

## 恢复顺序
1. 先确认 ~/Brain-Canonical 完整存在
2. 再检查 ~/.openclaw/workspace
3. 需要时再检查 ~/.openclaw/agents/main/sessions
4. 最后才处理 ~/.openclaw/memory/main.sqlite 和其它运行状态

## 当前已收录到主记忆仓库的内容
- AGENTS.md
- IDENTITY.md
- SOUL.md
- 重建记忆库.md
- 2026-03-03.md
- 2026-03-05.md

## 注意
- 不要把 sessions/*.jsonl 当作唯一主记忆
- 不要只依赖 OpenClaw 内部目录
- 以后新增的重要记忆，优先整理到 Brain-Canonical

## 当前可用备份包
- 主脑备份：~/Brain-Backups/Brain-Canonical-2026-03-07-124048.tar.gz
- OpenClaw快照：~/OpenClaw-Backups/openclaw-home-2026-03-07-130226.tar.gz

## 快速恢复（当前版本）
### 只恢复主记忆
tar -xzf ~/Brain-Backups/Brain-Canonical-2026-03-07-124048.tar.gz -C ~

### 恢复 OpenClaw 状态
tar -xzf ~/OpenClaw-Backups/openclaw-home-2026-03-07-130226.tar.gz -C ~

### 恢复后检查
ls -ld ~/.openclaw ~/Brain-Canonical
