#!/bin/bash

# User inputs his first name and last name. Program shows his full name.
# 对谈式脚本：变内容由用户决定
# @author jaysunxiao
# @version 1.0
# @since 2018-1-12 3:00


PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
# 提示使用者输入
read -p "Please input your first name: " firstname
# 提示使用者输入
read -p "Please input your last name: " lastname
# 结果由屏幕输出
echo -e "Your full name is: ${firstname} ${lastname}"
exit 0