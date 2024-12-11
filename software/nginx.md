## windows下nginx安装，配置，使用

#### 安装

- 直接解压安装包

#### 启动

- nginx.exe(即nginx -c conf\nginx.conf)，默认使用80端口，日志见文件夹C:\nginx\logs

#### 关闭

- nginx -s stop

## 配置

#### 基本配置

location / { root /usr/local/river; index index.html index.htm; } error_page 404 /index.html;

### 作为静态资源服务器

- nginx的conf目录下有个nginx.conf目录，将配置修改如下，主要就是server.location的autoindex属性
- autoindex用于控制是否启用目录列表的自动生成功能。当一个 URL 对应的路径是一个目录而不是一个具体的文件时，如果启用了
  autoindex，Nginx 会自动列出该目录下的文件列表，以便用户可以浏览和访问其中的文件。

```text
#user  nobody;
worker_processes  1;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    sendfile        on;

    keepalive_timeout  65;

    #gzip  on;

    server {
        listen       80;
        server_name  localhost;

        location / {
            root   ../hotfix/;
            autoindex on;
        }
    }
}
```

- 关闭nginx的脚本

```text
taskkill /IM nginx.exe /F
```

#### 作为反向代理服务器

```
upstream tomcatserver1 {
    server 192.168.25.141:8080;
}
upstream tomcatserver2 {
    server 192.168.25.141:8081;
}

server {
    listen       80;
    server_name  8080.kongnull.com;
    location / {
        proxy_pass   http://tomcatserver1;
        index  index.html index.htm;
    }
}
server {
    listen       80;
    server_name  8081.kongnull.com;
    location / {
        proxy_pass   http://tomcatserver2;
        index  index.html index.htm;
    }
}
```

#### 作为负载均衡负载均衡服务器

```
#定义负载均衡设备的 Ip及设备状态 
upstream myServer {   
    server 127.0.0.1:9090 down; 
    server 127.0.0.1:8080 weight=2; 
    server 127.0.0.1:6060; 
    server 127.0.0.1:7070 backup; 
}

upstream 每个设备的状态:
down        # 表示单前的server暂时不参与负载 
weight      # 默认为1.weight越大，负载的权重就越大。 
max_fails   # 允许请求失败的次数默认为1.当超过最大次数时，返回proxy_next_upstream 模块定义的错误 
backup      # 其它所有的非backup机器down或者忙的时候，请求backup机器。所以这台机器压力会最轻。
```

#### nginx的高可用

nginx + keepalived
