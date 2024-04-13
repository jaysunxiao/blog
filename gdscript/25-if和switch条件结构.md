## if和switch条件语句

【#编程通识#第九课，什么是条件语句】 https://www.bilibili.com/video/BV1R4411G7rH/?share_source=copy_web&vd_source=5dbf211eec08e51a4c6d136972063c73

【五分钟速学python:if条件语句】 https://www.bilibili.com/video/BV1eJ41187ek/?share_source=copy_web&vd_source=5dbf211eec08e51a4c6d136972063c73


![img.png](image/img035.png)

-----------
> 问：GdScript中if语句如何使用


> 在GdScript中，if语句用于检查条件是否为真。以下是一个简单的例子：
> ```gdscript
> var x = 5
> if (x > 3):
>     print("x is greater than 3")
> else:
>     print("x is not greater than 3")
> ```
> 在这个例子中，我们使用`if`语句来检查变量`x`是否大于3。如果条件为真，则执行`print("x is greater than 3")`；否则，执行`print("x is not greater than 3")`。
> 在GdScript中，可以使用多个条件进行比较和逻辑运算符（如`and`、`or`等）来创建更复杂的if语句。例如：
> ```gdscript
> var x = 5
> if (x > 3 and y < 10):
>     print("x is greater than 3 and y is less than 10")
> else:
>     print("x is not greater than 3 or y is not less than 10")
> ```
> 在这个例子中，我们使用`and`运算符来检查两个条件是否同时为真。如果条件都满足，则执行`print("x is greater than 3 and y is less than 10")`；否则，执行`print("x is not greater than 3 or y is not less than 10")`。
> 请注意，在GdScript中，if语句的缩进非常重要。如果缩进不正确，可能会导致语法错误或逻辑错误。请确保使用正确的缩进格式来编写你的if语句。



在Godot引擎中使用GDScript编写代码时，if语句用于执行条件分支。下面是一个简单的示例，演示了如何在GDScript中使用if语句：

```gdscript
# 示例代码
var health = 80

if health > 0:
    print("玩家还活着！")
elif health == 0:
    print("玩家已经死亡。")
else:
    print("健康值无效。")

# 示例中的if语句检查健康值是否大于0，如果是，则打印"玩家还活着！"。
# 如果健康值等于0，则打印"玩家已经死亡。"。
# 如果健康值不大于0，也不等于0，则打印"健康值无效。"。
```

在GDScript中，if语句的一般形式是：

```gdscript
if condition:
    # 如果条件为真，则执行此处的代码
elif another_condition:
    # 如果第一个条件为假，但第二个条件为真，则执行此处的代码
else:
    # 如果所有条件都为假，则执行此处的代码
```

在if语句中，你可以使用比较运算符（例如`>`，`<`，`==`等）和逻辑运算符（例如`and`，`or`，`not`）来构建条件表达式。


-----------
> 问：能给一些比较经典的if语句的教学案例吗


当然可以！以下是几个经典的if语句教学案例：

1. **检查奇偶数**：编写一个程序，判断用户输入的数字是奇数还是偶数，并输出相应的消息。

```python
num = int(input("请输入一个整数："))

if num % 2 == 0:
    print(num, "是偶数。")
else:
    print(num, "是奇数。")
```

2. **比较三个数大小**：编写一个程序，接受三个数字输入，并输出最大的数字。

```python
num1 = float(input("请输入第一个数字："))
num2 = float(input("请输入第二个数字："))
num3 = float(input("请输入第三个数字："))

if num1 >= num2 and num1 >= num3:
    print("最大的数字是：", num1)
elif num2 >= num1 and num2 >= num3:
    print("最大的数字是：", num2)
else:
    print("最大的数字是：", num3)
```

3. **成绩等级划分**：编写一个程序，接受学生的分数输入，并根据分数输出对应的等级。

```python
score = float(input("请输入学生的分数："))

if score >= 90:
    print("等级：A")
elif score >= 80:
    print("等级：B")
elif score >= 70:
    print("等级：C")
elif score >= 60:
    print("等级：D")
else:
    print("等级：F")
```

4. **简单登录系统**：编写一个简单的登录系统，用户输入用户名和密码，如果用户名和密码与预设值匹配则登录成功，否则登录失败。

```python
username = input("请输入用户名：")
password = input("请输入密码：")

# 假设预设的用户名和密码分别为 "admin" 和 "password123"
if username == "admin" and password == "password123":
    print("登录成功！")
else:
    print("登录失败，请检查用户名和密码。")
```

这些案例涵盖了if语句在不同场景下的应用，可以帮助初学者更好地理解和掌握条件语句的使用。




