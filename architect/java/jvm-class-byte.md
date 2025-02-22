####javap
- javac Foo.java
```
public class Foo {
  private int tryBlock;
  private int catchBlock;
  private int finallyBlock;
  private int methodExit;

  public void test() {
    try {
      tryBlock = 0;
    } catch (Exception e) {
      catchBlock = 1;
    } finally {
      finallyBlock = 2;
    }
    methodExit = 3;
  }
}
```
- 编译过后，javap -p -v Foo
    - 第一个选项是 -p。默认情况下 javap 会打印所有非私有的字段和方法，当加了 -p 选项后，它还将打印私有的字段和方法。
    - 第二个选项是 -v。它尽可能地打印所有信息。如果你只需要查阅方法对应的字节码，那么可以用 -c 选项来替换 -v。
```
$ javac Foo.java
$ javap -p -v Foo
Classfile ../Foo.class
  Last modified ..; size 541 bytes
  MD5 checksum 3828cdfbba56fea1da6c8d94fd13b20d
  Compiled from "Foo.java"
public class Foo
  minor version: 0
  major version: 54
  flags: (0x0021) ACC_PUBLIC, ACC_SUPER
  this_class: #7                          // Foo
  super_class: #8                         // java/lang/Object
  interfaces: 0, fields: 4, methods: 2, attributes: 1
Constant pool:
   #1 = Methodref          #8.#23         // java/lang/Object."<init>":()V
   #2 = Fieldref           #7.#24         // Foo.tryBlock:I
   #3 = Fieldref           #7.#25         // Foo.finallyBlock:I
   #4 = Class              #26            // java/lang/Exception
   #5 = Fieldref           #7.#27         // Foo.catchBlock:I
   #6 = Fieldref           #7.#28         // Foo.methodExit:I
   #7 = Class              #29            // Foo
   #8 = Class              #30            // java/lang/Object
   #9 = Utf8               tryBlock
  #10 = Utf8               I
  #11 = Utf8               catchBlock
  #12 = Utf8               finallyBlock
  #13 = Utf8               methodExit
  #14 = Utf8               <init>
  #15 = Utf8               ()V
  #16 = Utf8               Code
  #17 = Utf8               LineNumberTable
  #18 = Utf8               test
  #19 = Utf8               StackMapTable
  #20 = Class              #31            // java/lang/Throwable
  #21 = Utf8               SourceFile
  #22 = Utf8               Foo.java
  #23 = NameAndType        #14:#15        // "<init>":()V
  #24 = NameAndType        #9:#10         // tryBlock:I
  #25 = NameAndType        #12:#10        // finallyBlock:I
  #26 = Utf8               java/lang/Exception
  #27 = NameAndType        #11:#10        // catchBlock:I
  #28 = NameAndType        #13:#10        // methodExit:I
  #29 = Utf8               Foo
  #30 = Utf8               java/lang/Object
  #31 = Utf8               java/lang/Throwable
{
  private int tryBlock;
    descriptor: I
    flags: (0x0002) ACC_PRIVATE

  private int catchBlock;
    descriptor: I
    flags: (0x0002) ACC_PRIVATE

  private int finallyBlock;
    descriptor: I
    flags: (0x0002) ACC_PRIVATE

  private int methodExit;
    descriptor: I
    flags: (0x0002) ACC_PRIVATE

  public Foo();
    descriptor: ()V
    flags: (0x0001) ACC_PUBLIC
    Code:
      stack=1, locals=1, args_size=1
         0: aload_0
         1: invokespecial #1                  // Method java/lang/Object."<init>":()V
         4: return
      LineNumberTable:
        line 1: 0

  public void test();
    descriptor: ()V
    flags: (0x0001) ACC_PUBLIC
    Code:
      stack=2, locals=3, args_size=1
         0: aload_0
         1: iconst_0
         2: putfield      #2                  // Field tryBlock:I
         5: aload_0
         6: iconst_2
         7: putfield      #3                  // Field finallyBlock:I
        10: goto          35
        13: astore_1
        14: aload_0
        15: iconst_1
        16: putfield      #5                  // Field catchBlock:I
        19: aload_0
        20: iconst_2
        21: putfield      #3                  // Field finallyBlock:I
        24: goto          35
        27: astore_2
        28: aload_0
        29: iconst_2
        30: putfield      #3                  // Field finallyBlock:I
        33: aload_2
        34: athrow
        35: aload_0
        36: iconst_3
        37: putfield      #6                  // Field methodExit:I
        40: return
      Exception table:
         from    to  target type
             0     5    13   Class java/lang/Exception
             0     5    27   any
            13    19    27   any
      LineNumberTable:
        line 9: 0
        line 13: 5
        line 14: 10
        line 10: 13
        line 11: 14
        line 13: 19
        line 14: 24
        line 13: 27
        line 14: 33
        line 15: 35
        line 16: 40
      StackMapTable: number_of_entries = 3
        frame_type = 77 /* same_locals_1_stack_item */
          stack = [ class java/lang/Exception ]
        frame_type = 77 /* same_locals_1_stack_item */
          stack = [ class java/lang/Throwable ]
        frame_type = 7 /* same */
}
SourceFile: "Foo.java"
```

