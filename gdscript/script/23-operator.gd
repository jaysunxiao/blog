extends SceneTree

func _init():
    # 算术运算符
    var a = 10
    var b = 3
    print(a + b)  # 输出：13
    print(a - b)  # 输出：7
    print(a * b)  # 输出：30
    print(a / b)  # 输出：3.3333
    print(a % b)  # 输出：1
    print("------------------------------------------------------------")

    # 比较运算符，比较运算符返回的结果是bool值
    var x = 5
    var y = 8
    print(x == y)  # 输出：false
    print(x != y)  # 输出：true
    print(x > y)   # 输出：false
    print(x < y)   # 输出：true
    print(x >= y)  # 输出：false
    print(x <= y)  # 输出：true
    print("------------------------------------------------------------")

    # 逻辑运算符
    var p = true
    var q = false
    print(p && q)  # 输出：false
    print(p || q)  # 输出：true
    print(!p)      # 输出：false
    print("------------------------------------------------------------")

    # 赋值运算符
    var m = 5
    # m = m +3
    m += 3
    print(m)  # 输出：8
    # m = m -2
    m -= 2
    print(m)  # 输出：6
    m *= 4
    print(m)  # 输出：24
    m /= 6
    print(m)  # 输出：4
    m %= 3
    print(m)  # 输出：1
    print("------------------------------------------------------------")

    # 位运算符
    # 0101，00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000101
    var num1 = 5
    # 0011
    var num2 = 3
    print(num1 & num2)  # 输出：1，0001
    print(num1 | num2)  # 输出：7，0111
    print(num1 ^ num2)  # 输出：6，0110
    print(~num1)        # 输出：-6，11111111_11111111_11111111_11111111_11111111_11111111_11111111_11111010
    print(num1 << 1)    # 输出：10，00000000_00000000_00000000_00000000_00000000_00000000_00000000_00001010
    print(num1 >> 1)    # 输出：2，00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000010
    print("------------------------------------------------------------")

    # 其他运算符
    var result = x if (x > y) else y
    #if (x > y):
    #    result = x
    #else:
    #    result = y
    print(result)  # 输出：8

    var obj = {"name": "John", "age": 30}
    print(obj.name)  # 输出：John
    print(obj.age)   # 输出：30
    quit()
