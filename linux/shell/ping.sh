#!/bin/bash
# Use ping command to check the network's PC state.
# 网绚状态的实际侦测，192.168.25.1--192.168.25.100，所有的地址都会ping一下
# @author jaysunxiao
# @version 1.0
# @since 2018-1-15 15:27
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 先定义一个网址的前缀
network="192.168.25"

for sitenum in $(seq 1 100)
do
    # 底下的程序在取得ping的回传值是正确的还是失败的！
    # -c 数值：后面接的是执行 ping 的次数，例如 -c 5
    # -w 数值：等待响应对方主机的秒数
    # -t 数值：Time To Live的缩写，该字段指定IP包被路由器丢弃之前允许通过的最大网段数量，预设是 255，每经过一个节点就会少一；
    # -s 数值：发送出去的 ICMP 封包大小，预设为 56bytes，不过你可以放大此一数值
    # 可以利用操作系统规定的ICMP数据包最大尺寸不超过64KB这一规定，向主机发起“Ping of Death”（死亡之Ping）攻击。
    # “Ping of Death” 攻击的原理是：如果ICMP数据包的尺寸超过64KB上限时，主机就会出现内存分配错误，导致TCP/IP堆栈崩溃，致使主机死机。
    ping -c 1 -w 1 ${network}.${sitenum} && result=0 || result=1
    # 开始显示结果：是正确的启动(UP)，还是错误的没有连通(DOWN)
    if [ "$result" == 0 ]; then
        echo "Server ${network}.${sitenum} is UP."
    else
        echo "Server ${network}.${sitenum} is DOWN."
    fi
done


#for (( i=1; i<=100; i=i+1 ))
#do
#    echo ${i}
#done


exit 0