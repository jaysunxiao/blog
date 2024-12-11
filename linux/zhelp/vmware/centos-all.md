# 一、基本工具安装

## 1. wrk安装

- yum groupinstall 'Development Tools'
- yum install -y openssl-devel git
- git clone https://github.com/wg/wrk.git wrk
- cd wrk
- make
- cp wrk /usr/local/bin
