# I barely open the Godot editor anymore — so I stopped reaching for a full test plugin first

When people write tests in Godot, the first instinct is often: install something like GUT, open the editor panel, hit Run.

That still makes sense if you live in the editor.

But if your day looks more like Cursor / Opencode / Claude — lots of GDScript in an AI coding tool, and only occasional trips into Godot — a panel-first test workflow starts to feel heavy.

That’s why I’ve been using **gdtest**, the tiny test setup that ships with **godot-framework** under `zfoo/gdtest`.

This post is a concrete walkthrough: what it is, how unit + integration tests work, and the actual conventions in the source.

## The friction that kills testing

In small Godot projects, tests often die for boring reasons:

- You have to learn a framework dialect (base classes, hooks, custom asserts)
- You need a plugin + editor panel before anything runs
- After the AI writes gameplay code, you still have to teach it the test framework’s rituals

An AI-friendly test setup usually needs:

1. **Obvious discovery** — a method name should be enough
2. **Tiny API surface** — prefer engine-native `assert`
3. **Readable implementation** — short enough that you (and the model) can skim the runner

gdtest is basically that bet.

## What gdtest is

Two scripts do most of the work:

- `UnitTest.gd` — unit runner
- `IntegrationTest.gd` — scene queue for integration tests

Together they’re about **~150 lines** in the current tree (~73 + ~76). The pitch in the materials is blunt: zero plugins, near-zero API, tiny codebase, AI-friendly because there’s no heavy inheritance ceremony.

This is **not** “GUT is bad.” It’s “if your main loop isn’t the editor panel, a lighter runner may fit better.”

## Unit tests

Flow:

1. Attach `UnitTest` to a scene
2. It scans `.gd` files in the same folder (optional subfolders)
3. Any no-arg method whose name **starts or ends with** `test` (case-insensitive) is a unit test
4. Failed `assert`, `Log.error`, or `printerr` fails the run and **fail-fast** exits

Discovery from the runner:

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

Static methods are called on the script; instance methods get `script.new()` first.

A real test from the repo (`test/utils/StringUtilsTest.gd`) looks like normal GDScript:

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

No custom `TestCase` base class. No framework-specific expect DSL. That’s the whole point for AI-assisted writing: the test file still looks like ordinary code.

## Integration tests

For scene trees, animations, timers, and “does this node actually do the thing,” use `IntegrationTest`:

1. Scan `.tscn` files in the same folder
2. Keep scenes whose basename starts or ends with `test`
3. Instantiate them **one by one**
4. When a scene finishes, it must emit `gdf.events.test_passed`
5. Then the next scene starts; empty queue → done / quit

Scene scan:

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

Example integration scene script (`test/animation/animation_2d_test.gd`):

```gdscript
extends Node2D

func _ready() -> void:
	EffectAnimation2D.spawn(Vector2(100, 200), self, "test/asset/explosion_animation.png", Vector2i(8, 1), 0.5)
	EffectAnimation2D.spawn(Vector2(500, 200), self, "test/asset/character_attack.png", Vector2i(4, 4), 0.5, 13)

	SchedulerBus.schedule(func() -> void: gdf.events.test_passed.emit(), 3000)
	pass
```

The contract is the signal — the scene decides when it’s done.

Also useful: if `UnitTest` is running inside an integration context, it emits `test_passed` when finished so the queue can continue; standalone unit runs just quit.

## When I’d still use a full plugin

Rough heuristic:

- You mostly live in the Godot editor and want a rich panel UI → a full plugin like GUT is a great fit
- You mostly live in AI editors / scripted scene launches → gdtest’s “copy framework, native assert, tiny runner” is often enough

## Pitfalls

- Test methods **cannot take args** — the runner fails fast
- `validate_health()` won’t be discovered; name it `test_validate_health` or `validate_health_test`
- Integration scenes that never emit `test_passed` stall the queue
- Don’t expect a huge batteries-included framework — the point is that the runner is short enough to own

## Soft CTA / question for the room

godot-framework’s idea here is simple: **enough, clear, drop-in**.

If you’re also writing Godot with AI tools, what’s your current test setup — editor plugin, headless custom runner, or “we’ll test it later”? I’m curious what still feels too heavy.

Open `zfoo/gdtest`, attach the scene, write a first `*_test`, and see if the friction drops.

## Suggested subreddits

- r/godot
- r/godotengine
- r/IndieDev
- r/gamedev
- r/CursorAI
