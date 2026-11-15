# 在 Cursor 里写 Godot 测试：为什么我更想用一两百行的 gdtest，而不是先装 GUT

在 Godot 里写测试，很多人第一反应是：装一个完整的 GUT，打开编辑器面板，点一下 Run。

这很合理。GUT 功能全、社区熟、面板直观。

但如果你现在的日常是 Cursor、Opencode、Claude——大量时间在 AI 编码工具里改 GDScript，偶尔才打开一次引擎——你会发现一个尴尬的事实：

**测试方案如果强依赖编辑器面板，AI 时代的工作流会被拖慢。**

godot-framework 里的 `gdtest`，就是为这种工作流准备的：零插件、几乎零新 API、源码大约一两百行，复制进项目就能跑。

这篇文章把问题、对比、用法和源码约定一次说清楚。

## 问题不在「要不要测」，而在「测的摩擦有多大」

独立开发或小团队里，测试经常死在这几件事上：

1. 先研究一套测试框架约定（基类、注解、生命周期、断言库）
2. 再装插件、配面板、记一堆框架专属 API
3. AI 帮你写完业务代码后，还要再教它「怎么按某框架的规矩写测试」

摩擦一高，测试就变成「有空再补」。

AI 友好的测试方案，核心不是口号，而是这三点：

- **发现成本低**：方法名一看就知道是不是测试
- **API 面积极小**：能用引擎原生能力就别再发明一层
- **可被通读**：框架本身短到人（和模型）都能快速读懂

`gdtest` 基本按这个方向做。

## gdtest 是什么

路径：`zfoo/gdtest`

它是 godot-framework 自带的测试方案，不是单独商店插件。当前核心主要是两个脚本：

- `UnitTest.gd`：单元测试运行器
- `IntegrationTest.gd`：集成测试场景队列

两者合计大约 **150 行**量级（当前仓库里分别约 73 / 76 行）。材料里说的「大约一两百行」，指的就是这种体量——少到你可以整个文件读完再决定要不要改。

相对广为人知的 GUT，材料里归纳的优势很直接：

1. **零插件**：没有附加安装，没有编辑器面板依赖，复制框架就能测
2. **零 API**：认知成本极低，用 Godot 原生 `assert` 即可
3. **代码体量极小**：行为一眼读完，维护权在自己手里
4. **AI 友好**：没有复杂约定继承，AI 写完 test 就能跑

这不是说 GUT 不好。而是：如果你的主战场已经不在编辑器面板里，轻量方案往往更贴手。

## 单元测试怎么跑

流程非常短：

1. 把 `UnitTest` 挂到场景上
2. 它扫描**同目录**下的 `.gd`（可选是否包含子目录）
3. 方法名（大小写不敏感）以 `test` **开头或结尾**，且**无参数**，就会被当作单元测试自动调用
4. `assert` 失败、`Log.error`、`printerr` 等导致错误时，测试失败，并 **fail-fast 立刻退出**

关键发现逻辑就在运行器里：

```gdscript
for method in script.get_script_method_list():
	var method_name: String = method.name
	var method_name_lower: String= method_name.to_lower()
	if !(method_name_lower.ends_with("test") || method_name_lower.begins_with("test")):
		continue
	if !method.args.is_empty():
		Log.error("❌ FAIL | [{}] | method:[{}] args is not empty", script.resource_path, method_name)
		gdf.quit(1)
		return
```

静态方法与实例方法都会收集；实例方法会 `script.new()` 后再调用。跑完单个脚本会打类似日志：

```text
✅ PASS | [res://.../SomethingTest.gd] | Run test unit:[N] | X seconds
```

仓库里真实的测试写法也很「原生」，例如 `test/utils/StringUtilsTest.gd`：

```gdscript
func is_empty_or_blank_test() -> void:
	var emptyStr: String = ""
	var blankStr: String = "  	"
	assert(StringUtils.is_empty(emptyStr))
	assert(StringUtils.is_blank(emptyStr))
	assert(StringUtils.is_not_empty(blankStr))
	assert(StringUtils.is_blank(blankStr))
	pass
```

