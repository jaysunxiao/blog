extends SceneTree

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
    pass