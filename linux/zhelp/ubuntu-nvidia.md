### 显卡驱动安装

- 最新安装方式，https://blog.csdn.net/Eric_xkk/article/details/131800365

- bios中禁用安全启动，安全启动会阻止显卡驱动的安装

```
安全启动（Secure Boot）是一种计算机启动过程中的安全机制，旨在保护系统免受恶意软件和未经授权的操作系统的入侵。

主要功能包括：
1.验证固件和驱动程序的数字签名：在计算机启动过程中，安全启动会验证固件和驱动程序的数字签名，确保它们是由受信任的制造商签名的，以防止使用恶意软件或未经授权的驱动程序。
2.防止恶意引导程序：安全启动确保只有经过授权的引导程序才能加载和运行。这样可以防止恶意软件和操作系统劫持计算机的启动过程。
3.保护启动磁盘的数据完整性：安全启动可以通过使用启动磁盘的数字签名来验证其数据的完整性。这可以防止通过篡改启动磁盘数据来劫持计算机的启动过程。

总之，安全启动提供了对计算机启动过程的认证和保护，防止未经授权的操作系统和恶意软件侵入系统，提高了计算机的安全性。
```

- ubuntu-drivers devices ，输入指令以查看电脑的显卡型号

- vim /etc/modprobe.d/blacklist.conf，禁用系统默认显卡驱动， 重启系统

```
blacklist nouveau
options nouveau modeset=0
```

- update-initramfs -u ，重载驱动程序，需要重启系统才能生效 

- lsmod | grep nouveau ，验证nouveau是否已禁用

- telinit 3 ，更改Linux系统的运行级别，运行级别可以是0~6之间的一个数字，其中0是关闭系统，1是进入单用户模式，2~5是多用户运行级别

- service gdm3 stop ，关闭显示服务

- 卸载之前的驱动
```
apt remove --purge nvidia*
# 若安装失败也是这样卸载以及
chmod a+x NVIDIA-Linux-x86_64-535.129.03.run
# 给予可执行权限
./serNVIDIA-Linux-x86_64-535.129.03.run --uninstall #确保卸载干净。
```

- chmod a+x NVIDIA-XXXXXX.run

```
在英伟达的官网上查找你自己电脑的显卡型号然后下载相应的驱动，老版本的驱动只能在 nvidia.com 的国际网站可以找到
```

- ./NVIDIA-XXXXXX.run ，安装驱动软件

- service gdm3 start


### cuda安装

- chmod cuda_XXXX_linux.run
- ./cuda_XXXX_linux.run，cuda安装自带显卡驱动，安装的时候注意取消
- vim /etc/profile ，修改环境变量
- source /etc/profile，加载环境变量
```
export PATH=/usr/local/cuda-11.6/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-11.6/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export CUDA_HOME=/usr/local/cuda-11.6
```


### 显卡限制功耗

- rc-local.service 是系统自带的一个开机自启服务，但是在 ubuntu 20.04 上，该服务默认没有开启。

```
vim /lib/systemd/system/rc-local.service

在文件的最后面添加 [Install] 段的内容：
[Install]
WantedBy=multi-user.target
```

- 创建 /etc/rc.local，Ubuntu 20.04 默认不存在 /etc/rc.local，需要自己创建自己的自启动命令

```shell

#!/bin/bash

nvidia-smi -pm 1

nvidia-smi -pl 200

exit 0

```

- 修改 /etc/rc.local 权限，chmod +x /etc/rc.local 修改该文件的权限

- 启动 rc-local.service，systemctl enable rc-local

