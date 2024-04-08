extends SceneTree

func _init():
    var a = 0b00000001
    var b = 0b00000011
    var c = a + b
    print(c)
    print(int_to_binary_str(c))
    print("Hello World!")
    quit()


# 将整数转为二进制字符串
func int_to_binary_str(number: int) -> String:
    var binary_str = ""

    for i in range(64):
        var num = (number >> i) & 0b00000001
        binary_str = String.num_int64(num) + binary_str

    return binary_str
