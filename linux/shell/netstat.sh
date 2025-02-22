#!/bin/bash
# Using netstat and grep to detect WWW,SSH,FTP and Mail services.
# 检查Linux服务器上是否启动WWW，SSH，FTP，Mail服务
# @author jaysunxiao
# @version 1.0
# @since 2018-1-15 10:39
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
# 1. 先作一些提示信息
echo "Now, I will detect your Linux server's services!"
echo -e "The www, ftp, ssh, and mail will be detect! \n"

# 2. 开始做一些测试的工作，并且输出一些信息！
testing=$(netstat -tuln | grep ":80 ") # 侦测看 port 80 在否？

if [ "${testing}" != "" ]; then
echo "WWW is running in your system."
fi

testing=$(netstat -tuln | grep ":22 ") # 侦测看 port 22 在否？
if [ "${testing}" != "" ]; then
echo "SSH is running in your system."
fi

testing=$(netstat -tuln | grep ":21 ") # 侦测看 port 21 在否？
if [ "${testing}" != "" ]; then
echo "FTP is running in your system."
fi

testing=$(netstat -tuln | grep ":25 ") # 侦测看 port 25 在否？
if [ "${testing}" != "" ]; then
echo "Mail is running in your system."
fi

exit 0