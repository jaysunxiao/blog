# Jvm命令

##一、jps
- java -XX:+PrintFlagsInitial，查看jvm全部参数的默认值
- java -XX:+PrintFlagsFinal -version ，打印所有的启动参数
```
jps             # 查看本机全部的java进程
jps -l          # l:输出主类的全名
                # v：输出jvm启动时的参数
                # m：启动这个java程序传入main方法中的参数
```

##二、jstat
- jstat -class 15485        #类加载统计
```
Loaded:加载class的数量
Bytes：所占用空间大小
Unloaded：未加载数量
Bytes:未加载占用空间
Time：时间
```

- jstat -compiler 15485     #编译统计
```
Compiled：编译数量。
Failed：失败数量
Invalid：不可用数量
Time：时间
FailedType：失败类型
FailedMethod：失败的方法
```

- jstat -gccapacity 15485   #堆内存统计
```
 NGCMN    NGCMX     NGC     S0C   S1C       EC      OGCMN      OGCMX       OGC         OC       MCMN     MCMX      MC     CCSMN    CCSMX     CCSC    YGC    FGC 
171008.0 2732032.0  45568.0 2048.0 2048.0  41472.0   343040.0  5464064.0   343040.0   343040.0      0.0 1058816.0  11264.0      0.0 1048576.0   1280.0    270     0


NGCMN：新生代最小容量
NGCMX：新生代最大容量
NGC：当前新生代容量
S0C：第一个幸存区大小
S1C：第二个幸存区的大小
EC：伊甸园区的大小
OGCMN：老年代最小容量
OGCMX：老年代最大容量
OGC：当前老年代大小
OC:当前老年代大小
MCMN:最小元数据容量
MCMX：最大元数据容量
MC：当前元数据空间大小
CCSMN：最小压缩类空间大小
CCSMX：最大压缩类空间大小
CCSC：当前压缩类空间大小
YGC：年轻代gc次数
FGC：老年代GC次数
```

- jstat -gcnewcapacity 15485    #新生代内存统计
```
  NGCMN      NGCMX       NGC      S0CMX     S0C     S1CMX     S1C       ECMX        EC      YGC   FGC 
  171008.0  2732032.0    45568.0 910336.0   2048.0 910336.0   2048.0  2731008.0    41472.0   270     0

NGCMN：新生代最小容量
NGCMX：新生代最大容量
NGC：当前新生代容量
S0CMX：最大幸存1区大小
S0C：当前幸存1区大小
S1CMX：最大幸存2区大小
S1C：当前幸存2区大小
ECMX：最大伊甸园区大小
EC：当前伊甸园区大小
YGC：年轻代垃圾回收次数
FGC：老年代回收次数
```

- jstat -gcoldcapacity 15485    #老年代内存统计
```
   OGCMN       OGCMX        OGC         OC       YGC   FGC    FGCT     GCT   
   343040.0   5464064.0    343040.0    343040.0   270     0    0.000    2.022
```

- jstat -gcnew 15485
```
 S0C    S1C    S0U    S1U   TT MTT  DSS      EC       EU     YGC     YGCT  
2048.0 2048.0 1504.0    0.0  1  15 2048.0  41472.0  39884.8    270    2.022

S0C：第一个幸存区大小
S1C：第二个幸存区的大小
S0U：第一个幸存区的使用大小
S1U：第二个幸存区的使用大小
TT:对象在新生代存活的次数
MTT:对象在新生代存活的最大次数
DSS:期望的幸存区大小
EC：伊甸园区的大小
EU：伊甸园区的使用大小
YGC：年轻代垃圾回收次数
YGCT：年轻代垃圾回收消耗时间
```

