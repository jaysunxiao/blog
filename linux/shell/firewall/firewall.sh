#!/bin/bash

# 服务器防火墙设定的shell脚本
# @author jaysunxiao
# @version 1.0
# @since 2018-1-27 18:06

PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/sbin:/usr/local/bin;
export PATH

# 请先输入您的相关参数，不要输入错误了！
EXTIF="eth0" # 这个是可以连上 Public IP 的网络接口
INIF="eth1" # 内部 LAN 的连接接口；若无则写成 INIF=""
INNET="192.168.100.0/24" # 若无内部网域接口，请填写成 INNET=""
export EXTIF INIF INNET


# 第一部份，针对本机的防火墙设定！
##########################################
# 1. 先设定好核心的网络功能：
# 所谓的阻断式服务 (DoS) 攻击法当中的一种方式，就是利用TCP 封包的 SYN 三向交握原理所达成的， 这种方式称为 SYN Flooding 。
# SYN Cookie 模块可以在系统用来启动随机联机的埠口 (1024:65535) 即将用完时自动启动。
# 当启动 SYN Cookie 时，主机在发送 SYN/ACK 确认封包前，会要求 Client 端在短时间内回复一个序号，
# 这个序号包含许多原本 SYN 封包内的信息，包括 IP、port 等。若 Client 端可以回复正确的序号，那么主机就确定该封包为可信的，
# 因此会发送 SYN/ACK 封包，否则就不理会此一封包。透过此一机制可以大大的降低无效的 SYN 等待端口，而避免 SYN Flooding 的DoS攻击

# 避免DOS攻击，不适合负载太高的服务器，会产生误判
echo "1" > /proc/sys/net/ipv4/tcp_syncookies
# 避免ping of death攻击，让核心自动取消 ping 的响应
# 某些局域网络内常见的服务 (例如动态 IP 分配 DHCP协议) 会使用 ping 的方式来侦测是否有重复的 IP ，所以你最好不要取消所有的 ping 响应比较好
echo "1" > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts

# 启用：
# rp_filter：称为逆向路径过滤 (Reverse Path Filtering)， 可以藉由分析网络接口的路由信息配合封包的来源地址，来分析该封包是否为合理
# log_martians：这个设定数据可以用来启动记录不合法的 IP 来源，记录的数据默认放置到核心放置的登录档 /var/log/messages
for i in /proc/sys/net/ipv4/conf/*/{rp_filter,log_martians};
do
    echo "1" > $i
done

# 关闭：
# accept_source_route：或许某些路由器会启动这个设定值， 不过目前的设备很少使用到这种来源路由
# accept_redirects：这个设定也可能会产生一些轻微的安全风险，所以建议关闭他
# send_redirects：与上一个类似，只是此值为发送一个 ICMP redirect 封包。 同样建议关闭。
for i in /proc/sys/net/ipv4/conf/*/{accept_source_route,accept_redirects,\send_redirects};
do
    echo "0" > $i
done


# 2. 清除规则、设定默认政策及开放 lo 与相关的设定值

# 清除本机防火墙 (filter) 的所有规则
# 清除所有的已订定的规则
iptables -F
# 杀掉所有使用者 "自定义" 的 chain (应该说的是 tables ）
iptables -X
# 将所有的 chain 的计数与流量统计都归零
iptables -Z

# 将本机的 INPUT 设定为 DROP ，其他设定为 ACCEPT
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT


# 3. 启动额外的防火墙 script 模块
if [ -f /usr/local/virus/iptables/iptables.deny ]; then
# 语法格式：iptables -A INPUT -i eth1 -s 192.168.100.230 -j DROP
    sh /usr/local/iptables.deny
fi

if [ -f /usr/local/virus/iptables/iptables.allow ]; then
# 语法格式：iptables -A INPUT -i eth1 -s 192.168.100.10 -j ACCEPT
    sh /usr/local/iptables.allow
fi

