let n = 1;
search: 
while (n < 99999) {
    // 开始搜寻下一个质数
    n += 1;
    for (let i = 2; i <= Math.sqrt(n); i++) {
        // 如果除以n的余数为0，开始判断下一个数字。
        if (n % i == 0) {
            continue search;
        }
    }
    // 发现质数，postMessage(data)：发送消息，提交data数据。
    // Worker线程启动的JavaScript脚本调用postMessage(data)发送消息时，将会触发为该Worker对象的onmessage事件绑定的监听器。
    postMessage(n);
}
