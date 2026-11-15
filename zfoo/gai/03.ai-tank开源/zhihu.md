# 还记得守老鹰吗？这回坦克会自己找路，也能听懂你写的命令

小时候玩坦克大战，手感几乎是同一套：守着老鹰，一炮一炮打。砖墙炸开，黑坦克从上面压下来，基地只剩一只鹰的时候，比 Game Over 四个字更难受。

AI TANK 的片子不是功能列表开场。先砸在这个画面上：方形鹰徽还在，外墙已经挨了一炮。

然后蓝坦克自己转炮塔，绕开钢板。没有鼠标，也没有手。

## 这辆坦克不一样了

经典守鹰战里，路是你开的，目标是你瞄的。炮打偏了，是你的事。

AI TANK 把三件事交给车自己做：找路、选目标、听书面命令。旁白说得很直：

> 它自己找路、选目标，还能听懂你写的命令。这就是 AI TANK。

画面是高精度现代像素，军事科幻，正交俯视。我方饱和蓝和浅绿，敌方黑坦克、白吉普、红精英。基地还是砖墙围着的方形鹰徽。看起来像童年那一局，车却不再等你按方向键。

有点熟，又有点不对劲。片子就靠这点把人留住。

## 两种玩法：你开蓝车，或把整队交给智能体

手动模式：你开蓝色主坦克，AI 队友跟你一起冲关。镜头里常见的是蓝车在前、浅绿队友压侧翼，两辆一起打穿砖廊。还是「我在开」的手感，旁边多了一辆会自己补位的车。

AI 模式：整队交给智能体。它们自己定策略。失败了，调整后再打。片子里不是煽情的全灭，而是一辆浅绿车炸开，场上停一下，同一支队伍从南边再出现，这次不走刚才那条直线，改走更宽的侧翼。

这两种玩法解决的是同一件事：你想自己打，还是想当指挥官看它们打。后面道具和 Boss 会把这个选择放大。

## 三十五关，倒计时结束前砸掉敌方基地

关卡结构很老派，也很好懂：

- 三十五关
- 倒计时结束前必须摧毁敌方基地
- 最多六辆同时上场
- 坦克和吉普组成小队

敌方基地不是鹰。片子特意避开这个：敌方是方块敌营，没有鹰徽。你要守的还是自己那只鹰，要砸的是对面的营。

六辆不是六辆同款蓝坦克。方块坦克是饱和蓝和浅绿，吉普是白色四轮、顶上架轻武器。拉开之后才像一支小队，而不是一堆克隆体。

## 最大不同是 Tank Agent

你可以开车。也可以写命令。

片子里打了两条，语速按下令来，不是耳语：

1. 「优先寻找增益，攻击最近的敌人，绝不要误伤基地。」
2. 「守护老鹰，敌人靠近时主动拦截。」

第一条是资源优先：先捡发光箱子，再打最近的黑坦克，炮弹明显避开鹰。第二条是防家：浅绿坦克转向，在白吉普贴到鹰之前截住。

点创建智能体之后，四辆友军会同时干不同的事：有人贴着鹰防守，有人往北冲锋，有人把砖墙炸开一条路，有人去找增益。防守、冲锋、开路、找增益，不是四个皮肤，是四个岗位。

这比「加一个自动开火」麻烦，也比它有用。同一张图，命令不同，车的行为就不同。你写错了，它们会认真执行那个错的。

## 敌人在升级，道具也会把你坑进去

敌人不是一直黑坦克：

普通坦克 → 高速吉普 → 红色精英 → 双炮 Boss → 四炮 Boss

压力是叠上去的。红精英先站住开火，双炮再进场，四炮占满画面上沿，友军被压在下三分之一。

能翻盘的是四类强化：

- 子弹升级（弹道变粗）
- 攻击强化
- 冻结敌人
- 空袭支援

片子把对和错剪在一起：冻住红坦克、空袭撕开口子，小队推过去；下一刀，捡错箱子，全队挤进砖廊，被火力钉死。没有血，也没有大字报，就是卡住了。

所以道具不是「捡到就变强」。选对能逆转，选错会陷入困境。Tank Agent 那条「优先寻找增益」在这里会变成双刃剑：它真的会去找，至于该不该找，是你的命令问题。

