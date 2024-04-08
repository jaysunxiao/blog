extends SceneTree

func _init():
    var a: String = "Hello World!"
    print(a)

    var b: String = "@GdScript"
    print(b)

    var c: String = a + b
    print(c)
    print(c[0])
    quit()
