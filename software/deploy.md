预估网站的访问量大概10w人，
每个人平均发消息15s/条
聊天应用每条消息150byte左右

所以每秒钟的网络带宽至少要10w * 150byte / 15s = 1MB/s，至少要买10Mbps的带宽


EIP  10Mbps  5年  26k
数据库服务器（MongoDB）  4cpu + 16g ram + 500g ssd  通用性g5  5年 24k
gateway  4cpu + 8g ram  5年 8k
logic server  4cpu + 8g ram 5年 8k * 2
config server 2cpu + 4g ram  5年 4k

sum = 80k