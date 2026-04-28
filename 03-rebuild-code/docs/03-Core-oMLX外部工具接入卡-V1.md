# 上位规则说明

本卡为局部说明卡。涉及 Core / PG 主判、模型位、外部工具、fallback、Gemma4 / oMLX 职责边界时，统一受以下上位卡统领：

- `03-Core-PG主判与外部工具权力结构-V1.md`

若本卡旧表述与上位卡冲突，以上位卡为准。

---

# 03 Core oMLX 外部工具接入卡 V1

## 定位

本卡记录 Core 接入 oMLX 本地服务的当前方式、边界和验收口径。

oMLX 不是 Core 主脑。
oMLX 不是 Core 模型槽。
oMLX 只是 Core 可调用的外部本地多模态工具服务。

## 当前服务

- 服务：oMLX
- 地址：http://127.0.0.1:18000
- 模型：gemma4-e4b-4bit
- 统一入口：~/MLX/oMLX/omlx-tool.sh

## Core 当前调用入口

Core 侧入口：

~/SYOO1-Core/bin/core-call-omlx.sh

该脚本只转调用：

~/MLX/oMLX/omlx-tool.sh

## 当前已验证

Core 侧冒烟测试已通过：

1. text 调用通过
2. image 调用通过

## 当前边界

1. 不改 Core 主配置
2. 不写入 Core 常驻模型槽
3. 不让 Core 依赖 oMLX 才能运行
4. oMLX 失败时必须返回“工具失败”
5. oMLX 结果只作为工具结果，不能直接替代 Core 判断
6. 重要结果仍应回到 PG / Kimi 审核

## 当前用途

- 文本整理
- 图片 / 截图初步理解
- 后续可扩展到音频和视频材料包

## 接入原则

Core 调用 oMLX 时，只把它当作外部能力工具。

正确关系是：

Core
→ core-call-omlx.sh
→ omlx-tool.sh
→ oMLX / Gemma4

不是：

Core
= Gemma4

也不是：

oMLX
= Core 主脑

## 当前结论

Core oMLX 外部工具接入首轮通过。

但当前仍处于外接工具阶段，尚未进入 Core 正式主配置。
