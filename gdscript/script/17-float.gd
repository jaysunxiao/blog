extends SceneTree

func _init():
    var a: int = 0b01111111_11111111_11111111_11111111_11111111_11111111_11111111_11111111
    var b: int = 9223372036854775807
    var c = a - b
    print(c)
    print("Hello World!")
    quit()
