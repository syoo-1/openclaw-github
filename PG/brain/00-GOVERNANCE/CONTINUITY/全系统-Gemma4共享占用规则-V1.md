# 上位规则说明

本卡为 PG 已落地机制的局部说明卡。

涉及 PG / Core 主判、模型位、外部工具、fallback、Gemma4 / oMLX、能力升级与回归、老林最高调度权、横向流与纵向能力流时，统一受以下 03 上位卡统领：

- `~/System-Snapshots/03-rebuild-code/docs/03-Core-PG主判与外部工具权力结构-V1.md`

若本卡旧表述与上位卡冲突，以上位卡为准。

---

# 全系统 Gemma4 共享占用规则 V1

## 一、定位

Gemma4-e4b 是全系统共享的本地全模态能力模型。

它不属于 PG。
它不属于 Core。
它不属于未来某个单独 Bot。

它属于公共能力层。

## 二、共享对象

以下系统都可以调用同一个 Gemma4：

- PG
- Core
- 未来新增 Bot

但必须遵守同一套占用规则。

## 三、全局独占规则

同一时间，全系统只允许一个 Gemma4 任务运行。

- PG 正在用 Gemma4 时，Core / 新 Bot 等待。
- Core 正在用 Gemma4 时，PG / 新 Bot 等待。
- 新 Bot 正在用 Gemma4 时，PG / Core 等待。

等待不是退出系统。
等待只是暂时不调用 Gemma4。

PG / Core / 新 Bot 本体都继续运行。

## 四、30 分钟驻留规则

Gemma4 完成一次任务后，可以在 Ollama 内存中短时间驻留。

建议：

- `OLLAMA_NUM_PARALLEL=1`
- `OLLAMA_MAX_LOADED_MODELS=1`
- `OLLAMA_KEEP_ALIVE=30m`

含义：

- 一次只处理一个 Gemma4 请求。
- 同时只加载一个本地模型。
- Gemma4 用完后保留 30 分钟，避免频繁冷启动。
- 超过时间不用再自动释放，避免长期压内存。

## 五、PG 与 Core 连续使用场景

允许以下流程：

1. PG 调用 Gemma4 接收全模态任务。
2. Gemma4 生成观察任务包。
3. Gemma4 任务结束，但模型仍在内存驻留。
4. Kimi 判断后将任务派给 Core。
5. Core 重新提交自己的任务上下文给 Gemma4。
6. Core 继续使用同一个已驻留的 Gemma4。

注意：

Gemma4 驻留的是模型本体，不是 PG 的任务记忆。
Core 调用时必须重新提交 Core 的任务上下文。

## 六、硬件保护原则

在 16GB Mac mini 上，禁止：

- PG 和 Core 同时跑两个 Gemma4
- 多个 Bot 同时抢 Gemma4
- Gemma4 长期永久常驻未评估
- 把 Gemma4 放进 PG / Core 的 `primary` 或 `fallback`

## 七、硬结论

Gemma4 全系统共享，但不共享任务主权。

Gemma4 只提供本地全模态能力。
主权、分流、审核、放行仍归各系统主体、后层脑链与 03 主判规则；Kimi 只是默认主判模型位，不是脑子本体。