- jstat -gc 15485 250 20    #垃圾回收统计，每250ms查询一次进程15485垃圾收集状况，一共查询20次，输出入下图：
```
 S0C    S1C    S0U    S1U      EC       EU        OC         OU       MC     MU    CCSC   CCSU   YGC     YGCT    FGC    FGCT     GCT   
2048.0 2048.0 1504.0  0.0   41472.0  34921.6   343040.0   211208.3  11264.0 10851.5 1280.0 1194.9    270    2.022   0      0.000    2.022
2048.0 2048.0 1504.0  0.0   41472.0  34921.6   343040.0   211208.3  11264.0 10851.5 1280.0 1194.9    270    2.022   0      0.000    2.022
2048.0 2048.0 1504.0  0.0   41472.0  34921.6   343040.0   211208.3  11264.0 10851.5 1280.0 1194.9    270    2.022   0      0.000    2.022
2048.0 2048.0 1504.0  0.0   41472.0  34921.6   343040.0   211208.3  11264.0 10851.5 1280.0 1194.9    270    2.022   0      0.000    2.022
2048.0 2048.0 1504.0  0.0   41472.0  34921.6   343040.0   211208.3  11264.0 10851.5 1280.0 1194.9    270    2.022   0      0.000    2.022
2048.0 2048.0 1504.0  0.0   41472.0  34921.6   343040.0   211208.3  11264.0 10851.5 1280.0 1194.9    270    2.022   0      0.000    2.022
2048.0 2048.0 1504.0  0.0   41472.0  34921.6   343040.0   211208.3  11264.0 10851.5 1280.0 1194.9    270    2.022   0      0.000    2.022
2048.0 2048.0 1504.0  0.0   41472.0  34921.6   343040.0   211208.3  11264.0 10851.5 1280.0 1194.9    270    2.022   0      0.000    2.022
2048.0 2048.0 1504.0  0.0   41472.0  34921.6   343040.0   211208.3  11264.0 10851.5 1280.0 1194.9    270    2.022   0      0.000    2.022
2048.0 2048.0 1504.0  0.0   41472.0  34921.6   343040.0   211208.3  11264.0 10851.5 1280.0 1194.9    270    2.022   0      0.000    2.022
2048.0 2048.0 1504.0  0.0   41472.0  34921.6   343040.0   211208.3  11264.0 10851.5 1280.0 1194.9    270    2.022   0      0.000    2.022
2048.0 2048.0 1504.0  0.0   41472.0  34921.6   343040.0   211208.3  11264.0 10851.5 1280.0 1194.9    270    2.022   0      0.000    2.022
2048.0 2048.0 1504.0  0.0   41472.0  34921.6   343040.0   211208.3  11264.0 10851.5 1280.0 1194.9    270    2.022   0      0.000    2.022
2048.0 2048.0 1504.0  0.0   41472.0  34921.6   343040.0   211208.3  11264.0 10851.5 1280.0 1194.9    270    2.022   0      0.000    2.022
2048.0 2048.0 1504.0  0.0   41472.0  34921.6   343040.0   211208.3  11264.0 10851.5 1280.0 1194.9    270    2.022   0      0.000    2.022
2048.0 2048.0 1504.0  0.0   41472.0  34921.6   343040.0   211208.3  11264.0 10851.5 1280.0 1194.9    270    2.022   0      0.000    2.022
2048.0 2048.0 1504.0  0.0   41472.0  34921.6   343040.0   211208.3  11264.0 10851.5 1280.0 1194.9    270    2.022   0      0.000    2.022
2048.0 2048.0 1504.0  0.0   41472.0  34921.6   343040.0   211208.3  11264.0 10851.5 1280.0 1194.9    270    2.022   0      0.000    2.022
2048.0 2048.0 1504.0  0.0   41472.0  34921.6   343040.0   211208.3  11264.0 10851.5 1280.0 1194.9    270    2.022   0      0.000    2.022
2048.0 2048.0 1504.0  0.0   41472.0  34921.6   343040.0   211208.3  11264.0 10851.5 1280.0 1194.9    270    2.022   0      0.000    2.022
```
```
S0C：第一个幸存区的大小
S1C：第二个幸存区的大小
S0U：第一个幸存区的使用大小
S1U：第二个幸存区的使用大小
EC：伊甸园区的大小
EU：伊甸园区的使用大小
OC：老年代大小
OU：老年代使用大小
MC：方法区大小
MU：方法区使用大小
CCSC:压缩类空间大小
CCSU:压缩类空间使用大小
YGC：年轻代垃圾回收次数
YGCT：年轻代垃圾回收消耗时间
FGC：老年代垃圾回收次数
FGCT：老年代垃圾回收消耗时间
GCT：垃圾回收消耗总时间
```

- jstat -gcutil 15485       #总结垃圾回收统计
```
  S0     S1     E      O      M     CCS    YGC     YGCT    FGC    FGCT     GCT   
 73.44   0.00  98.17  61.57  96.34  93.36    270    2.022     0    0.000    2.022
 
S0：幸存1区当前使用比例
S1：幸存2区当前使用比例
E：伊甸园区使用比例
O：老年代使用比例
M：元数据区使用比例
CCS：压缩使用比例
YGC：年轻代垃圾回收次数
FGC：老年代垃圾回收次数
FGCT：老年代垃圾回收消耗时间
GCT：垃圾回收消耗总时间
```

