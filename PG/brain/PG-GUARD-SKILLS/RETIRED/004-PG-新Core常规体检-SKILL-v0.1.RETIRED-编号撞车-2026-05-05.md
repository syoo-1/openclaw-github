# 004 PG-新Core常规体检-SKILL v0.1

## 状态
active

## 触发口令

近一，给新 Core 做一次体检

## 口令含义

当用户说“近一，给新 Core 做一次体检”时，PG 应自动理解为：

对新 Core 做一次监管体检；只读检查；运行或读取新 Core 常规体检工具；读取最新报告；从监管角度判断通过项、异常项、外部模型问题、系统自身问题、Obsidian 联通、未完成尾巴和是否放行；不要修复。

## 体检对象

新 Core：

/Users/syoo1/新Core/Core-v1

## 可调用的新 Core 体检工具

/Users/syoo1/新Core/Core-v1/tools/core-health-check-v1.1.sh

## 新 Core 体检报告位置

/Users/syoo1/新Core/Core-v1/brain/08-IMPORT-STAGING/CORE-HEALTH-CHECK-REPORT-*.md

优先读取最新生成的一份。

## PG 监管边界

PG 本技能只做：

- 只读检查
- 读取报告
- 判断风险
- 判断是否放行
- 指出未完成尾巴
- 给出最多两条下一步建议

PG 本技能不做：

- 不自动修复
- 不修改新 Core 正式层
- 不修改 PG 正式层
- 不重启服务
- 不把局部通过说成全部通过
- 不把外部模型 429 / overloaded 误判成新 Core 记忆失败
- 不把 Obsidian 可见性通过误判成自动分类整理已完成

## PG 固定输出格式

# PG 新 Core 监管体检结果

## 一、总判定
放行 / 带尾巴放行 / 拦截

## 二、小一自检报告可信度
可信 / 部分可信 / 不可信

## 三、通过项
列出已通过内容。

## 四、异常项
列出发现的问题。

## 五、外部模型问题
说明是否存在 429 / overloaded / rate limit。

## 六、系统自身问题
说明是否存在路径缺失、EISDIR、ENOENT、permission、timeout、failed 等。

## 七、Obsidian 联通
通过 / 未验证 / 异常。

## 八、未完成尾巴
列出未完成项。

## 九、PG 建议
最多两条，不展开大工程。

## 判定规则

### 放行
基础路径、关键文件、核心口径、正式层授权规则、Obsidian 暂存区检查均正常；无影响当前运行的严重错误。

### 带尾巴放行
主体正常，但存在外部模型 429、历史 Telegram 异常、EISDIR / ENOENT 等不影响主体判断的问题。

### 拦截
出现以下情况之一：
- 新 Core brain 关键目录缺失
- CURRENT-REALITY.md / RULES-COMPACT-V1.md / IDENTITY.md / CURRENT.md 关键文件缺失
- 无法找到 OpenClaw / Obsidian 单脑双入口口径
- 无法找到正式层变更需新03或用户授权的规则
- 新 Core 体检报告无法生成或无法读取
- 发现体检结果与实际证据明显矛盾

## 使用说明

用户只需要说：

近一，给新 Core 做一次体检

PG 不要求用户说“复核”两个字。

## 触发优先级补充

当用户明确说：

近一，给新 Core 做一次体检

或同义表达：

给新 Core 做体检
给小一做体检
检查新 Core 健康状态
跑新 Core 常规体检

PG 应优先直接命中本技能 004。

本口令不应先触发 002-PG-03-达标扫描，除非用户明确提到：
- 03 达标
- 03 扫描
- 03 放行
- 03 标准
- 用 03 检查
- 03 收口

若用户只说“体检”“健康检查”“检查新 Core”，则按本技能处理。
