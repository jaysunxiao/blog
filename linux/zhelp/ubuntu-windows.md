## 双系统安装

### Windows安装

- 必须先安装windows，后安装Ubuntu，这样的方式最简单

```
先安装Ubuntu的话，后安装的Windows会覆盖Ubuntu的启动项。
这是因为Windows的安装程序会覆盖硬盘上的主引导记录（MBR），并将Windows的引导程序设为默认启动项，这样在开机时只会看到Windows的启动界面，无法直接启动Ubuntu。
```

- 按照常规的方法安装Windows

- 给Ubuntu预留安装系统的空间
    - 如果都安装在一块磁盘上，需要在磁盘管理中给Linux压缩一部分空间
    - 双系统在两块磁盘的话，需要把另一块磁盘格式化便于后续安装Linux使用