# git使用默认的安装
- git config --list

# 移除配置
- git config --global --unset xxx

# git启动配置
- git config --global user.name godotg
- git config --global user.name sun
- git config --global user.email jaysunxiao@gmail.com
- git config --global http.lowspeedlimit 0
- git config --global http.lowspeedtime 999999
- git config --global http.postBuffer 524288000  #如果还满足不了就翻倍

- git config --global --replace-all user.email jaysunxiao  #改变
- git config --global --unset  命名  #删除

- git gc --aggressive	#清理Git本地仓库。此命令对远程仓库不会产生任何影响。

# git下载代码慢的解决方法|无法下载代码的解决方法
- 使用vpn
```
git config --global http.proxy http://127.0.0.1:10809
git config --global https.proxy https://127.0.0.1:10809
```
- 更换host
```
在浏览器中打开DNS查询网站http://tool.chinaz.com/dns，我们输入github.com
选择TTL值小的IP地址192.30.255.113
C:\Windows\System32\drivers\etc目录，找到hosts文件
192.30.255.113 github.com
```

# git如何操作
## 首先在本地创建ssh key；
ssh-keygen -t rsa -C "your_email@youremail.com"

## 为了验证是否成功，在git bash下输入：
ssh -T git@github.com

## 配置一下你的身份，这样在提交代码的时候Git就可以知道是谁提交的了
git config --global user.name "jaysunxiao"
git config --global user.email "jaysunxiao@gmail.com"

## 进入要上传的仓库，右键git bash，添加远程地址：
git init
git remote add origin git@github.com:jaysunxiao/zfoo

## 提交流程
git add *
git commit -m "提交信息"

## 提交本地仓库的文件到服务器仓库
git push origin master

## 拉取远程服务器仓库的文件，pull=fetch + merge
git pull --rebase origin master

## Git是不跟踪空目录的，所以需要跟踪那么就需要添加文件！也就是说Git中不存在真正意义上的空目录.
