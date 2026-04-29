# 03 Core oMLX 外部工具接入卡 V1

## 上位规则

本卡为局部说明卡，只记录 Core 接入 oMLX 本地服务的当前方式、边界和验收口径。

涉及 Core / PG 主判、模型位、外部工具、fallback、Gemma4 / oMLX 职责边界时，统一受以下上位卡统领：

- `03-Core-PG主判与外部工具权力结构-V1.md`

若本卡与上位卡冲突，以上位卡为准。

## 一、定位

oMLX 是 Core 可调用的外部本地多模态工具服务，不是 Core 主脑，也不进入 Core 模型槽。

## 二、当前服务

- 服务：oMLX
- 地址：`http://127.0.0.1:18000`
- 模型：`gemma4-e4b-4bit`
- 统一入口：`~/MLX/oMLX/omlx-tool.sh`
- Core 调用入口：`~/SYOO1-Core/bin/core-call-omlx.sh`

调用链：

Core → core-call-omlx.sh → omlx-tool.sh → oMLX / Gemma4

## 三、当前已验证

Core 侧冒烟测试已通过：

1. text 调用通过
2. image 调用通过

## 四、当前边界

1. 不改 Core 主配置
2. 不写入 Core 常驻模型槽
3. 不让 Core 依赖 oMLX 才能运行
4. oMLX 失败时必须返回“工具失败”
5. oMLX 结果只作为工具结果，不能直接替代 Core 判断
6. 重要结果仍应回到 PG / Kimi 审核

## 五、当前用途

- 文本整理
- 图片 / 截图初步理解
- 后续可扩展到音频和视频材料包

## 六、硬结论

Core oMLX 外部工具接入首轮通过。

当前仍处于外接工具阶段，尚未进入 Core 正式主配置；Core 不等于 Gemma4，oMLX 也不等于 Core 主脑。
