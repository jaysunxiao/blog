extends SceneTree

func _init():
    var myArray = [1, 2, 3, 4, 5] # 创建一个包含整数的数组
    # 访问元素
    print(myArray[0]) # 输出第一个元素1
    print(myArray[1]) # 输出第二个元素2
    print("--------------------------------------")
    # 添加元素
    myArray.append(6) # 将元素6添加到数组末尾
    print(myArray[5]) # 输出第二个元素2
    print("--------------------------------------")
    # 删除元素
    myArray.remove_at(0) # 删除第一个元素
    print(myArray[0])
    print("--------------------------------------")
    # 循环遍历数组，只做了解还没学到循环
    for element in myArray:
        print(element)
    quit()
