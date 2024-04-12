@icon("res://icon.svg")

extends Node2D

# (optional) class definition with a custom icon
class_name MyClass

const StringUtils = preload("res://zfoo/util/StringUtils.gd")

# Member variables
# gds有5种基础类型，Boolean，Integer(Java long)，Float(Java double)，String，Null

# &&=and  ||=or  !=not
var a = (true or false) && true
var b = 9223372036854775807
var c = 1.5
var s = "Hello"
var arr = [1, 2, 3]
var dict = {
	2: 3,
	"key": "字符串作为key",
	arr: "数组作为key"
}
var typed_var: int
var typed_var_float: float
var typed_var_bool: bool
var inferred_type: String = "String"

# Constants
const ANSWER = 42
const THE_NAME = "Charly"
# Static filed
static var my_static_field = 42

# Enums

enum {LEFT, RRIGHT, FRONT, BACK}
# 等价于
# const LEFT = 0
# const RIGHT = 1
# const FRONT = 2
# const BACK = 3
enum FOOD {GOOD, NORMAL, BAD = -1}

# Built-in vector types

var v2 = Vector2(1, 2)
var v3 = Vector3(1, 2, 3)

func _init():
	print("调用了_init()构造器方法")
	pass

static func getAnswer():
	return ANSWER

func typeInfo():
	var template = "[Variant:{}] [type:{}] [value:{}]"
	print(StringUtils.format(template, [TYPE_BOOL, typeof(a), a]))
	print(StringUtils.format(template, [TYPE_INT, typeof(b), b]))
	print(StringUtils.format(template, [TYPE_INT, typeof(c), c]))
	print(StringUtils.format(template, [TYPE_STRING, typeof(s), s]))
	# print(StringUtils.format(template, [TYPE_ARRAY, typeof(arr), arr]))
	print(StringUtils.format(template, [TYPE_DICTIONARY, typeof(dict), dict]))
	print(StringUtils.format(template, [TYPE_DICTIONARY, typeof(FOOD), FOOD]))
	print(StringUtils.format(template, [TYPE_DICTIONARY, typeof(FOOD.GOOD), FOOD.GOOD]))
	# 在java中类似于this
	print(self is Node)
	print(a is Dog) # 类似于instanceof
	pass

func if_function(param1, param2):
	if param1 < param2:
		print(param1)
	elif param2 > 5:
		print(param2)
	else:
		print("Fail!")
	pass


func switch_function():
	var local_var = 5
		
	match local_var:
		1:
			print("match1")
		2:
			print("match2")
		5:
			print("match5")
			# continue
		6:
			print("match6")
		_:
			print("match_")
	pass


func loop_function():
	for i in range(20):
		print(i)
	var param = 10
	while param != 0:
		param -= 1
	return param

# Function
func arrayIterator():
	# range等价于for(int i = 0; i < 20; i++)
	print("数组遍历方法1：")
	for i in range(3):
		print(i)
	print("数组遍历方法2：")
	for ele in arr:
		print(ele)
	print("数组遍历方法3：")
	for index in range(arr.size()):
		print(arr[index])
	pass


func dictionaryIterator():
	print("字典遍历方法1：")
	for key in dict:
		print("key:" + str(key))
		print("value:" + str(dict[key]))
		
	print("字典遍历方法2：")
	for key in dict.keys():
		print("key:" + str(key))
		print("value:" + str(dict[key]))
		
	print("字典遍历方法3：")
	for value in dict.values():
		print("value:" + str(value))
	pass



func innerClassTest():
	var dog = Dog.new(1)
	dog.move()
	
	dog.info()
	dog.height = 2
	dog.info()
	pass

# Inner class，默认继承Object
class Animal:
	extends Object  # 如果不指定继承的类，默认基础Object
	const STATIC_FIELD = "静态变量"
	# 属性
	var height: int
	
	func _init():
		print("Animal 构造方法")
		
	func move():
		print("animal，移动")
	
	static func staticFuction():
		pass

class Dog: 
	extends Animal
	
	# Constructor
	func _init(_height):
		self.height = _height
		print("Dog 构造方法")
		pass
	
	# Functions override functions with the same name on the base/parent class.
	func move():
		print("dog，用4个脚跑")
		# If you still want to call them, use '.' (like 'super' in other languages).
		super.move()
		pass
		
	func info(_parm = 100):
		print("height：" + str(height))
		pass

