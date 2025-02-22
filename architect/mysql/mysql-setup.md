# 1.安装MySQL
- 运行直接安装，选择服务端开发方式，密码：123456
- 配置系统环境变量PATH，C:\Program Files\MySQL\MySQL Server 5.5\bin

# 2.修改配置
mysql安装目录下有一个my.init配置文件，修改配置为下面的配置
```
character-set-server=utf8
默认用MyISAM数据库存储引擎，
default-storage-engine=INNODB
```

# 3.安装MySQL的界面工具navicat，直接默认安装即可