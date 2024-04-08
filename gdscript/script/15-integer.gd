extends SceneTree

func _init():
    # 这三行代码包含了整个计算机的基础知识，二进制，bit位，Byte表示，内存分配，cpu二进制加法，十进制，cpu加法将减法转为加法等于 c = a + (-b)
    var a: int = 0b01111111_11111111_11111111_11111111_11111111_11111111_11111111_11111111
    var b: int = 9223372036854775807
    var c = a - b   # 等于 c = a + (-b)
    print(c)
    print("Hello World!")
    quit()
