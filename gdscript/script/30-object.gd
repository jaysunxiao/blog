extends SceneTree

func _init():
    # 实例化一个Dog对象并调用方法
    var dog = Dog.new("Buddy")
    dog.make_sound() # 输出 Woof! Woof!
    quit()



# 定义一个父类
class Animal:
    var name

    func _init(name):
        self.name = name

    func make_sound():
        print(self.name + ": Ha! Ha!")
        pass

# 定义一个子类，继承自Animal类
class Dog extends Animal:
    # 重写
    func make_sound():
        print(self.name + ": Woof! Woof!")
        pass