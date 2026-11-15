# Platform publish copy

## Bilibili

### Title

```
AI 很少打开 Godot 时，为什么用 gdtest 而不是先装 GUT
```

### Description

```
在 Godot 写测试，很多人第一反应是装 GUT、在编辑器面板跑。
但如果你主要在 Cursor / Opencode / Claude 里写代码，可能很少打开引擎——这时更需要轻量、AI 友好的方案。

本期讲 godot-framework 自带的 gdtest（zfoo/gdtest）：
• 零插件，复制框架就能测
• 接近零 API，直接用原生 assert
• 源码大约一两百行，可读可改
• 单元测试：UnitTest 扫描同目录，方法名以 test 开头或结尾
• 集成测试：IntegrationTest 依次跑 test 场景，约定发出 test_passed

章节参考：
00:00 冷开场：第一反应装 GUT
00:10 AI 时代很少开引擎
00:20 点名 gdtest
00:40 相对 GUT 的四条优势
01:20 单元测试怎么挂、怎么扫、fail-fast
01:50 集成测试与 test_passed
02:20 理念与 CTA

打开 zfoo/gdtest，挂上场景，写你的第一条 *_test。
```

### Tags

```
Godot, GDScript, 游戏开发, 独立游戏, 单元测试, 集成测试, gdtest, godot-framework, AI编程, Cursor, 测试框架, GUT
```

## Douyin

### Title

```
别急着装 GUT：AI 写 Godot 更吃这套轻量测试
```

### Description

```
你还在为测试先装完整插件吗？AI 时代可能很少打开 Godot 编辑器。
gdtest：零插件、原生 assert、一两百行，挂上 UnitTest 就能跑。
方法名带 test，写完就能测；集成测试发 test_passed 继续下一个。
```

### Tags

```
#Godot #游戏开发 #独立游戏 #单元测试 #AI编程 #GDScript #测试
```

## Xiaohongshu

### Title

```
Godot 测试不一定要先上大插件✨ AI 友好的 gdtest
```

### Description

```
写 Godot 测试，是不是第一反应先装 GUT？
如果日常在 Cursor / Claude 里写代码，引擎都很少开——面板依赖会变摩擦。

试试 godot-framework 自带的 gdtest（zfoo/gdtest）：
✅ 零插件，复制就能用
✅ 几乎零 API，原生 assert
✅ 源码大约一两百行
✅ AI 写完 *_test 就能跑

单元：挂 UnitTest，方法名 test 开头/结尾
集成：IntegrationTest 排队跑场景，发 test_passed

够用、好懂、能直接进项目～
```

### Tags

```
#Godot# #游戏开发# #独立游戏# #GDScript# #单元测试# #集成测试# #AI编程# #Cursor# #程序员# #开发笔记# #测试#
```

## Weibo

### Title

```
AI 写 Godot 时，测试可以轻一点：gdtest
```

### Description

```
很多人写 Godot 测试先装 GUT、靠编辑器面板。但 AI 时代你可能很少打开引擎。godot-framework 的 gdtest：零插件、原生 assert、大约一两百行；UnitTest 扫同目录 test 方法，IntegrationTest 靠 test_passed 串场景。打开 zfoo/gdtest，写第一条 *_test。
```

### Tags

```
#Godot# #游戏开发# #独立游戏# #AI编程#
```

## YouTube

### Title

```
Godot Testing Without a Heavy Plugin: gdtest for AI Workflows
```

### Description

```
If you write Godot tests, the default move is often a full editor plugin and a panel runner.
But if you live in Cursor, Opencode, or Claude, you may barely open the Godot editor — and panel-first testing gets in the way.

This video covers gdtest from godot-framework (zfoo/gdtest):
• Zero plugins — copy the framework and run
• Near-zero API — use native assert
• Tiny codebase — about one to two hundred lines
• UnitTest scans same-folder GDScript; methods starting/ending with test
• IntegrationTest queues *test* scenes and waits for test_passed

Chapters:
0:00 Cold open: reach for a full plugin
0:10 AI era: engine stays closed
0:20 Meet gdtest
0:40 Four clear advantages
1:20 Unit tests + fail-fast
1:50 Integration tests + test_passed
2:20 Close / CTA

Open zfoo/gdtest, attach the scene, write your first *_test.
```

### Tags

```
Godot, GDScript, Godot testing, unit testing, integration testing, gdtest, godot-framework, indie game development, AI coding, Cursor, game development, GUT alternative, assert
```

## X

### Title

```
I barely open Godot anymore — so I wanted tinier tests than a full plugin
```

### Description

```
GUT-style panels are fine if you live in the editor.
If you write Godot in Cursor/Claude, try gdtest (godot-framework / zfoo/gdtest): zero plugins, native assert, ~100–200 lines. UnitTest picks methods named *test*; IntegrationTest waits for test_passed.
```

### Tags

```
#Godot #IndieDev #GDScript
```

## TikTok

### Title

```
Stop installing a test plugin before you write one test
```

### Description

```
Godot tip: if AI tools are your editor now, a tiny runner may beat a full panel plugin.
gdtest in godot-framework — native assert, methods named test, scenes emit test_passed.
```

### Tags

```
#Godot #gamedev #indiedev #GDScript #unittest #AIcoding
```

## Instagram

### Title

```
Godot tests that fit an AI coding workflow
```

### Description

```
First instinct: install a full Godot test plugin and run from the editor panel.

Plot twist: if you mostly write in Cursor / Claude, you may rarely open the engine.

gdtest (godot-framework → zfoo/gdtest)
• zero plugins
• native assert
• ~100–200 lines
• UnitTest: methods starting/ending with test
• IntegrationTest: emit test_passed, next scene

Enough. Clear. Drop-in.

Save this if you’re setting up tests this week.
```

### Tags

```
#Godot #gamedev #indiedev #GDScript #unittest #integrationtesting #AIcoding #CursorAI #gamedevelopment #indiegamedev #coding #devtools
```
