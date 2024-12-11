#!/bin/bash
# You input your demobilization date, I calculate how many days before you demobilize.
# @author jaysunxiao
# @version 1.0
# @since 2018-1-15 10:39
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
# 1.告知用户这支程序的用途，并且告知应该如何输入日期格式？
echo "This program will try to calculate :"
echo "How many days before your demobilization date..."

read -p "Please input your demobilization date (YYYYMMDDex>20180116): " date

# 2.测试一下，用正则表达式检查这个输入的内容是否正确，看看是否有八个数字
date_d=$(echo ${date} |grep "[0-9]\{8\}")
if [ "${date_d}" == "" ]; then
echo "You input the wrong date format...."
exit 1
fi

# 3.开始计算日期
# 退伍日期秒数
declare -i date_dem=$(date --date=${date} +%s)
# 现在日期秒数
declare -i date_now=$(date +%s)
# 剩余秒数统计
declare -i date_total_s=$(($date_dem-$date_now))
# 转为日数
declare -i date_d=$(($date_total_s/60/60/24))
# 转为小时
declare -i date_h=$(($(($date_total_s-$date_d*60*60*24))/60/60))

# 判断是否已退伍
if [ "${date_total_s}" -lt "0" ]; then
echo "You had been demobilization before: " $((-1*${date_d})) "ago"
else
echo "You will demobilize after ${date_d} days and ${date_h} hours."
fi

exit 0