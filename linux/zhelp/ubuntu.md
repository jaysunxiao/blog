### Ubuntu Desktop安装

- 按照常规的方法将Linux安装在空闲的磁盘空间，不要覆盖Windows的安装空间
- https://zhuanlan.zhihu.com/p/363640824

```
分区参考上面的链接
```

### 开放root用户远程登录

- root用户密码设置，新装的ubuntu没有root密码，所以要先设置一下
    - sudo passwd root

- su root 切换到root用户

### 关闭防火墙

- systemctl stop ufw
- systemctl disable ufw

### 开启远程ssh，需要关闭ufw防火墙

- apt install openssh-server，ubuntu server 已经安装过就不用安装了
- systemctl start ssh
- systemctl enable ssh
- vim /etc/ssh/sshd_config

```
 # 添加 Port 2222 访问端口，可同时使用多个端口
 Port 22
 # 将PermitRootLogin prohibit-password修改为PermitRootLogin yes
 PermitRootLogin yes
```

### 使用root账户

- vim /etc/pam.d/gdm-autologin

```
注释掉下面这行代码
#auth required pam_succeed_if.so user != root quiet_success
```

- /etc/pam.d/gdm-password

```
注释掉下面这行代码
#auth	required	pam_succeed_if.so user != root quiet_success
```

- 可以不用删除其它用户，userdel -r sun 删除装机建立的用户，后面使用root登录

### 系统时间

- 双系统时间对不上

```
apt install ntpdate
ntpdate time.windows.com
hwclock --localtime --systohc
```

### 固定ip设置

- sudo vim /etc/netplan/01-network-manager-all.yaml
- ip route show #查看默认网关
- route -n #查看多少个网关

```yaml
network:
  ethernets:
    enp6s0:
      dhcp4: no
      dhcp6: no
      addresses:
        - 192.168.1.100/24
      routes:
        - to: default
          via: 192.168.1.1
      nameservers:
        addresses:
          - 114.114.114.114
          - 8.8.8.8
  version: 2
  renderer: networkd
```

- sudo netplan apply

### 先安装重要工具（一般ubuntu自带了）

- sudo apt update
- sudo apt install g++
- sudo apt install gcc
- sudo apt install make

### 使用shell命令

- dpkg-reconfigure dash 选择no，这样就可以使用shell脚本了

### 翻墙设置

- v2ray安装，请看v2ray-setting.md
- v2ray配置文件上传
- java环境上传
- homev2ray.jar上传

- apt install git

```
使用vpn
git config --global http.proxy http://127.0.0.1:10809
git config --global https.proxy https://127.0.0.1:10809
```

### 显卡驱动安装

- 最新安装方式，https://blog.csdn.net/Eric_xkk/article/details/131800365

### cuda安装

- cuda官网下载 runfile 文件，官网有安装命令，安装的时候不要安装显卡驱动
- vim /etc/profile

```
JAVA_HOME=/usr/local/java
CUDA_HOME=/usr/local/cuda

PATH=$JAVA_HOME/bin:$CUDA_HOME/bin:$CUDA_HOME/lib64:$PATH

export JAVA_HOME CUDA_HOME PATH
```

- source /etc/profile，加载环境变量

### 关闭自动更新

- vim /etc/apt/apt.conf.d/10periodic 修改更新列表，全部改为0

```
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Download-Upgradeable-Packages "0";
APT::Periodic::AutocleanInterval "0";
```

- 关闭服务，选择No

```
dpkg-reconfigure unattended-upgrades
## 禁用 unattended-upgrades 服务
systemctl stop unattended-upgrades
systemctl disable unattended-upgrades
## 可选：移除 unattended-upgrades (sysin)
apt remove unattended-upgrades
```

- 清空 apt 缓存

```
# 可选：清空缓存
apt autoremove #移除不在使用的软件包
apt clean && sudo apt autoclean #清理下载文件的存档
rm -rf /var/cache/apt
rm -rf /var/lib/apt/lists
rm -rf /var/lib/apt/periodic
```

- 重置更新通知（更新提示数字）

```
rm -f /var/lib/update-notifier/updates-available
```

- 禁用内核更新

```
# 禁用内核更新
apt-mark hold linux-generic linux-image-generic linux-headers-generic
# 恢复内核更新
apt-mark unhold linux-generic linux-image-generic linux-headers-generic
```

- vim /etc/apt/apt.conf.d/50unattended-upgrades 在 unattended-upgrades 配置文件中禁用内核更新

```
Unattended-Upgrade::Package-Blacklist {
"linux-generic";
"linux-image-generic";
"linux-headers-generic";
};
```

- dpkg --list | grep linux- 查看安装的内核

```
ii  binutils-x86-64-linux-gnu            2.34-6ubuntu1.1                   amd64        GNU binary utilities, for x86-64-linux-gnu target
ii  linux-base                           4.5ubuntu3                        all          Linux image base package
ii  linux-firmware                       1.187                             all          Firmware for Linux kernel drivers
ii  linux-generic                        5.4.0.26.32                       amd64        Complete Generic Linux kernel and headers
ii  linux-headers-5.4.0-26               5.4.0-26.30                       all          Header files related to Linux kernel version 5.4.0
ii  linux-headers-5.4.0-26-generic       5.4.0-26.30                       amd64        Linux kernel headers for version 5.4.0 on 64 bit x86 SMP
ii  linux-headers-generic                5.4.0.26.32                       amd64        Generic Linux kernel headers
ii  linux-image-5.4.0-26-generic         5.4.0-26.30                       amd64        Signed kernel image generic
ii  linux-image-generic                  5.4.0.26.32                       amd64        Generic Linux kernel image
ii  linux-libc-dev:amd64                 5.4.0-81.91                       amd64        Linux Kernel Headers for development
ii  linux-modules-5.4.0-26-generic       5.4.0-26.30                       amd64        Linux kernel extra modules for version 5.4.0 on 64 bit x86 SMP
ii  linux-modules-extra-5.4.0-26-generic 5.4.0-26.30                       amd64        Linux kernel extra modules for version 5.4.0 on 64 bit x86 SMP
```

- 清理多余的内核

```
apt purge linux-image-x.x.x-x  # x.x.x-x 代表内核版本数字
apt purge linux-headers-x.x.x-x
apt autoremove  # 自动删除不在使用的软件包

#卸载完内核后需要执行下列命令更新 grub
update-grub
```

- apt list --upgradable | grep linux- 查看可用的内核更新命令
  =======

### 更新软件源的索引

- apt update

```
同步 /etc/apt/sources.list 和 /etc/apt/sources.list.d 中列出的源的索引，这样才能获取到最新的软件包
```

