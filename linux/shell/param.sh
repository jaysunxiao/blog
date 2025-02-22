#!/bin/bash
#  Program shows the script name, parameters...
# @author jaysunxiao
# @version 1.0
# @since 2018-1-15 09:39
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# /path/to/scriptname opt1 opt2 opt3 opt4
#        $0            $1   $2   $3   $4
echo "The script name is ==> $0"
# $#：代表后接的参数的个数
echo "Total parameter number is ==> $#"
# -lt小于Equal, not equal to, greater than, less than, greater than or equal to, less than or equal to
[ "$#" -lt 2 ] && echo "The number of parameter is less than 2. Stop here." && exit 0
# $@：代表"$1" "$2" "$3" "$4"，每个变量是独立的(用双引号括起来)
echo "Your whole parameter is ==> '$@'"
echo "The 1st parameter ==> $1"
echo "The 2nd parameter ==> $2"
exit 0