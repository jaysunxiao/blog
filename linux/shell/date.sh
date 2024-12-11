#!/bin/bash

# Program creates three files, which named by user's input and date command.
# @author jaysunxiao
# @version 1.0
# @since 2018-1-12 3:24
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 1.让使用者输入文件名，并取得fileuser这个发量；
echo -e "I will use 'touch' command to create 3 files."
# 提示使用者输入
read -p "Please input your filename: " fileuser
# 开始判断是否有否配置文件名，如果没有，为了避免使用者随意按Enter，利用变量功能分析文件是否有设定
filename=${fileuser:-"filename"}
# 3.开始利用date指令来取得所需要的文件名；
date1=$(date --date='2 days ago' +%Y%m%d)
date2=$(date --date='1 days ago' +%Y%m%d)
# 今天的日期
date3=$(date +%Y%m%d)
# 底下三行在配置文件名
file1=${filename}${date1}
file2=${filename}${date2}
file3=${filename}${date3}
# 底下三行在建立档案
touch "${file1}"
touch "${file2}"
touch "${file3}"
exit 0