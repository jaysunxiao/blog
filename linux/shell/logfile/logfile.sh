#!/bin/bash
# @author jaysunxiao
# @version 1.0
# @since 2018-1-19 18:39

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin
LANG=en_US.UTF-8
export PATH LANG

##########################################################################################
# 必须填写下面的参数
# YOU MUST KEYIN SOME PARAMETERS HERE!!

# 这是logfile寄给谁的e-mail，也可以寄给其它人，格式：email用逗号隔开，不要加空白键，email="root@localhost,yourID@hostname"
email="root@localhost"
# log放置的位置
basedir="/tmp/testdir/scripts/logfile"
# 是否将所有的登录内容显示出来
outputall="no"
funcdir="/tmp/testdir/scripts/logfile"

export email basedir outputall funcdir


##########################################################################################
# 创建日志文件位置
test ! -d ${basedir} && mkdir ${basedir}

# 0. 参数校验
localhostname=$(hostname)

# 修改使用者邮件位置
temp=$(echo ${email} | cut -d '@' -f2)
if [ "${temp}" == "localhost" ]; then
	email=$(echo ${email} | cut -d '@' -f1)@"${localhostname}"
fi

# 检查awk，sed，egrep等命令是否存在
errormesg=""
programs="awk sed grep ps cat cut tee netstat df uptime journalctl"
for profile in ${programs}
do
	which ${profile} > /dev/null 2>&1
	if [ "$?" != "0" ]; then
		echo -e "Your system do not have ${profile}"
		errormesg="error"
	fi
done

if [ "${errormesg}" == "error" ]; then
	echo "你的系统由于缺乏程序运行所需要的命令，$0将停止运行"
	exit 1
fi

# 检查systemd-journald是否有启动
temp=$(ps -aux 2> /dev/null | grep "systemd-journald" | grep -v "grep")
if [ "$temp" == "" ]; then
	echo -e "你的程序没有启动systemd-journald这个daemon"
	echo -e "这个程序主要是针对systemd-journald产生的logfile来分析"
	echo -e "因此，没有systemd-journald则这个程序没有执行的必要"
	exit 0
fi

# 检查basedir是否存在
if [ ! -d "${basedir}" ]; then
	echo -e "${basedir}目录不存在，$0无法运行"
	exit 1
fi


##########################################################################################
# 0.1 日志文件
logfile="${basedir}/logfile_mail.txt"

##########################################################################################
# 1. 建立欢迎页面的通知
echo "=============== system summary ================================="
echo "Linux kernel  :  $(cat /proc/version | awk '{print $1 " " $2 " " $3 " " $4}')"
echo "CPU informatin: $(cat /proc/cpuinfo | grep 'model name' | sed 's/model name.*://' | uniq -c | sed 's/[[:space:]][[:space:]]*/ /g')"
echo "CPU speed     : $(cat /proc/cpuinfo | grep "cpu MHz" | sort | tail -n 1 | cut -d ':' -f2-) MHz"
echo "hostname is   :  $(hostname)"
echo "Network IP    :  $(echo $(ifconfig | grep 'inet ' | awk '{print $2}' | grep -v '127.0.0.'))"
echo "Summary time  :  $(date +%Y/%B/%d' '%H:%M:%S' '\(' '%A' '\))"
echo "start time    :  $(uptime -s)"
echo "runing time   :  $(uptime -p)"
echo "uptime info   : $(uptime)"
echo "Filesystem summary: "
df -Th	| sed 's/^/       /'

##########################################################################################
# 1.1 Port分析
echo "========================== Ports分析 =========================="
netstat -tlnp
netstat -ulnp


# 2.1 SSH测试
# /var/log/secure：基本上，只要牵涉到“需要输入帐号密码”的软件，那么当登陆时（不管登陆正确或错误）都会被记录在此文件中
echo "==========================  SSH分析  =========================="
less /var/log/secure | grep "$(date +%b) $(date +%d)" | grep "Accepted"

# 2.2 FTP测试

# 2.3 pop3测试

# 2.4 Mail测试

# 2.5 samba测试

#####################################################################

# At last! we send this mail to you!
if [ -x /usr/bin/uuencode ]; then
	uuencode $logfile logfile.html | mail -s "$hosthome logfile analysis results" $email
else
	mail -s "$hosthome logfile analysis results" $email < $logfile
fi

