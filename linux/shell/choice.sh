#!/bin/bash
# This script only accepts the flowing parameter: one, two or three.
# @author jaysunxiao
# @version 1.0
# @since 2018-1-15 13:40

#执行文件的搜寻路径
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

function choose(){
    echo "Your choice is $1" # 这个$1是传入的参数
}

echo "This program will print your selection !"
echo "input one,two or three"

read -p "Input your choice: " choice

case ${choice} in
    "one")
        choose ${choice}
        ;;
    "two")
        choose ${choice}
        ;;
    "three")
        choose ${choice}
        ;;
    *)
        echo "Usage $0 {one|two|three}"
        ;;
esac

exit 0