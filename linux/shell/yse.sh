#!/bin/bash
# This program shows the user's choice
# @author jaysunxiao
# @version 1.0
# @since 2018-1-13 10:39

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH


# []里面每个参数必须全部都用空格隔开
# -o(或)连结两个判断，-a(与)
while [ "${yn}" != "yes" -a "${yn}" != "YES" ]
do
    echo "I don't know what your choice is"
    read -p "Please input yes/YES to stop this program: " yn
done


echo "OK! you input the correct answer."

exit 0