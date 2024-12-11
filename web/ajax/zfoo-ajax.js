// AJAX请求的基本过程
// 1.创建XMLHttpRequest对象
// 1+. 请求发起前的一些处理逻辑
// 2.open，设置各类属性,method, async, url, url param data
// 2+. 设置请求头
// 3.send, post data
// 4.success, error, always callback
// 5.timeout callback

// 对过程进行分析整理，抽象出一个更符合业务处理习惯的过程逻辑
// 1. 初始化一个对象，初始时就通过参数指定请求是同步还是异步，默认异步
// 2. 如果需要自定义请求头，对象提供header或headers方法来设置头
// 3. 如果需要做一些前置处理操作，提供一个before方法，参数为要前置执行的function
// 4. 请求方法名决定使用的是哪种method提交请求，支持get, post，可扩展,此类方法执行后，请求被发起
// 5. 提供success方法用来绑定readystate==4 && status==200时的回调处理函数，回调函数参数为responseText或JSON
//    success时试图将返回结果转json，如果成功，参数为转换后的json对象，否则为string
//	     如果 success方法指定了第二个参数为true，表示结果必须为正确的json，如果转换失败，会触发error回调
// 6. 提供error方法用来绑定readystate == 4 && status != 200 时的回调，回调参数为status, responseText,xhr
// 7. 提供alwars方法用来绑定 readyState == 4时的回调 ，不管status为任何值，回调参数status, responseText,xhr
// 8. 提供timeout方法设定超时时间并绑定超时处理函数


// 所有方法返回的都是一个对象，其中有abort方法，用于在连接请求时中止前一个请求


/**
 * 对ajax操作的封装，以方便使用
 */
(function() {
    /*
     * 创建xhr对象
     */
    function createXhr() {
        let xhr = null;
        if (window.XMLHttpRequest) {
            // 优先使用标准的XMLHttpRequst对象
            xhr = new XMLHttpRequest();
        } else if (window.ActiveXObject) {
            try {
                // IE6+
                xhr = new ActiveXObject('Msxml2.XMLHTTP');
            } catch (e) {
                try {
                    // IE5
                    xhr = new ActiveXObject('Microsoft.XMLHTTP');
                } catch (e) {
                    console.log('error');
                }
            }
        }
        return xhr;
    }


    /**
     * 初始化一个对象，用来发起ajax请求
     * @param {Boolean} sync
     */
    window.ajax = function(url, async) {
        // 核心功能对象，包含了xhr并实现了需求中各方法和属性
        const xhrWrapper = {
            xhr: createXhr(), // xhr对象
            url: url,
            async: async // 是否异步
        };

        /**
         * 设置前置处理方法
         * @param {Function} callback
         */
        xhrWrapper.before = function(callback) {
            if (typeof (callback) !== 'function') {
                throw new Exception('before para must be function');
            }
            callback(xhrWrapper.xhr);
            return xhrWrapper; // 为支持链式操作，将原对象返回
        };

        /**
         * 以get method发起ajax请求
         */
        xhrWrapper.get = function() {
            xhrWrapper.xhr.open('GET', xhrWrapper.url, xhrWrapper.async);
            return xhrWrapper;
        };

        /**
         * 以post method发起ajax请求
         */
        xhrWrapper.post = function() {
            xhrWrapper.xhr.open('POST', xhrWrapper.url, xhrWrapper.async);
            return xhrWrapper;
        };

        /**
         * 设置单个请求头
         * header方法必须在get|post方法之前执行，否则请求已发出再设置header没意义
         * @param {String} name
         * @param {String} value
         */
        xhrWrapper.header = function(name, value) {
            xhrWrapper.xhr.setRequestHeader(name, value);
            return xhrWrapper;
        };

        /**
         * 设置多个请求头
         * @param {Object} headers
         */
        xhrWrapper.headers = function(headers) {
            for (const name in headers) {
                xhrWrapper.xhr.setRequestHeader(name, headers[name]);
            }
            return xhrWrapper;
        };


        /**
         * 发送数据
         * @param data
         */
        xhrWrapper.send = function(data) {
            xhrWrapper.xhr.send(data);
            return xhrWrapper;
        };

        /**
         * 成功时的回调
         * @param {Function} callback
         * @param {Boolean} jsonForceValidate
         */
        xhrWrapper.onload = function(callback) {
            xhrWrapper.xhr.onload = function() {
                callback(xhrWrapper.xhr);
            };
            return xhrWrapper;
        };

        /**
         * 失败时的回调
         * @param {Function} callback
         */
        xhrWrapper.error = function(callback) {
            if (typeof (callback) === 'function') {
                xhrWrapper.errorCallback = callback;
            }

            return xhrWrapper;
        };


        /**
         * 设定超时时间并绑定超时回调
         * @param {Object} timeout
         * @param {Object} callback
         */
        xhrWrapper.timeout = function(timeout, callback) {
            xhrWrapper.xhr.timeout = timeout;

            if (typeof (callback) === 'function') {
                xhrWrapper.xhr.ontimeout = function() {
                    callback(xhrWrapper.xhr);
                };
            }

            return xhrWrapper;
        };

        // 暴露xhr的常用方法
        xhrWrapper.abort = function() {
            xhrWrapper.xhr.abort();
        };

        return xhrWrapper;
    };
})();