> 当然可以！以下是一个比较经典的if语句的教学案例：
> 
> ```gdscript
> # 示例代码
> var x = 5
> var y = 10
> 
> if x > y:
>     print("x大于y")
> elif x == y:
>     print("x等于y")
> else:
>     print("x小于y")
> 
> # 在上述例子中，我们使用比较运算符`>`来检查变量x是否大于变量y。如果条件为真，则执行if语句中的代码块，并打印"x大于y"；否则，会跳转到elif语句进行判断。
> ```
> 
> 你可以根据你的需求和目标创建其他类型的教学案例，以帮助你更好地理解如何使用if语句在GDScript中编写代码。



-----------
> 问：GdScript中switch语句如何使用


> 在GdScript中，switch语句用于根据条件选择执行不同的代码块。以下是一个简单的示例：
> 
> ```gdscript
> func main() -> void:
>     var choice = input("请选择1或2：")
>     
>     switch(choice):
>         case "1":
>             print("选择了1！")
>             break
>         case "2":
>             print("选择了2！")
>             break
> ```
> 
> 在这个例子中，我们使用input函数获取用户的选择。然后，我们将选择作为参数传递给switch语句的条件表达式。在每个case块中，我们可以执行不同的代码来处理不同选择的情况。
> 
> 请注意，GdScript中的switch语句与C语言等其他编程语言中的switch语句有所不同。在GdScript中，我们使用“==”运算符进行比较，而不是使用“=”运算符。此外，GdScript的switch语句只能用于字符串比较，而不能用于数值或布尔值的比较。
> 
> 希望这个示例能够帮助你理解和使用GdScript中的switch语句！


在Godot游戏引擎中，GDScript是一种用于编写游戏逻辑的脚本语言，它类似于Python。GDScript中没有内置的switch语句，但是你可以使用多个elif语句来模拟switch的功能。下面是一个简单的示例，演示了如何在GDScript中使用多个elif语句来实现类似于switch语句的功能：

```gd
# 定义一个变量，表示道具类型
var item_type = "potion"

# 使用if-elif语句模拟switch语句
if item_type == "weapon":
    print("这是一个武器。")
elif item_type == "armor":
    print("这是一件防具。")
elif item_type == "potion":
    print("这是一瓶药水。")
else:
    print("未知道具类型。")
```

在这个示例中，根据item_type的不同取值，程序会输出相应的消息。如果item_type的值不匹配任何条件，最后的else分支将被执行。

虽然GDScript没有像其他语言一样的switch语句，但是使用多个elif语句可以达到相同的效果。


-----------
> 问：GdScript中有switch语句


> 在Godot游戏引擎中，GDScript是一种用于编写游戏逻辑的脚本语言，它类似于Python。然而，GDScript中没有内置的switch语句。
> 
> 虽然GDScript没有像其他语言一样的switch语句，但是你可以使用多个elif语句来模拟switch的功能。下面是一个简单的示例，演示了如何在GDScript中使用多个elif语句来实现类似于switch语句的功能：
> 
> ```gd
> # 定义一个变量，表示道具类型
> var item_type = "potion"
> 
> if item_type == "weapon":
>     print("这是一个武器。")
> elif item_type == "armor":
>     print("这是一件防具。")
> elif item_type == "potion":
>     print("这是一瓶药水。")
> else:
>     print("未知道具类型。")
> ```
> 
> 在这个示例中，根据item_type的不同取值，程序会输出相应的消息。如果item_type的值不匹配任何条件，最后的else分支将被执行。
> 
> 虽然GDScript没有像其他语言一样的switch语句，但是使用多个elif语句可以达到相同的效果。


在GDScript中，尽管没有内置的switch语句，但可以使用match语句来实现类似于switch的功能。下面是使用match语句的示例：

```gd
# 定义一个变量，表示道具类型
var item_type = "potion"

# 使用match语句模拟switch语句
match item_type:
    "weapon":
        print("这是一个武器。")
    "armor":
        print("这是一件防具。")
    "potion":
        print("这是一瓶药水。")
    _:
        print("未知道具类型。")
```

在这个示例中，match语句将item_type的值与不同的模式进行匹配。如果匹配成功，则执行相应模式下的代码；如果没有匹配成功，则执行下划线(_)模式下的代码，即默认情况。

相比使用多个elif语句，match语句在语法上更加简洁和清晰，是GDScript中推荐的模拟switch语句的方法。



-----------
> 问：厉害了，你既然知道GdScript没有switch而有match语句


```text
嗯，是的！GDScript中虽然没有内置的switch语句，但使用match语句可以很方便地模拟出类似的功能。match语句可以让代码更加清晰易读，并且在处理多个条件时更加简洁。如果你对GDScript还有其他疑问或者需要帮助的地方，随时告诉我！
```

```text
是的，match语句在GDScript中提供了类似于switch的功能。它可以根据给定条件进行匹配和执行相应的代码块。与switch相比，match语句更加简洁且易于理解。
```