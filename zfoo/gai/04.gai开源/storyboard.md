# Storyboard — GAI：把编辑器做成一个游戏

## Materials

- `storyboard.md`（本文件旧版）→ 现场演示配音草稿，3:15 完整版节奏与已核对数字（60 个可视化场景 / 36 个资产技能 / 19 个工具类），本版沿用其叙事骨架与关键台词
- `README.md` → 事实来源：整个应用是一个 Godot 场景、每一轮 git 检查点、`.memory/` Markdown 记忆、浏览器使用、本地部署 `.dependency/`、36 个资产技能、MCP、`AGENTS.md`、独立的 `zfoo/` 框架
- `agent/asset/image/screenshot/gai_1.png` → 静帧：深色聊天界面、流式工具卡片、内嵌网页截图、`Revert / Delete` 芯片
- `agent/asset/image/screenshot/workflow_1.png` → 静帧：Typed 节点画布、技能库侧栏、金黄/紫色连线
- `agent/asset/image/logo/logo_1024.png` → 片尾标志
- `agent/ui/visuals/`（60 个场景目录：`matrix_rain`、`reasoning_tree`、`context_memory_river`、`go_board`、`orrery`、`transformer` …）→ 抽象插入镜头素材
- `.memory/` + `MEMORY.md` / `AGENTS.md` / `SKILLS.md` → 屏幕上真实出现的文字内容
- `.agents/skills/` + `.ai/` → 36 个技能与命令行调用示例

> 仓库目前只有 2 张公开截图，其余画面需实拍录屏。本表的 i2v 提示词以“录屏截一帧 → 作为首帧驱动”的方式书写；不依赖生成模型还原 UI 文字。

## Visual Style

- Medium: 以真实 Godot 界面录屏为骨架，穿插同源 GPU 场景全屏插入镜头；不画假 UI，不改界面文字
- Mood: 冷、暗、机房感，语速平、不推销；结尾一句带一点冷幽默
- Color / light: 近黑底 `#0d0f12`，青绿强调色，用户气泡紫，画布连线金；屏幕光是唯一主光，暗环境里屏幕边缘有微弱辉光
- Camera: 16:9 锁定构图为主，3–8% 缓推、阅读速度的纵向跟随；抽象镜头才用缓慢漂移；无手持、无旋转
- Motion energy: 低。文字镜几乎静止，只让流式文本与光标动；只有场景插入镜头是高动态
- Aspect: 16:9

## Spine

冷开场先推翻预期（“网页” vs “Godot 场景”），再用一个真实任务走完 loop → 检查点 → 记忆的主线，中段揭示为什么非得是游戏引擎（60 个被工具调用驱动的实时场景），后段扩到浏览器、36 个资产技能与节点画布、本地部署与生态，最后一句反差收尾。总时长约 3 分 25 秒。Shot 01 用“打字 → 首个工具卡片 → 背后矩阵雨亮起”的动静反差抓人，不承担论点总结。

## Assembly

- 12 个镜头，顺序固定；总时长 ≈ 3:23（目标成片 3:15–3:30）
- 画面：Shot 03/04 首帧取 `gai_1.png`，Shot 09 取 `workflow_1.png`，其余现场录屏后截帧驱动 i2v；Shot 06 直接用 `agent/ui/visuals/` 真实渲染屏录，不生成
- 配音：中英双轨分别 TTS（`storyboard-tts`），中文 2.4–3.5 字/秒、英文 1.6–2.2 词/秒，已按镜头时长逐条配平（Shot 02/10/11 留了换气空档）
- 音乐：低频暗色脉冲铺底，音量压在 VO 之下 12–15 dB，工具卡片流式出现时可有极轻的点击音
- 拼接：`video-merge`（随机 0.5s xfade）；UI 文字镜不做 AI 超分，保持文字锐利
- 30 秒版：01 → 03（只留 grep + browser 两张卡）→ 06（三场景各 2s）→ 09（画布连线）→ 12，画面复用主片素材
- 一句话版：只用 Shot 12 的画面与前 8 秒，中英各一条口播

## Shots

