# Narration Script — GAI：把编辑器做成一个游戏

## Chinese

### 01 — 约 10 秒 · 冷开场
别的 AI 助手是 JS 网页。
GAI 是一个 Godot 场景。
整个应用就是一个游戏引擎。

### 02 — 约 11 秒 · 引擎底子
底层是 GDScript，UI 走 GPU 渲染，天生就有 shader 和动画——就是要做一个酷酷的 Agent。

### 03 — 约 16 秒 · 工具循环
读目录，用 glob 和 grep 找代码。
打开真实浏览器上网搜，改代码、执行 bash、跑测试。
基本上囊括了所有 code agent 该有的功能。

### 04 — 约 8 秒 · git 检查点
每一轮都是一个 git 检查点。
不用担心改坏，随时回滚。

### 05 — 约 10 秒 · Markdown 记忆
GAI 的记忆就是 .memory 目录里的 Markdown 文件，能打开、能改、能删。
简单轻量，方便维护。

### 06 — 约 27 秒 · 实时场景
那为什么非要用游戏引擎？
现在的 Agent 太丑了，我实在受够了，所以用游戏引擎做一个最酷的。
把大模型的执行流程做成动画、做成游戏。
六十种特效，你自己挑。
不是贴图动画，而是 GPU 实时渲染的。

### 07 — 约 16 秒 · 不转圈
工具调用直接用动画展示，工具一报错就直接拍在你脸上。
这是“用游戏引擎做 agent”唯一说得通的理由。

### 08 — 约 10 秒 · 真浏览器
它也能真的开浏览器，而且是自己控制。
这就是用游戏引擎做出来的 browser use。

### 09 — 约 13 秒 · 资产技能
它也不只会写代码。
仓库里带了 36 个资产技能。
音频清理、抠图、4K 视频转换、语音克隆、HTML 动画制作。

### 10 — 约 16 秒 · 本地部署
这些都能跑在本地。
Godot、Python、Node，还有 GGUF 模型，全都放在 .dependency 目录里。
把聊天地址指到 127.0.0.1，数据就不出这台机器。
读图用的是本地跑的 MiniCPM-V。

### 11 — 约 13 秒 · 开放生态
自带 MCP 工具，能接上你想要的 MCP 服务。
自带 zfoo 框架，能直接搬进自己的 Godot 项目。

### 12 — 约 9 秒 · 收尾
一句话总结：这就是整条街最靓的仔。
快来关注一波 GAI 吧。

## English

### 01 — About 10 seconds · cold open
Most AI assistants are JavaScript web pages.
GAI is a Godot scene.
The whole app is one game engine.

### 02 — About 11 seconds · the engine
GDScript underneath, the UI is GPU-drawn and gets shaders and animation for free — because this is meant to be a cool agent.

### 03 — About 16 seconds · the loop
List directories, glob and grep to find the code.
Open a real browser to search, edit the code, run bash, run the tests.
That's basically every feature a code agent should have.

### 04 — About 8 seconds · checkpoints
Every turn is a Git checkpoint.
No fear of breaking things — roll back whenever you want.

### 05 — About 10 seconds · memory
GAI's memory is Markdown, sitting right in .memory — you can open it, edit it, delete it.
Simple, lightweight, easy to maintain.

### 06 — About 27 seconds · live scenes
So why a game engine at all?
Because today's agents are just ugly, and I'd had enough — so I built the coolest one on a game engine.
Every step the model takes becomes animation, becomes a game.
Sixty effects, and you pick.
Not looped video — rendered live on the GPU.

### 07 — About 16 seconds · no spinner
Tool calls are shown as animation, and a failed tool slaps you right in the face.
That's about the only honest reason to build an agent on a game engine.

### 08 — About 10 seconds · real browser
It can drive a real browser, and control it itself.
It's browser use, packaged inside a game engine.

### 09 — About 13 seconds · asset skills
And it does more than code.
36 asset skills ship with the repo.
Audio cleanup, background removal, 4K video, voice cloning, HTML animation.

### 10 — About 16 seconds · local
All of it runs locally.
Godot, Python, Node and GGUF models all live in .dependency.
Point chat at 127.0.0.1 and nothing leaves this machine.
Image reading is a local MiniCPM-V.

### 11 — About 13 seconds · ecosystem
MCP tools are built in, so you can plug in whatever MCP servers you want.
And zfoo, the framework underneath, drops straight into your own Godot project.

### 12 — About 9 seconds · outro
In one line: this is the coolest thing on the block.
So come and give GAI a follow.