## 指挥官，或者一炮一炮

同一张砖地图，两种打法并排给你看。

先是上方一条很瘦的命令栏，蓝坦克、浅绿坦克、白吉普按计划挪位：掩护、侧翼、推进。然后命令栏消失，只剩蓝坦克，一炮一炮啃墙，像小时候那样打。

你不必站队。有人就想当指挥官，给每辆坦克定战术；有人就想亲自开，一炮一炮推进。游戏把两条都留着。

结尾更安静。空命令栏，光标在闪，先打出几个字。蓝坦克炮塔偏过几度，像在读那一行。旁白只说：

> 打开 AI TANK。写下第一条命令。看看你的坦克，能不能听懂你。

## 书面命令在工程里怎么接

这期目录挂在 godot-framework 开源系列下面。游戏侧的「听懂你写的命令」，对应框架里现成的 OpenAI 兼容聊天接口：环境变量里放 `OPENAI_API_KEY`，也可以运行时改 `api_key` / `base_url` / `model`。

单轮：

```gdscript
# Set OPENAI_API_KEY env, or override OpenAiClient.api_key / base_url / model
var reply := await OpenAiClient.async_chat("hello", "you are a helpful assistant")
```

多轮用 `ChatMessage`。角色就三种：`system`、`user`、`assistant`。

```gdscript
var messages: Array[ChatMessage] = []
messages.append(ChatMessage.new(ChatMessage.ROLE_USER, "hello"))
var reply2 := await OpenAiClient.async_chat_messages(messages)
```

`async_chat` 本身很短：有系统提示就先塞一条 `ROLE_SYSTEM`，再塞用户那句，然后交给 `async_chat_messages`。

```gdscript
static func async_chat(prompt: String, system_prompt: String = "") -> String:
	var messages: Array[ChatMessage] = []
	if not StringUtils.is_blank(system_prompt):
		messages.append(ChatMessage.new(ChatMessage.ROLE_SYSTEM, system_prompt))
	messages.append(ChatMessage.new(ChatMessage.ROLE_USER, prompt))
	return await async_chat_messages(messages)
```

真正发请求的时候，它组一个 `OpenAiRequest`（模型、消息列表、是否流式），用 `HttpHelper.async_post` 打到 `base_url`，再把 JSON 解成 `OpenAiResponse`，取出 `choices[0].message.content`。

```gdscript
var request := OpenAiRequest.new(model, messages, false)

var headers := PackedStringArray([
	StringUtils.format("Authorization: Bearer {}", api_key),
])
var response := await HttpHelper.async_post(base_url, JsonUtils.object_to_json(request), headers)
```

仓库里的手工测试也是这一条路径。按钮按下，问一句，空回复就记错误：

```gdscript
func on_chat_pressed() -> void:
	var text := await OpenAiClient.async_chat("用一句话介绍 godot-framework")
	if StringUtils.is_blank(text):
		Log.error("OpenAI returned empty text")
		return
	Log.info("OpenAI reply:[{}]", text)
	pass
```

把 Tank Agent 的两条命令换成 `ROLE_USER` 的内容，并不需要另一套聊天协议。难的是命令落地之后：找路、选最近敌人、不误伤基地、有人靠近鹰就拦截。那是游戏逻辑，框架只负责把「你写的那一行」送出去、把回复拿回来。

源码开头写得很清楚：这是本地开发用法，上线前要换成后端代理，别把密钥塞进客户端。`api_key` 为空会直接打错误日志并返回空字符串。框架仓库：https://github.com/godot-fun/godot-framework

## 你可以先写哪一条

如果只试一句，我会先写第二条：守护老鹰，敌人靠近时主动拦截。规则短，对错一眼能看出来。吉普贴过来，浅绿车转不转身，比「优先寻找增益」好验证。

第一条更贪。增益、最近敌人、别打到基地，三条挤在一句里。写完之后你得盯着：它是先去箱子，还是先开火；炮弹有没有擦到鹰。

三十五关、倒计时、六辆编制、红精英和四炮 Boss，都还在。变的是你不必只靠方向键说话。

打开 AI TANK。写下第一条命令。看看你的坦克听不听得懂。
