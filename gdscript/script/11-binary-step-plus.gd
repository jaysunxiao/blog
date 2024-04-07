extends SceneTree

func _init():
    # 二进制定义
    var a = 0b00000000
    print(int_to_binary_str(a))
    # 10进制1的二进制也是0001
    a = a + 1
    print(int_to_binary_str(a))
    a = a + 1
    print(int_to_binary_str(a))
    a = a + 1
    print(int_to_binary_str(a))
    a = a + 1
    print(int_to_binary_str(a))
    print("Hello World!")
    quit()


# 将整数转为二进制字符串
func int_to_binary_str(number: int) -> String:
    var binary_str = ""

    for i in range(64):
        var num = (number >> i) & 0b00000001
        binary_str = String.num_int64(num) + binary_str

    return binary_str