### Shot 01 — 网页？不，是引擎 — cold open / hook
- **Duration:** ~10s
- **Source:** 实拍录屏（`agent/Agent.tscn` 新会话空界面）
- **Visual:** 近黑窗口，空的对话区；输入框里一根青色光标匀速闪；用户打出任务并回车，第一张工具卡片从底部滑入并停住；对话背后一层低透明度矩阵雨开始下落
- **Camera:** 16:9 锁定全景，向输入框 3% 缓推
- **Chinese:** 别的 AI 助手是网页。GAI 是一个 Godot 场景。整个应用，就是一款游戏引擎。
- **English:** Most AI assistants are web pages. GAI is a Godot scene. The whole app is one game engine.
- **Video prompt:**
  ```
  Image-to-video from provided still: a near-black desktop coding app window on a dark screen, empty transcript, one thin teal caret blinking in the input field at a steady one-hertz rhythm. The caret types a short task, a single tool-call card slides up from the bottom edge of the transcript and settles with a soft fade, and a faint green matrix-rain glow begins falling behind the transcript at low opacity. Locked 16:9 frame with a very slow 3 percent push-in toward the input field. Keep every existing panel, label and typography exactly as in the still; add no new text.
  ```
- **Avoid:** 文字重绘/乱码、面板形变、闪光、字幕叠字

### Shot 02 — GDScript 与 godot-cpp，但重点不是长相
- **Duration:** ~14s
- **Source:** 实拍录屏（顶栏 Editor / Workflow / Note 标签、文件树、`cpp/` 目录）
- **Visual:** 光标点在 `Editor` 标签上，文件树展开、一个 `.gd` 文件开成代码页；随后切到 `cpp/` 目录与 GDExtension 文件；最后拖一下窗口边框、切一次标签，画面跟手、无掉帧
- **Camera:** 两次小幅推近；标签与目录之间一次短促甩镜作匹配剪
- **Chinese:** 底层 GDScript，碰系统的地方用 godot-cpp。UI 走 GPU 渲染，天生带 shader 和动画。但重点不是长相，是怎么干活。
- **English:** GDScript underneath, godot-cpp where it touches the system. The UI is GPU-drawn — shaders and animation come free. But looks aren't the point. The loop is.
- **Video prompt:**
  ```
  Image-to-video from provided still: a dark code-editor window with a top tab row reading Editor, Workflow, Note. A cursor moves to the Editor tab, a subtle click ripple appears, the file tree expands and a GDScript file opens as a code tab; then a quick match cut to the same window with a cpp folder expanded. Finish by resizing the window edge inward and back once, all panels reflowing smoothly with no frame drops. Locked 16:9 frame, tiny 4 percent push-ins, clean and mechanical. Preserve all written labels and code text exactly as in the still.
  ```
- **Avoid:** 代码文字变形、光标轨迹抖动、多余弹窗

### Shot 03 — 一个循环，不是一个补全插件
- **Duration:** ~20s
- **Source:** 实拍录屏；首帧 = `agent/asset/image/screenshot/gai_1.png`
- **Visual:** 用户发一条真实任务；工具卡片按时序流出 — `list_dir`、`glob`、`grep`、`read` 各带一行结果摘要；随后 `web_search` 卡片里滚出一条网页缩略图；再一张 `browser_act` 卡片带真实页面截图；整列按阅读速度向下滚
- **Camera:** 锁定构图；纵向跟随滚动，跟随速度略慢于文字出现速度（让人感觉“还没说完就干完了”）
- **Chinese:** 它不是补全插件，它是一个循环。读目录、glob、grep 找代码；上网搜，或者打开真实浏览器点一下、截个图；然后改代码、跑 bash、跑测试，最后把 diff 摆到你面前。
- **English:** Not an autocomplete plugin — a loop. List, glob, grep to find the code. Search the web, or open a real browser: click, type, screenshot. Then edit, run bash, run the tests, and put the diff in front of you.
- **Video prompt:**
  ```
  Image-to-video from provided still: a dark chat transcript already dense with streaming tool-call cards. New cards slide up from the bottom in sequence — a file listing card, a glob card, a grep card, a read card — each typing its one-line result and folding into a compact chip. Then a web-search card appears with a small page thumbnail fading in, followed by a browser-action card with a real page screenshot. The whole transcript scrolls upward smoothly at reading speed. Locked 16:9 frame, no camera shake. Keep all card text, icons and layout identical to the still.
  ```
- **Avoid:** 卡片闪烁重排、缩略图变脸、虚构工具名