- javap 的 -v 选项的输出分为几大块。
- 基本信息，涵盖了原 class 文件的相关信息。
```
class 文件的版本号（minor version: 0，major version: 54）(编译生成该 class 文件时所用的 JRE 版本)
该类的访问权限（flags: (0x0021) ACC_PUBLIC, ACC_SUPER），
该类（this_class: #7）以及父类（super_class: #8）的名字，
所实现接口（interfaces: 0）、字段（fields: 4）、方法（methods: 2）以及属性（attributes: 1）的数目。
这里属性指的是 class 文件所携带的辅助信息，比如该 class 文件的源文件的名称。
这类信息通常被用于 Java 虚拟机的验证和运行，以及 Java 程序的调试，一般无须深入了解。

Classfile ../Foo.class
Last modified ..; size 541 bytes
MD5 checksum 3828cdfbba56fea1da6c8d94fd13b20d
Compiled from "Foo.java"
public class Foo
minor version: 0
major version: 54
flags: (0x0021) ACC_PUBLIC, ACC_SUPER
this_class: #7                          // Foo
super_class: #8                         // java/lang/Object
interfaces: 0, fields: 4, methods: 2, attributes: 1
```
    
- 常量池，用来存放各种常量以及符号引用。
```
常量池中的每一项都有一个对应的索引（如 #1），并且可能引用其他的常量池项（#1 = Methodref #8.#23）。

Constant pool:
   #1 = Methodref          #8.#23         // java/lang/Object."<init>":()V
... 
   #8 = Class              #30            // java/lang/Object
...
  #14 = Utf8               <init>
  #15 = Utf8               ()V
...
  #23 = NameAndType        #14:#15        // "<init>":()V
...
  #30 = Utf8               java/lang/Object
举例来说，1 号常量池项是一个指向 Object 类构造器的符号引用。它是由另外两个常量池项所构成。
如果将它看成一个树结构的话，那么它的叶节点会是字符串常量，如下图所示。
```
![Image text](image/jvm-constant.png)

- 字段区域，用来列举该类中的各个字段。
```
这里最主要的信息便是该字段的类型（descriptor: I）以及访问权限（flags: (0x0002) ACC_PRIVATE）。
对于声明为 final 的静态字段而言，如果它是基本类型或者字符串类型，那么字段区域还将包括它的常量值。
Java 虚拟机同样使用了“描述符”（descriptor）来描述字段的类型。

  private int tryBlock;
    descriptor: I
    flags: (0x0002) ACC_PRIVATE
```

- 方法区域，用来列举该类中的各个方法。
```
除了方法描述符以及访问权限之外，每个方法还包括最为重要的代码区域（Code:)。
代码区域一开始会声明该方法中的操作数栈（stack=2）和局部变量数目（locals=3）的最大值，以及该方法接收参数的个数（args_size=1）。
注意这里局部变量指的是字节码中的局部变量，而非 Java 程序中的局部变量。
接下来则是该方法的字节码。每条字节码均标注了对应的偏移量（bytecode index，BCI），这是用来定位字节码的。
比如说偏移量为 10 的跳转字节码 10: goto 35，将跳转至偏移量为 35 的字节码 35: aload_0。

  public void test();
    descriptor: ()V
    flags: (0x0001) ACC_PUBLIC
    Code:
      stack=2, locals=3, args_size=1
         0: aload_0
...
        10: goto          35
...
        34: athrow
        35: aload_0
...
        40: return
      Exception table:
         from    to  target type
             0     5    13   Class java/lang/Exception
             0     5    27   any
            13    19    27   any
      LineNumberTable:
        line 9: 0
...
        line 16: 40
      StackMapTable: number_of_entries = 3
        frame_type = 77 /* same_locals_1_stack_item */
          stack = [ class java/lang/Exception ]
...

```