没有继承专用 `TestCase` 基类，没有框架专属 `expect()` DSL。对 AI 来说，这通常意味着：生成出来的测试更接近普通 GDScript，而不是「某插件方言」。

## 集成测试怎么跑

单元测试适合纯逻辑；场景、动画、定时器、节点树交互，更适合集成测试。

`IntegrationTest` 的约定同样短：

1. 扫描同目录（可选子目录）里的 `.tscn`
2. 场景名（basename，小写）以 `test` 开头或结尾
3. **一个接一个实例化**
4. 当前场景跑完后，需要发出 `gdf.events.test_passed`
5. 收到信号后再进入下一个；队列空了就结束退出

扫描代码：

```gdscript
func scan_test_scenes() -> void:
	var current_scene_path := NodeUtils.scene_file_path_from_node(self)
	var scan_path := current_scene_path.get_base_dir()
	var files: Array[String] = FileUtils.get_all_files_in_folder(scan_path, include_subfolders)
	for file in files:
		if !file.ends_with(".tscn"):
			continue
		var scene_name := file.get_file().get_basename().to_lower()
		if !(scene_name.begins_with("test") || scene_name.ends_with("test")):
			continue
		if file == current_scene_path:
			continue
		test_scenes.push_back(file)
```

一个真实集成测试场景示例（`test/animation/animation_2d_test.gd`）：播完动画相关逻辑后，延迟发出通过信号：

```gdscript
extends Node2D

func _ready() -> void:
	EffectAnimation2D.spawn(Vector2(100, 200), self, "test/asset/explosion_animation.png", Vector2i(8, 1), 0.5)
	EffectAnimation2D.spawn(Vector2(500, 200), self, "test/asset/character_attack.png", Vector2i(4, 4), 0.5, 13)

	SchedulerBus.schedule(func() -> void: gdf.events.test_passed.emit(), 3000)
	pass
```

注意：集成链路靠的是 **`test_passed` 约定**，不是再学一套复杂生命周期。场景自己决定「何时算测完」。

另外，`UnitTest` 若跑在集成测试上下文中，结束时会帮忙发出 `test_passed`，让队列继续往下走；单独跑单元测试场景时则直接 `quit`。

## 和「完整插件方案」怎么选

可以粗暴地按工作流选：

| 你更常待在… | 更可能舒服的方案 |
|---|---|
| Godot 编辑器面板，喜欢可视化跑测 | GUT 这类完整插件很合适 |
| AI 编辑器 / 终端 / 脚本化启动场景 | `gdtest` 这种零插件、可读源码的方案更贴 |

再补两条实践建议：

- **先写最少约定的测试**：方法名带 `test`，断言用 `assert`，能覆盖关键路径再说
- **场景测试显式发出 `test_passed`**：别让集成队列空等；超时和失败路径要想清楚

## 容易踩的坑

1. **方法带参数**：运行器会直接判失败并退出。测试方法必须无参。
2. **命名漏了 test**：`validate_health()` 不会被发现；改成 `test_validate_health` 或 `validate_health_test`。
3. **集成场景忘发信号**：队列不会自动前进。
4. **把集成入口场景自己扫进去**：运行器会跳过当前场景路径，但命名时仍建议让入口和被测场景职责清晰。
5. **期待「框架替你做太多」**：gdtest 故意不做厚。夹具、参数化、漂亮报告如果你需要，可以自己加——因为源码短，改得起。

## 结语

godot-framework 的理念很朴素：**够用、好懂、可直接进项目。**

如果你也在用 AI 写 Godot，又觉得完整测试插件对当前工作流偏重，可以打开 `zfoo/gdtest`，挂上场景，写第一条 `*_test`。

不一定要先成为「测试框架专家」，也可以先让关键逻辑有人（和 AI）能反复跑起来。
