#!/bin/bash
# 远程备份数据，rsync搭配sshd，本身就有加密
# 要使用rsync你必须要在你的服务器上面取得某个帐号使用权后， 并让该帐号可以不用密码即可登陆才行
# @author jaysunxiao
# @version 1.0
# @since 2018-1-22 14:16

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

remotedir="/home/backup/"
basedir="/backup/weekly"
host="127.0.0.1"
id="dmtsai"

# 下面为程序阶段！不需要修改喔！
rsync -av -e ssh ${basedir} ${id}@${host}:${remotedir}