##三、jmap
- jmap -heap pid        #展示pid的整体堆信息
```
新生代的内存回收就是采用空间换时间的方式；
如果from区使用率一直是100% 说明程序创建大量的短生命周期的实例，使用jstat统计一下jvm在内存回收中发生的频率耗时以及是否有full gc，
使用这个数据来评估一内存配置参数、gc参数是否合理；


Heap Configuration: #堆内存初始化配置
   MinHeapFreeRatio = 40     #-XX:MinHeapFreeRatio设置JVM堆最小空闲比率  
   MaxHeapFreeRatio = 70   #-XX:MaxHeapFreeRatio设置JVM堆最大空闲比率  
   MaxHeapSize = 100663296 (96.0MB)   #-XX:MaxHeapSize=设置JVM堆的最大大小
   NewSize = 1048576 (1.0MB)     #-XX:NewSize=设置JVM堆的‘新生代’的默认大小
   MaxNewSize = 4294901760 (4095.9375MB) #-XX:MaxNewSize=设置JVM堆的‘新生代’的最大大小
   OldSize = 4194304 (4.0MB)  #-XX:OldSize=设置JVM堆的‘老生代’的大小
   NewRatio = 2    #-XX:NewRatio=:‘新生代’和‘老生代’的大小比率
   SurvivorRatio = 8  #-XX:SurvivorRatio=设置年轻代中Eden区与Survivor区的大小比值
   PermSize = 12582912 (12.0MB) #-XX:PermSize=<value>:设置JVM堆的‘持久代’的初始大小  
   MaxPermSize = 67108864 (64.0MB) #-XX:MaxPermSize=<value>:设置JVM堆的‘持久代’的最大大小  
Heap Usage:
New Generation (Eden + 1 Survivor Space): #新生代区内存分布，包含伊甸园区+1个Survivor区
   capacity = 30212096 (28.8125MB)
   used = 27103784 (25.848182678222656MB)
   free = 3108312 (2.9643173217773438MB)
   89.71169693092462% used
Eden Space: #Eden区内存分布
   capacity = 26869760 (25.625MB)
   used = 26869760 (25.625MB)
   free = 0 (0.0MB)
   100.0% used
From Space: #其中一个Survivor区的内存分布
   capacity = 3342336 (3.1875MB)
   used = 234024 (0.22318267822265625MB)
   free = 3108312 (2.9643173217773438MB)
   7.001809512867647% used
To Space: #另一个Survivor区的内存分布
   capacity = 3342336 (3.1875MB)
   used = 0 (0.0MB)
   free = 3342336 (3.1875MB)
   0.0% used
tenured generation:   #当前的Old区内存分布  
   capacity = 67108864 (64.0MB)
   used = 67108816 (63.99995422363281MB)
   free = 48 (4.57763671875E-5MB)
   99.99992847442627% used
Perm Generation:     #当前的 “持久代” 内存分布
   capacity = 14417920 (13.75MB)
   used = 14339216 (13.674942016601562MB)
   free = 78704 (0.0750579833984375MB)
   99.45412375710227% used
   


根据打印的结果：默认存活区与eden比率=2：8
1）查看eden区：225M
2）两个存活区大小：都为37.5M
3）年轻代大小：300M
4）老年代大小：400M
5）持久代大小：100M
6）最大堆内存大小：年轻代大小+老年代大小=700M
7）java应用程序占用内存大小：最大堆内存大小+持久代大小=700M+100M=800M

对应java参数（在tomcat的启动文件里）配置如下：

 JAVA_OPTS="-Xms700m -Xmx700m -Xmn300m -Xss1024K -XX:PermSize=100m -XX:MaxPermSize=100 -XX:+UseParallelGC -XX:ParallelGCThreads=1 -XX:+PrintGCTimeStamps
 -XX:+PrintGCDetails -Xloggc:/opt/logs/gc.log -verbose:gc -XX:+DisableExplicitGC"
 
各参数意义：
Xms
Xmx
Xmn
Xss
-XX:PermSize
-XX:MaxPermSize
NewRatio = 2   表示新生代（e+2s）：老年代（不含永久区）=1：2，指新生代占整个堆的1/3
SurvivorRatio = 8  表示2个S：eden=2：8，一个S占年轻代的1/10
```

- jmap -histo pid           #展示class的内存情况
```
num 	  #instances	#bytes	Class description
--------------------------------------------------------------------------
1:		650636	60380984	java.util.HashMap$Node[]
2:		680292	32654016	java.util.HashMap
3:		522736	29273216	java.util.HashMap$TreeNode
4:		543474	17391168	java.util.HashMap$Node
5:		97977	16825744	byte[]
6:		654973	15719352	java.lang.Long
7:		26457	13064568	int[]
8:		680069	10881104	java.util.HashSet
9:		649428	10390848	org.apache.zookeeper.server.SessionTrackerImpl$SessionSet
10:		40083	3704336	char[]


#instance 是对象的实例个数 
#bytes 是总占用的字节数 
class name 对应的就是 Class 文件里的 class 的标识 
B 代表 byte
C 代表 char
D 代表 double
F 代表 float
I 代表 int
J 代表 long
Z 代表 boolean
前边有 [ 代表数组， [I 就相当于 int[]
对象用 [L+ 类名表示
```

- jmap -dump:format=b,file=idea.dumpfile 15485        #生成进程15485堆转储快照文件


##四、jstack
jstack -l 15485                 #跟踪进程15485并打印堆栈信息


##五、使用jitwatch分析JIT即时编译
### 1.没有运行时生成代码的分析方法
- 从github上下载源码，在idea中打开，用maven运行：mvn clean compile test exec:java
- 运行需要分析的程序，加上参数：-XX:+UnlockDiagnosticVMOptions -XX:+PrintCompilation -XX:+PrintInlining -XX:+PrintCodeCache -XX:+PrintCodeCacheOnCompilation -XX:+TraceClassLoading -XX:+LogCompilation -XX:LogFile=D:\jar\hotspot.log
- 使用jitwatch打开log开始分析

### 2.运行时生成代码的分析方法
- 有动态生成的代码，无法在jitwatch中查看，所以只能分析日志