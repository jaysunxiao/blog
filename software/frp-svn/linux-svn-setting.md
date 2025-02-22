### Linux svn

- 安装svn
```
yum install subversion
```

- svn客户端的用法
```
svn checkout svn://your_svn_repository --username your_username --password your_password
```

- 查看是否安装成功，可以查看版本
```
svnserve --version
```

- 配置，创建仓库
```
mkdir /svn
svnadmin create /svn
```

- conf:存放配置文件的
```
authz 权限配置文件，控制读写权限
passwd 账号密码配置文件
svnserve.conf svn服务器配置文件
```

- 配置passwd
```
[root@localhost conf]# vim passwd 
[users]
admin = 123456
test = 123456

# 上面的例子中我们创建了2个用户，一个admin，一个test，建议等号前后加一个空格
```

- 配置authz
```
[root@localhost conf]# vim authz 
[/]
admin = rw
test = r
* =

# 上面配置的含义是，admin对/svn下所有文件具有可读可写权限，
# test只有只读权限，除此之外，其它用户均无任何权限
# 最后一行*=很重要不能少，表示对其他人不可见既没有读写权限
```

- 配置svnserve.conf
```
[root@localhost conf]# vim svnserve.conf 
打开下面的5个注释
anon-access = none # 非授权用户的访问级别，匿名用户不可见
auth-access = write # 授权用户的访问级别，授权用户可写
password-db = passwd # 使用哪个文件作为账号密码数据库文件，相对仓库中 conf 目录的位置，也可以设置为绝对路径
authz-db = authz # 权限配置文件，相对仓库中 conf 目录的位置，也可以设置为绝对路径
realm = zfoo project # 认证空间名，版本库的认证域，即在登录时提示的认证域名称

# none 表示无访问权限，read 表示只读，write 表示可读可写，默认为 read。
```


- 启动与停止
```
# 启动
svnserve -d -r /data/svnzp

# 停止
killall svnserve
```


- 进阶的用户分组配置
```
[root@localhost conf]# vim authz
[groups]
group1 = admin,a,aa,aaa
group2 = test,b,bb
[/]
@group1 = rw
@group2 = r
* =

# 上面配置中创建了2个分组，分组1的用户可读可写，分组2的用户只读。
```

- [svn迁移1](https://blog.csdn.net/shangdi1988/article/details/125084792)
- [svn迁移2](https://www.jianshu.com/p/98e65ac0c02f)