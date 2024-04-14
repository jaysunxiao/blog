extends SceneTree

func _init():
    # 定义一个变量，表示道具类型
    var item_type = "potion"

    # 使用match语句模拟switch语句
    match item_type:
        "weapon":
            print("这是一个武器。")
        "armor":
            print("这是一件防具。")
        "potion":
            print("这是一瓶药水。")
        _:
            print("未知道具类型。")

    if item_type == "weapon":
        print("这是一个武器。")
    elif item_type == "armor":
        print("这是一件防具。")
    elif item_type == "potion":
        print("这是一瓶药水。")
    else:
        print("未知道具类型。")
    quit()