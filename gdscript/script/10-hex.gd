extends SceneTree

func _init():
    # 十进制定义
    var a = 15
    # 十六进制的定义
    var b = 0xF
    print(a)
    print(b)
    print(int_to_binary_str(a))
    print(int_to_binary_str(b))
    print("Hello World!")
    quit()


# 将整数转为二进制字符串
func int_to_binary_str(number: int) -> String:
    var binary_str = ""

    for i in range(64):
        var num = (number >> i) & 0b00000001
        binary_str = String.num_int64(num) + binary_str

    return binary_str
