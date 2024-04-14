extends SceneTree

func _init():
    print("Hello World!")

    var garfield = CuteCat.new("Garfield", 2, "orange")
    garfield.speak("Hello, I'm Garfield!")
    garfield.think("I should take a nap.")

    quit()



class CuteCat:

    var name: String
    var age: int
    var color: String

    # self / this / this指针
    func _init(name: String, age: int, color: String):
        self.name = name
        self.age = age
        self.color = color

    func speak(message: String) -> void:
        print(self.name + " says: " + message)

    func think(idea: String) -> void:
        print(self.name + " is thinking: " + idea)