### Shot 04 — 每一轮都是一个 git 检查点
- **Duration:** ~15s
- **Source:** 实拍录屏；首帧 = `gai_1.png` 的对话轮次头部
- **Visual:** 悬停一个已完成的轮次，右上角 `Revert` / `Delete` 芯片亮起；点开 Revert 出现“单文件 / 整个工作区”的选择；工作区文件列表逐行闪一下青色，回到上一轮状态；画面下方一行路径显示这是会话自己的工作区目录
- **Camera:** 先紧贴在轮次头部芯片上，选中后拉开到能看见文件列表整体回滚
- **Chinese:** 跑歪了怎么办？每一轮都是一个 git 检查点。可以只回滚一个文件，也可以退回整个工作区——而且它不碰你自己的仓库。
- **English:** When it goes sideways? Every turn is a Git checkpoint. Restore one file, or roll the whole workspace back — and your own repo is never touched.
- **Video prompt:**
  ```
  Image-to-video from provided still: the header of a finished turn in a dark chat app, tiny Revert and Delete chips on the right. The cursor hovers, the chips brighten; a restore menu opens with two plain options. As one is chosen, a column of file rows beside the chat flips back one by one with a brief teal flash. Camera: tight on the chips, then a slow pull-out to reveal the whole file list returning to its earlier state. Locked 16:9, no shake. Do not alter any interface text.
  ```
- **Avoid:** 菜单文字乱码、文件行抖动、假系统弹窗

### Shot 05 — 记忆是 Markdown，不是上下文窗口
- **Duration:** ~24s
- **Source:** 实拍录屏（`Editor` 里的 `.memory/` 与 `MEMORY.md`）
- **Visual:** 文件树里 `.memory/` 展开 — `user.md`、`focus.md`、`experiences.md`；打开 `MEMORY.md` 的 Markdown 预览，慢慢滚过真实条目；切回聊天，一次压缩过程中出现后台整理记忆的一行进度；再开一个新会话，第一句回复已经带着项目上下文
- **Camera:** 三个硬切，各自 5% 缓推；Markdown 文字镜以朗读速度滚
- **Chinese:** 大部分 agent 的记忆活在上下文窗口里，压缩一次就没了。GAI 的记忆是 Markdown，就在 `.memory/`：规则、目标、以前发生过什么，能打开能改。压缩时，后台还有一个 agent 专门整理。下次开会话，它不用从零认识你。
- **English:** Most agents keep memory inside the context window — one compaction and it's gone. GAI's memory is Markdown under `.memory/`: your rules, your goals, what already happened. Open it, edit it, delete it. During compaction a background agent curates it. Next session, it doesn't start from zero.
- **Video prompt:**
  ```
  Image-to-video from provided still: a dark file tree with a .memory folder expanded into plain markdown files; the selected file opens as a rendered markdown preview and scrolls slowly down through real entries, the text staying crisp and unreadable-fast. Cut to the chat pane where a single compaction status line appears, then to a fresh session whose first reply already references project context. Three locked 16:9 framings with gentle 5 percent push-ins, no rotation. Preserve all filenames and body text exactly as in the still.
  ```
- **Avoid:** 文字重绘、滚动晃动、虚构文件名

### Shot 06 — 为什么非得是游戏引擎
- **Duration:** ~22s
- **Source:** `agent/ui/visuals/` 实时渲染屏录（`matrix_rain` → `reasoning_tree` → `context_memory_river` → `go_board`）
- **Visual:** 全屏抽象：绿色矩阵雨倾泻 → 缓慢生长的推理树 → 发光的记忆长河 → 围棋盘上落子；最后一镜回到应用窗口，同一片场景在对话背后以低透明度持续运行
- **Camera:** 每个场景一个 4–5s 长镜，缓慢漂移或微推；场景之间硬切，不叠化
- **Chinese:** 那为什么非要用游戏引擎？因为界面可以是活的。它调用的每个工具，都会在对话背后点亮一片画面——矩阵雨、推理树、一条流动的记忆长河。六十种场景，你自己挑。不是贴图动画，是 GPU 实时渲染。
- **English:** So why a game engine at all? Because the interface can be alive. Every tool call lights up a scene behind the transcript — matrix rain, a reasoning tree, a flowing memory river. Sixty of them, and you pick. Not looped video: rendered live on the GPU.
- **Video prompt:**
  ```
  Image-to-video from provided still: a full-frame dark shader scene behind a thin, low-contrast code transcript — dense green glyph rain falling in layered depth, the strands brightening where a tool call lands, screen-space glow accumulating without washing out the background. Slow 6 percent push-in, no cuts, no rotation. Keep the shader look procedural and real-time: fine glyph trails, subtle bloom, near-black background. Do not add logos, readout panels or readable sentences.
  ```
- **Avoid:** 文字变形成可读句子、赛博霓虹过饱和、卡通化

