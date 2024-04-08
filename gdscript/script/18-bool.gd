extends SceneTree

func _init():
    # 定义输入变量
    var input1 = true
    var input2 = false

    # 逻辑与（AND）运算
    var result_and = input1 && input2
    print("逻辑与运算结果：", result_and) # 输出false

    # 逻辑或（OR）运算
    var result_or = input1 || input2
    print("逻辑或运算结果：", result_or) # 输出true

    # 逻辑非（NOT）运算
    var result_not = !input1
    print("逻辑非运算结果：", result_not) # 输出false
    quit()