- 紧跟着的异常表（Exception table:）
```
异常表也会使用偏移量来定位每个异常处理器所监控的范围（由 from 到 to 的代码区域），以及异常处理器的起始位置（target）。
除此之外，它还会声明所捕获的异常类型（type）。其中，any 指代任意异常类型。
```

- 再接下来的行数表（LineNumberTable:）
```
行数表则是 Java 源程序到字节码偏移量的映射。如果你在编译时使用了 -g 参数（javac -g Foo.java），
那么这里还将出现局部变量表（LocalVariableTable:），展示 Java 程序中每个局部变量的名字、类型以及作用域。
    LocalVariableTable:
    Start  Length  Slot  Name   Signature
       14       5     1     e   Ljava/lang/Exception;
        0      41     0  this   LFoo;
```

- 最后则是字节码操作数栈的映射表（StackMapTable: number_of_entries = 3）
```
该表描述的是字节码跳转后操作数栈的分布情况，一般被 Java 虚拟机用于验证所加载的类，以及即时编译相关的一些操作，正常情况下，你无须深入了解。

```

- synchronized 代码块
```
当声明 synchronized 代码块时，编译而成的字节码将包含 monitorenter 和 monitorexit 指令。
这两种指令均会消耗操作数栈上的一个引用类型的元素（也就是 synchronized 关键字括号里的引用），作为所要加锁解锁的锁对象。

当执行 monitorenter 时，如果目标锁对象的计数器为 0，那么说明它没有被其他线程所持有。在这个情况下，Java 虚拟机会将该锁对象的持有线程设置为当前线程，并且将其计数器加 1。
在目标锁对象的计数器不为 0 的情况下，如果锁对象的持有线程是当前线程，那么 Java 虚拟机可以将其计数器加 1，否则需要等待，直至持有线程释放该锁。
当执行 monitorexit 时，Java 虚拟机则需将锁对象的计数器减 1。当计数器减为 0 时，那便代表该锁已经被释放掉了。

之所以采用这种计数器的方式，是为了允许同一个线程重复获取同一把锁。
举个例子，如果一个 Java 类中拥有多个 synchronized 方法，那么这些方法之间的相互调用，不管是直接的还是间接的，都会涉及对同一把锁的重复加锁操作。
因此，我们需要设计这么一个可重入的特性，来避免编程里的隐式约束。

轻量级锁
轻量级锁采用 CAS 操作，将锁对象的标记字段替换为一个指针，指向当前线程栈上的一块空间，存储着锁对象原本的标记字段。它针对的是多个线程在不同时间段申请同一把锁的情况。
你可能见到过深夜的十字路口，四个方向都闪黄灯的情况。由于深夜十字路口的车辆来往可能比较少，如果还设置红绿灯交替，那么很有可能出现四个方向仅有一辆车在等红灯的情况。
因此，红绿灯可能被设置为闪黄灯的情况，代表车辆可以自由通过，但是司机需要注意观察（个人理解，实际意义请咨询交警部门）。
当进行加锁操作时，Java 虚拟机会判断是否已经是重量级锁。如果不是，它会在当前线程的当前栈桢中划出一块空间，作为该锁的锁记录，并且将锁对象的标记字段复制到该锁记录中。
Java 虚拟机会尝试用 CAS（compare-and-swap）操作替换锁对象的标记字段。这里解释一下，CAS 是一个原子操作，它会比较目标地址的值是否和期望值相等，如果相等，则替换为一个新的值。
在对象内存布局那一篇中我曾经介绍了对象头中的标记字段（mark word）。它的最后两位便被用来表示该对象的锁状态。其中，00 代表轻量级锁，01 代表无锁（或偏向锁），10 代表重量级锁，11 则跟垃圾回收算法的标记有关。
当进行加锁操作时，Java 虚拟机会判断是否已经是重量级锁。如果不是，它会在当前线程的当前栈桢中划出一块空间，作为该锁的锁记录，并且将锁对象的标记字段复制到该锁记录中。
然后，Java 虚拟机会尝试用 CAS（compare-and-swap）操作替换锁对象的标记字段。这里解释一下，CAS 是一个原子操作，它会比较目标地址的值是否和期望值相等，如果相等，则替换为一个新的值。
如果不是 X…X01，那么有两种可能。第一，该线程重复获取同一把锁。此时，Java 虚拟机会将锁记录清零，以代表该锁被重复获取。第二，其他线程持有该锁。此时，Java 虚拟机会将这把锁膨胀为重量级锁，并且阻塞当前线程。

偏向锁
偏向锁只会在第一次请求时采用 CAS 操作，在锁对象的标记字段中记录下当前线程的地址。在之后的运行过程中，持有该偏向锁的线程的加锁操作将直接返回。它针对的是锁仅会被同一线程持有的情况。
如果说轻量级锁针对的情况很乐观，那么接下来的偏向锁针对的情况则更加乐观：从始至终只有一个线程请求某一把锁。
这就好比你在私家庄园里装了个红绿灯，并且庄园里只有你在开车。偏向锁的做法便是在红绿灯处识别来车的车牌号。如果匹配到你的车牌号，那么直接亮绿灯。
具体来说，在线程进行加锁时，如果该锁对象支持偏向锁，那么 Java 虚拟机会通过 CAS 操作，将当前线程的地址记录在锁对象的标记字段之中，并且将标记字段的最后三位设置为 101。


重量级锁
重量级锁会阻塞、唤醒请求加锁的线程。它针对的是多个线程同时竞争同一把锁的情况。Java 虚拟机采取了自适应自旋，来避免线程在面对非常小的 synchronized 代码块时，仍会被阻塞、唤醒的情况。
我们可以用等红绿灯作为例子。Java 线程的阻塞相当于熄火停车，而自旋状态相当于怠速停车。如果红灯的等待时间非常长，那么熄火停车相对省油一些；
如果红灯的等待时间非常短，比如说我们在 synchronized 代码块里只做了一个整型加法，那么在短时间内锁肯定会被释放出来，因此怠速停车更加合适。

重量级锁是 Java 虚拟机中最为基础的锁实现。在这种状态下，Java 虚拟机会阻塞加锁失败的线程，并且在目标锁被释放的时候，唤醒这些线程。
Java 线程的阻塞以及唤醒，都是依靠操作系统来完成的。举例来说，对于符合 posix 接口的操作系统（如 macOS 和绝大部分的 Linux），
上述操作是通过 pthread 的互斥锁（mutex）来实现的。此外，这些操作将涉及系统调用，需要从操作系统的用户态切换至内核态，其开销非常之大。

为了尽量避免昂贵的线程阻塞、唤醒操作，Java 虚拟机会在线程进入阻塞状态之前，以及被唤醒后竞争不到锁的情况下，进入自旋状态，
在处理器上空跑并且轮询锁是否被释放。如果此时锁恰好被释放了，那么当前线程便无须进入阻塞状态，而是直接获得这把锁。
与线程阻塞相比，自旋状态可能会浪费大量的处理器资源。这是因为当前线程仍处于运行状况，只不过跑的是无用指令。它期望在运行无用指令的过程中，锁能够被释放出来。
自旋状态还带来另外一个副作用，那便是不公平的锁机制。处于阻塞状态的线程，并没有办法立刻竞争被释放的锁。然而，处于自旋状态的线程，则很有可能优先获得这把锁。





  public void foo(Object lock) {
    synchronized (lock) {
      lock.hashCode();
    }
  }
  // 上面的 Java 代码将编译为下面的字节码
  public void foo(java.lang.Object);
    Code:
       0: aload_1
       1: dup
       2: astore_2
       3: monitorenter
       4: aload_1
       5: invokevirtual java/lang/Object.hashCode:()I
       8: pop
       9: aload_2
      10: monitorexit
      11: goto          19
      14: astore_3
      15: aload_2
      16: monitorexit
      17: aload_3
      18: athrow
      19: return
    Exception table:
       from    to  target type
           4    11    14   any
          14    17    14   any


```
![Image text](image/jvm-object-head.gif)
