extends SceneTree

func _init():
    var a = 0b00000001
    var b = 0b00000011
    var c = a + b
    print(c)
    print("Hello World!")
    binaryNumber(c)
    quit()


func binaryNumber(value):
    var buffer = StreamPeerBuffer.new()
    buffer.put_64(value);
    buffer.seek(0)
    print(buffer.get_8())
    buffer.seek(1)
    print(buffer.get_8())
    buffer.seek(2)
    print(buffer.get_8())
    buffer.seek(3)
    print(buffer.get_8())
    buffer.seek(4)
    print(buffer.get_8())
    buffer.seek(5)
    print(buffer.get_8())
    buffer.seek(6)
    print(buffer.get_8())
    buffer.seek(7)
    print(buffer.get_8())