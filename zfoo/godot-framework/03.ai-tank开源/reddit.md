# Remember guarding the eagle? This tank now pathfinds, picks targets, and takes written orders

If you played those old top-down tank games, the muscle memory is probably the same: sit on the eagle, shoot, hope the brick wall lasts one more hit.

The AI TANK intro doesn’t open on a feature list. A black tank shells the brick ring around a square eagle HQ. The emblem is still there. The wall is not.

Then a saturated-blue tank turns its turret and drives around a steel block. No cursor. No hands.

That’s the hook. The rest of the ~90s spot is: what if the tank does the pathing, the targeting, and also reads the orders you type.

## What the game actually is

Visual language is high-res modern pixel art, military sci-fi, strict orthogonal top-down. Friendlies are saturated blue and mint-green. Hostiles are black tanks, white jeeps, red elites and bosses. Your base is still a brick-ringed eagle. Enemy HQ is a hostile square with no eagle on it, which is a small but useful distinction if you grew up protecting that bird.

The claim in the VO is blunt:

> It finds its own path, picks its own targets, and understands the orders you write. This is AI TANK.

Two ways to play:

- **Manual:** you drive the blue main tank; AI teammates fight with you. The shot is a blue lead and a mint flank punching a brick corridor together.
- **AI mode:** you hand the squad to agents. They plan. If they fail, they adjust and go again. The cut is a wipe, a beat of stillness, then the same colors coming back on a wider flank instead of the failed straight line.

Campaign shape is old-school on purpose: **35 stages**, destroy the enemy base **before the countdown hits zero**, **up to six units** on the field at once. Tanks plus white four-wheel gun jeeps, not six identical hulls.

## Tank Agent is the part I keep thinking about

You can still drive. You can also type.

The trailer speaks two orders at command pace, not as a whisper:

1. “Hunt power-ups first. Attack the nearest enemy. Never hit our base.”
2. “Guard the eagle. Intercept anyone who gets close.”

On screen, the first line makes the blue tank curve to a glowing crate, then shoot the nearest black tank while missing the eagle. The second makes a mint tank turn and cut off a white jeep before it reaches the HQ.

Hit create agent and four jobs happen in one frame: one parks on the eagle, one charges, one blows a brick wall open, one scoots to a pickup. Hold / charge / clear a path / hunt upgrades. Same roster, different jobs.

That is more interesting than auto-fire. The same stage behaves differently because the text is different. If you write a greedy order, it will greed.

## Threats and pickups

Enemies scale in a straight ladder: regular black tanks, high-speed white jeeps, red elites, a dual-cannon red boss, then a larger four-cannon boss.

Pickups are four: bullet upgrades, attack boosts, freeze, airstrike. The trailer smash-cuts a good grab (freeze a red tank, airstrike the line, push through) into a bad one (wrong crate, squad bunched in a brick corridor, pinned). The line in the script is: the right pick can flip the fight; the wrong one can bury you.

So “hunt power-ups first” is not always correct. It’s a policy. Freeze and airstrike can open a lane. The wrong crate can stuff six units into a kill box. You are still the one who wrote the policy.

Late beat: same stage twice. Command field up top, three friendlies reposition as a plan (cover, flank, push). Field gone, only the blue tank left, one measured shot at a time, chewing brick the old way. Commander or driver. Both stay in the game.

Close is quiet. Empty command field, blinking cursor, first characters of an order, blue turret ticking a few degrees.

> Open AI TANK. Write your first order. Then watch: can your tanks understand what you mean?

## How written orders hook into the Godot stack

This episode sits in the godot-framework series. The “understands the orders you write” path is the OpenAI-compatible helper that already ships in `zfoo/ai`. Set `OPENAI_API_KEY`, or override `OpenAiClient.api_key` / `base_url` / `model` at runtime.

One-shot:

```gdscript
# Set OPENAI_API_KEY env, or override OpenAiClient.api_key / base_url / model
var reply := await OpenAiClient.async_chat("hello", "you are a helpful assistant")
```

Multi-turn:

```gdscript
var messages: Array[ChatMessage] = []
messages.append(ChatMessage.new(ChatMessage.ROLE_USER, "hello"))
var reply2 := await OpenAiClient.async_chat_messages(messages)
```

`ChatMessage` is three roles: `system`, `user`, `assistant`. `async_chat` just prepends a system line when you pass one, then calls `async_chat_messages`:

```gdscript
static func async_chat(prompt: String, system_prompt: String = "") -> String:
	var messages: Array[ChatMessage] = []
	if not StringUtils.is_blank(system_prompt):
		messages.append(ChatMessage.new(ChatMessage.ROLE_SYSTEM, system_prompt))
	messages.append(ChatMessage.new(ChatMessage.ROLE_USER, prompt))
	return await async_chat_messages(messages)
```

The request is an `OpenAiRequest` (model, messages, stream flag), posted with `HttpHelper.async_post`, decoded as `OpenAiResponse`, then `choices[0].message.content`:

```gdscript
var request := OpenAiRequest.new(model, messages, false)

var headers := PackedStringArray([
	StringUtils.format("Authorization: Bearer {}", api_key),
])
var response := await HttpHelper.async_post(base_url, JsonUtils.object_to_json(request), headers)
```

The manual test in the tree is the same call. Button press, one prompt, log on empty:

```gdscript
func on_chat_pressed() -> void:
	var text := await OpenAiClient.async_chat("用一句话介绍 godot-framework")
	if StringUtils.is_blank(text):
		Log.error("OpenAI returned empty text")
		return
	Log.info("OpenAI reply:[{}]", text)
	pass
```

You can drop the two Tank Agent lines in as `ROLE_USER` content. That does not magically pathfind or spare the eagle. The client only sends the line and brings the reply back. Pathing, nearest-enemy, “never hit our base,” intercept-on-approach are game code.

The file comment on `OpenAiClient` is also worth keeping in your head: local-dev only; put a backend proxy in front before shipping. Empty `api_key` logs an error and returns an empty string.

Framework repo: [github.com/godot-fun/godot-framework](https://github.com/godot-fun/godot-framework)

## If you only try one sentence

I’d type the guard order first. Short. Easy to judge. If a jeep closes on the eagle and the mint tank doesn’t turn, you saw the miss.

The loot-first order is greedier. Three clauses in one line. You have to watch whether it goes to the crate, whether it shoots the nearest hull, whether a shell clips the HQ.

Curious what you’d type as your first order: loot-first, eagle-guard, or something meaner like “ignore pickups, collapse on the four-cannon”?

## Suggested subreddits

- r/godot
- r/IndieGaming
- r/gamedev
- r/pixelart
- r/playmygame