### Shot 07 — 它不转圈
- **Duration:** ~16s
- **Source:** 实拍录屏 + 一张对照片（左：普通加载环；右：工具调用驱动的画面）
- **Visual:** 左右分屏：左侧一个灰色转圈图标机械旋转；右侧同一段对话里工具卡片连续落下，背景场景随每一次调用脉动提亮；分屏线在最后一次调用时消失，只剩右侧
- **Camera:** 两侧都锁定；右侧每次调用给 1% 的亮度脉冲
- **Chinese:** 它干活的时候不转圈加载。工具调用直接驱动画面。这大概是“用游戏引擎做 agent”唯一说得通的理由——让它有状态，而不是有个 spinner。
- **English:** No spinner while it works. The tool calls drive the picture. That's the one honest reason to build an agent on a game engine — it can have a state, not just a loading icon.
- **Video prompt:**
  ```
  Image-to-video from provided still: a centered split-screen on near-black. Left half: one plain grey loading ring rotating at a constant, almost bored pace. Right half: the same conversation pane where tool-call cards land one after another in quick succession, and a dark shader scene behind them brightens in a small pulse with each landing. On the final landing the split line fades out and the right half expands to full frame. Locked 16:9, no camera movement, mechanical timing.
  ```
- **Avoid:** 品牌标识、界面乱码、旋转加速的喜剧感

### Shot 08 — 它真的会开浏览器
- **Duration:** ~12s
- **Source:** 实拍录屏（`browser_open` / `browser_act` 卡片与页面截图）
- **Visual:** 键盘敲一行“去这个页面找价格”，`browser_open` 卡片弹出真实页面截图；`browser_act` 依次：点击、输入、再截一张图 —— 截图内容前后确实变了
- **Camera:** 先锁在卡片上，再推到截图细节，最后回到卡片结果行
- **Chinese:** 它也能真的开浏览器：打开、观察、点击、打字、截图——不是凭空猜网页长什么样。
- **English:** It can actually use a browser: open, observe, click, type, screenshot — instead of guessing what a page looks like.
- **Video prompt:**
  ```
  Image-to-video from provided still: a dark transcript with one browser-action card holding a real web-page screenshot thumbnail. The thumbnail is opened larger, then a click marker appears on the page, a short text field fills character by character, and a second screenshot slides in beside the first showing the page clearly changed. Camera locked on the card, then a 10 percent push-in on the screenshot detail, then back out. Keep the page content and card text exactly as in the still.
  ```
- **Avoid:** 网页内容被重绘、截图闪烁、假加载条

### Shot 09 — 36 个资产技能，和一条拖出来的流水线
- **Duration:** ~24s
- **Source:** 实拍录屏；首帧 = `agent/asset/image/screenshot/workflow_1.png`；命令行片段实拍
- **Visual:** 节点画布：技能库侧栏 Categories（Audio / Image / Video）滚过；金黄连线从 `input-folder` 拉出，串起 `batch-for-each` → `audio-to-wav` → `audio-trim` → `audio-loudness-normalization` → `audio-sample-rate-standardize` → `audio-to-ogg`；按 `Run`，画布边缘出现一行输出；最后 2 秒切 CLI：`.dependency/python/python .ai/audio-to-wav/convert.py --audio …`
- **Camera:** 从画布全景开始，沿连线缓慢推近到链条末端，停在 `Run` 上
- **Chinese:** 它也不只会写代码。仓库里带了 36 个资产技能：音频清理、抠图、视频转 4K、故事板、语音克隆。聊天里能调，命令行能调，还有一个带类型的节点画布——拖几个节点连起来，就是一条流水线。
- **English:** And it does more than code. 36 asset skills ship in the repo: audio cleanup, background removal, 4K video, storyboards, voice cloning. Call them from chat, from the CLI, or from a typed node canvas — drag a few nodes together and you have a reusable pipeline.
- **Video prompt:**
  ```
  Image-to-video from provided still: a dark node-canvas workflow editor with a skill library sidebar and a chain of nodes connected by glowing golden and violet bezier links. The camera slowly pushes along the link chain from the input folder node to the final export node; each node lights up as the path reaches it. Then the Run button is pressed and a single line of terminal output appears at the bottom edge. Locked 16:9 with a smooth 8 percent push-in, no shake. Every node label, port name and sidebar entry stays exactly as in the still.
  ```
- **Avoid:** 节点标签变形、连线抖动、多余节点自动生成