if [ -f /usr/local/virus/httpd-err/iptables.http ]; then
    sh /usr/local/iptables.http
fi


# 4. 允许某些类型的 ICMP 封包进入
AICMP="0 3 3/4 4 11 12 14 16 18"
for tyicmp in ${AICMP}
do
    iptables -A INPUT -i ${EXTIF} -p icmp --icmp-type ${tyicmp} -j ACCEPT
done



# 5. 允许某些服务的进入，请依照你自己的环境开启
# iptables -A INPUT -p TCP -i ${EXTIF} --dport 21 --sport 1024:65534 -j ACCEPT # FTP
# iptables -A INPUT -p TCP -i ${EXTIF} --dport 22 --sport 1024:65534 -j ACCEPT # SSH
# iptables -A INPUT -p TCP -i ${EXTIF} --dport 25 --sport 1024:65534 -j ACCEPT # SMTP
# iptables -A INPUT -p UDP -i ${EXTIF} --dport 53 --sport 1024:65534 -j ACCEPT # DNS
# iptables -A INPUT -p TCP -i ${EXTIF} --dport 80 --sport 1024:65534 -j ACCEPT # WWW
# iptables -A INPUT -p TCP -i ${EXTIF} --dport 110 --sport 1024:65534 -j ACCEPT # POP3
# iptables -A INPUT -p TCP -i ${EXTIF} --dport 443 --sport 1024:65534 -j ACCEPT # HTTPS




# 第二部份，针对后端主机的防火墙设定！###############################
# 1. 先加载一些有用的模块
modules="ip_tables iptable_nat ip_nat_ftp ip_nat_irc ip_conntrack ip_conntrack_ftp ip_conntrack_irc"
for mod in ${modules}
do
    testmod=`lsmod | grep "^${mod} " | awk '{print $1}'`
    if [ "${testmod}" == "" ]; then
        modprobe ${mod}
    fi
done

# 2. 清除 NAT table 的规则吧！
iptables -F -t nat
iptables -X -t nat
iptables -Z -t nat

iptables -t nat -P PREROUTING ACCEPT
iptables -t nat -P POSTROUTING ACCEPT
iptables -t nat -P OUTPUT ACCEPT

# 3. 若有内部接口的存在 (双网卡) 开放成为路由器，且为 IP 分享器！
if [ "${INIF}" != "" ]; then
    iptables -A INPUT -i ${INIF} -j ACCEPT
    echo "1" > /proc/sys/net/ipv4/ip_forward
    if [ "${INNET}" != "" ]; then
        for innet in ${INNET}
        do
            # MASQUERADE设定值就是 IP 伪装成为封包出去 (-o) 的那块装置上的 IP
            iptables -t nat -A POSTROUTING -s ${innet} -o ${EXTIF} -j MASQUERADE
        done
    fi
fi

# 如果你的 MSN 一直无法联机，或者是某些网站 OK 某些网站不 OK，
# 可能是 MTU 的问题，那你可以将底下这一行给他取消批注来启动 MTU 限制范围
# iptables -A FORWARD -p tcp -m tcp --tcp-flags SYN,RST SYN -m tcpmss --mss 1400:1536 -j TCPMSS --clamp-mss-to-pmtu

# 4. NAT 服务器后端的 LAN 内对外之服务器设定
# iptables -t nat -A PREROUTING -p tcp -i $EXTIF --dport 80 \
# -j DNAT --to-destination 192.168.1.210:80 # WWW

# 5. 特殊的功能，包括 Windows 远程桌面所产生的规则，假设桌面主机为1.2.3.4
# iptables -t nat -A PREROUTING -p tcp -s 1.2.3.4 --dport 6000 -j DNAT --to-destination 192.168.100.10
# iptables -t nat -A PREROUTING -p tcp -s 1.2.3.4 --sport 3389 -j DNAT --to-destination 192.168.100.20

# 6. 最终将这些功能储存下来吧！
/etc/init.d/iptables save
iptables-save