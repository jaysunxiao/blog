#!/bin/bash
# User inputs 2 integer numbers; program will cross these two numbers.
# @author jaysunxiao
# @version 1.0
# @since 2018-1-13 10:39

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
echo -e "You SHOULD input 2 numbers, I will cross them! \n"
read -p "first number: " firstnu
read -p "second number: " secnu
total=$((${firstnu}*${secnu}))
# +, -, *, /, %
echo -e "\nThe result of ${firstnu} x ${secnu} is ==> ${total}"
exit 0