### Shot 10 — 全部跑在这台机器上
- **Duration:** ~16s
- **Source:** 实拍录屏（Settings 里的 chat endpoint、`.dependency/` 目录、`read_image` 返回本地描述）
- **Visual:** 设置里把聊天地址改成 `127.0.0.1`；文件树展开 `.dependency/` —— godot、python、node、GGUF 模型目录；回到聊天，图片被 `read_image` 读成一段本地描述
- **Camera:** 锁定 UI；`127.0.0.1` 输入框上 6% 缓推；目录展开时轻微下移
- **Chinese:** 都能跑在本地：Godot、Python、Node、GGUF 模型全装在 `.dependency/`。聊天指到 `127.0.0.1`，数据不出这台机器。读图也是本地跑的 MiniCPM-V。
- **English:** All of it runs locally: Godot, Python, Node, GGUF models land in `.dependency/`. Point chat at `127.0.0.1` and nothing leaves this machine. Image reading is a local MiniCPM-V.
- **Video prompt:**
  ```
  Image-to-video from provided still: a dark settings panel inside a coding app, one endpoint field selected. The field is cleared and 127.0.0.1 typed into it, a small save confirmation blinking once. Cut to a file tree where a .dependency folder expands to reveal godot, python, node and a local model folder, rows easing open top to bottom. Camera locked, with a 6 percent push-in on the endpoint field. Keep all existing labels, paths and iconography exactly as in the still; add no new UI.
  ```
- **Avoid:** IP 地址被改写、目录行错位、假进度条

### Shot 11 — 对外也不封闭
- **Duration:** ~20s
- **Source:** 实拍录屏（`web/mcp.json`、`AGENTS.md` 拷成 `CLAUDE.md` / `.cursor/skills/`、`zfoo/` 目录、`sync-godot-framework.ps1`）
- **Visual:** `web/mcp.json` 里两行 server 配置；回到聊天，一个 MCP 工具以同样的卡片形态落进同一段对话；接着把 `AGENTS.md` 复制成 `CLAUDE.md`、`.agents/skills/` 复制进 `.cursor/skills/`；最后 `zfoo/` 目录树展开，终端里跑一次 `sync-godot-framework.ps1`
- **Camera:** 锁定 + 一次匹配剪（复制文件 → 目录树变化）；结尾 5% 缓推 `zfoo/`
- **Chinese:** 对外也不封闭：MCP 服务器的工具能接进同一个对话，`AGENTS.md` 能被 OpenCode、Cursor、Claude 直接用。而它底下的 `zfoo` 框架是独立的——你可以直接同步进自己的 Godot 项目。
- **English:** It's open on the outside too: MCP server tools join the same transcript, and AGENTS.md works as-is in OpenCode, Cursor and Claude. Underneath, zfoo is a standalone Godot framework you can sync into your own project.
- **Video prompt:**
  ```
  Image-to-video from provided still: a dark file panel showing a small JSON config with two server entries, beside it a chat transcript where an MCP tool card drops into the same stream of tool-call cards. Then a plain markdown file is copied and a sibling config folder updates in place; finally a folder tree of a standalone framework expands and a terminal line scrolls once as a sync script runs. Locked 16:9 with one clean match cut and a 5 percent push-in at the end. Keep all file names and paths exactly as in the still.
  ```
- **Avoid:** 文件名自动补全成别的名字、文件图标乱跳、终端伪造日志

### Shot 12 — 收尾：把编辑器做成一个游戏
- **Duration:** ~10s
- **Source:** 实拍录屏尾帧 + `agent/asset/image/logo/logo_1024.png`
- **Visual:** 从对话窗口缓慢拉远，整扇窗口缩进一片黑；青色辉光里 GAI 标志浮现；下方一行小字是仓库地址 `github.com/godot-fun/gai`
- **Camera:** 匀速拉远（不旋转），标志在中心定格 2 秒后淡出
- **Chinese:** 一句话：别人把 AI 塞进编辑器，GAI 是把编辑器做成了一个游戏。谢谢。
- **English:** In one line: everyone else put AI inside an editor. GAI turned the editor into a game. Thanks for watching.
- **Video prompt:**
  ```
  Image-to-video from provided still: the full coding app window sits centered on a black field. The window recedes slowly and evenly into the dark, its screen glow contracting to a small point of teal light; a simple geometric logo mark then resolves out of that glow, centered, holding still for two seconds before fading. Camera: straight dolly back, no rotation, no parallax wobble. Keep the logo silhouette and its proportions identical to the still; no additional text is drawn.
  ```
- **Avoid:** 标志变形、辉光溢色成紫红、拉远时窗口内容重绘
