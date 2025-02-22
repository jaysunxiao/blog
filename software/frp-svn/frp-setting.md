### 通过 SSH 访问内网机器

- https://gofrp.org/docs/examples/ssh/
- 在具有公网 IP 的机器上部署 frps，修改 frps.ini 文件，这里使用了最简化的配置，设置了 frp 服务器用户接收客户端连接的端口：

```
[common]
bind_port = 7000
```

- 在需要被访问的内网机器上（SSH 服务通常监听在 22 端口）部署 frpc，修改 frpc.ini 文件，假设 frps 所在服务器的公网 IP 为
  x.x.x.x：

```
[common]
server_addr = x.x.x.x
server_port = 7000
login_fail_exit = false

[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = 6000
```

- local_ip 和 local_port 配置为本地需要暴露到公网的服务地址和端口。remote_port 表示在 frp
  服务端监听的端口，访问此端口的流量将会被转发到本地服务对应的端口。

- 分别启动 frps 和 frpc

- 过 SSH 访问内网机器，假设用户名为 test，frp 会将请求 x.x.x.x:6000 的流量转发到内网机器的 22 端口。

```
ssh -oPort=6000 test@x.x.x.x
```

### frps开机自启动
- vim /etc/systemd/system/frps.service 设置frps和frpc开机自启动

```
[Unit]
# 服务名称，可自定义
Description = frps
After = network.target syslog.target
Wants = network.target

[Service]
Type = simple
# 启动frps的命令，需修改为您的frps的安装路径
ExecStart = /usr/local/frp/frps -c /usr/local/frp/frps.ini

[Install]
#多用户
WantedBy=multi-user.target
```

- 使用 systemd 命令，管理 frps。

```
systemctl daemon-reload
systemctl start frps
systemctl stop frps
systemctl restart frps
systemctl status frps
```

- 配置 frps 开机自启。

```
systemctl enable frps
```


### frpc开机自启动
- vim /etc/systemd/system/frpc.service 设置frps和frpc开机自启动

```
[Unit]
# 服务名称，可自定义
Description = frpc
After = network.target syslog.target
Wants = network.target

[Service]
Type = simple
# 启动frps的命令，需修改为您的frps的安装路径
ExecStart = /usr/local/frp/frpc -c /usr/local/frp/frpc.ini

[Install]
#多用户
WantedBy=multi-user.target
```

- 配置 frpc 开机自启。

```
systemctl enable frpc
```
