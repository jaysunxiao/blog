## for和while循环结构

【什么是循环命令？】 https://www.bilibili.com/video/BV1Q4411T7ZT/?share_source=copy_web&vd_source=5dbf211eec08e51a4c6d136972063c73
【五分钟速学python:循环语句和条件语句的搭配办法】 https://www.bilibili.com/video/BV15E41157B3/?share_source=copy_web&vd_source=5dbf211eec08e51a4c6d136972063c73
【【计算机科学速成课】[40集全/精校] - Crash Course Computer Science】 https://www.bilibili.com/video/BV1EW411u7th/?p=12&share_source=copy_web&vd_source=5dbf211eec08e51a4c6d136972063c73


![img.png](image/img036.png)



-----------
> 问：GdScript中for循环如何使用


在GdScript中，可以使用for循环来遍历一个数组或者迭代一个范围。下面是几种常见的for循环的用法：

1. 遍历一个数组：

```gd
var my_array = [1, 2, 3, 4, 5]

for item in my_array:
    print(item)
```

输出：

```
1
2
3
4
5
```

2. 迭代一个范围：

```gd
for i in range(1, 6): # 迭代范围从1到5
    print(i)
```

输出：

```
1
2
3
4
5
```

3. 使用索引遍历数组：

```gd
var my_array = [1, 2, 3, 4, 5]

for i in range(my_array.size()):
    print(my_array[i])
```

输出：

```
1
2
3
4
5
```

请注意，在使用索引遍历数组时，可以使用`array.size()`来获取数组的长度。

这些是在GdScript中使用for循环的一些基本用法。根据需要可以进行适当的变形和扩展。


-----------
> 问：GdScript中for循环有哪些经典的教学案例


在GdScript中，有许多经典的教学案例可以帮助初学者理解和掌握for循环的使用。下面是一些常见的案例：

1. 打印数字序列：使用for循环打印出从1到10的数字序列。

```gd
for i in range(1, 11):
    print(i)
```

输出：

```
1
2
3
4
5
6
7
8
9
10
```

2. 计算数组元素之和：使用for循环遍历一个数组，并计算所有元素的和。

```gd
var my_array = [1, 2, 3, 4, 5]
var sum = 0

for item in my_array:
    sum += item

print(sum)
```

输出：

```
15
```

3. 绘制图案：使用for循环打印出一个特定的图案。

```gd
for i in range(1, 6):
    var line = ""

    for j in range(i):
        line += "*"

    print(line)
```

输出：

```
*
**
***
****
*****
```

4. 迭代二维数组：使用嵌套的for循环迭代一个二维数组，并打印出每个元素。

```gd
var my_array = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

for row in my_array:
    for item in row:
        print(item)
```

输出：

```
1
2
3
4
5
6
7
8
9
```

这些案例涵盖了for循环在GdScript中的使用情况。通过实践这些案例，可以更好地理解for循环的工作原理，并且能够在自己的项目中有效地应用它们。


-----------
> 问：GdScript中while循环如何使用


在GdScript中，while循环可以用来重复执行一段代码，直到指定的条件不再满足为止。下面是一个简单的示例，演示了如何使用while循环：

```gd
var count = 0

while count < 5:
    print("Count is:", count)
    count += 1
```

输出：

```
Count is: 0
Count is: 1
Count is: 2
Count is: 3
Count is: 4
```

在这个示例中，首先定义了一个变量`count`并初始化为0。然后使用while循环，当`count`小于5时，执行循环体内的代码。在每次循环中，会打印出当前的`count`值，并将`count`增加1。当`count`增加到5时，循环条件不再满足，循环结束。

与for循环不同，while循环在执行前不会确定循环的次数，而是在每次循环开始前检查条件是否满足。因此，while循环适用于那些循环次数不确定的情况。

要注意的是，如果循环条件一直为真，或者没有在循环体内更新循环条件导致循环无法结束，就会出现无限循环，这将导致程序执行异常。因此，在使用while循环时，务必确保循环条件能够最终变为假，以避免无限循环的发生。


-----------
> 问：GdScript中while循环有哪些经典的教学案例


在GdScript中，while循环可以用于许多经典的教学案例。以下是一些常见的例子：

1. 计算阶乘（factorial）：使用while循环来计算一个给定的正整数n的阶乘。例如：

```gd
var n = 5
var result = 1

while n > 0:
    result *= n
    n -= 1

print("Factorial of", n, "is", result)
```

输出：

```
Factorial of 5 is 120
```

这个例子使用while循环来计算n的阶乘，每次循环中将n减去1，然后将其与当前结果相乘。当n等于0时，停止循环并打印出结果。

2. 斐波那契数列：使用while循环来生成斐波那契数列。例如：

```gd
var n = 5
var result = [1, 1]

while n > 0:
    result.append(result[-1] + result[-2])
    n -= 1

print("Fibonacci sequence up to", n, "is:")
for i in range(len(result)):
    print(result[i], end=" ")
```

输出：

```
0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 1597 2584 4181 6765
```

这个例子使用while循环来生成斐波那契数列，每次循环中将当前结果与前一个结果相加。当n等于0时，停止循环并打印出结果。

3. 计算阶乘的递归方法：使用while循环和递归函数来计算一个给定的正整数n的阶乘。例如：

```gd
func factorial(n: int) -> int:
    if n == 0:
        return 1
    else:
        return n * factorial(n - 1)

var n = 5
print("Factorial of", n, "is", factorial(n))
```

输出：

```
Factorial of 5 is 120
```

这个例子使用递归函数来计算阶乘，当n等于0时返回1。然后使用while循环调用该函数并打印结果。


```text
在教学GdScript中的while循环时，通常会使用一些经典的案例来说明其用法和原理。以下是一些常见的教学案例：

1. **计数器**：像上面的示例一样，使用while循环来实现一个简单的计数器，让学生理解循环是如何工作的。比如，让学生编写一个程序，使用while循环从1开始打印数字，直到达到某个特定的数字。

2. **求和**：通过一个简单的示例，教学生如何使用while循环来计算一系列数字的总和。例如，让学生编写一个程序，使用while循环计算1到100的所有整数的和。

3. **猜数字游戏**：创建一个简单的猜数字游戏，使用while循环让玩家可以多次尝试猜测正确的数字。在每次猜测后，根据玩家的猜测给出提示，直到猜测正确为止。

4. **倒计时**：让学生编写一个倒计时程序，使用while循环来模拟倒计时功能。例如，从10开始倒计时，每秒打印出当前剩余的秒数，直到倒计时结束。

5. **斐波那契数列**：引导学生使用while循环来生成斐波那契数列的前几个数字。通过迭代的方式计算斐波那契数列，让学生了解循环的灵活性和功能。

这些案例涵盖了while循环的基本用法，可以帮助学生逐步理解循环结构的概念，并在实践中掌握其应用。
```