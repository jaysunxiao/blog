extends SceneTree

# 全局作用域
var global_variable = 10

func test_local_scope():
    # 局部作用域
    var local_variable = 20
    print(local_variable)


class MyClass:
    # 对象作用域
    var object_variable = 30

    func test_object_scope():
        print(object_variable)

# 参数作用域
func test_parameter_scope(parameter):
    print(parameter)


# 闭包作用域
func make_counter():
    var count = 0
    return func():
        count += 1
        print(count)


func _init():
    var a = 1
    var b = 2
    var c = add_numbers(a, b)
    print(c)

    print_message()
    quit()


func add_numbers(a: int, b: int) -> int:
    var result = a + b
    return result


func print_message() -> void:
    var message = "Hello, world!"
    print(message)
    print(global_variable)
    pass



