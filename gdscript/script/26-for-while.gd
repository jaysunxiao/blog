extends SceneTree

func _init():
    # 遍历一个数组
#    var my_array = [1, 2, 3, 4, 5]
#
#    for item in my_array:
#        print(item)

    # 迭代一个范围
#    for i in range(1, 6): # 迭代范围从1到5
#        print(i)


    # 使用索引遍历数组
#    var my_array = [1, 2, 3, 4, 5]
#    var arraySize = my_array.size()
#    for i in range(arraySize):
#        print(my_array[i])

    # 二维数组的遍历
#    var my_array = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
#
#    for row in my_array:
#        for item in row:
#            print(item)

#    var count = 0
#    while count < 5:
#        print("Count is:", count)
#        count += 1

    var count = 0
    for i in range(10000):
        if i % 3 == 0:
            count += 1
            continue
        print(i)
    quit()