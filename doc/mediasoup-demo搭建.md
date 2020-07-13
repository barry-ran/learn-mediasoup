# 环境
CentOS 7/Windows 10

提前安装好git、node.js(推荐使用nvm安装，方便管理node.js版本)、python2.7
CentOS 7: gcc、g++
Windows 10: vs2017 msvc编译环境

mediasoup具体环境要求看[这里](https://mediasoup.org/documentation/v3/mediasoup/installation/#requirements)

CentOS安装nvm：
```
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
source ~/.bashrc
nvm --version
```

nvm安装node：
```
nvm install 10.13.0
nvm use 10.13.0
```

# 源码准备
注意：windows下执行以下命令可以使用git bash或者cmder
## 1. 下载源码
```
git clone https://github.com/versatica/mediasoup-demo.git
cd mediasoup-demo
git checkout v3
```

## 2. 安装依赖
源码根目录执行：
```
cd server 
npm install
```

## 3. 配置
```
cp config.example.js config.js
```
根据需要修改config.js中的配置:
例如：本地测试的时候，将webRtcTransportOptions和plainTransportOptions中的listenIps改为'0.0.0.0'
```
        // mediasoup WebRtcTransport options for WebRTC endpoints (mediasoup-client,
        // libmediasoupclient).
		// See https://mediasoup.org/documentation/v3/mediasoup/api/#WebRtcTransportOptions
		webRtcTransportOptions :
		{
			listenIps :
			[
				{
					ip          : process.env.MEDIASOUP_LISTEN_IP || '0.0.0.0',
					announcedIp : process.env.MEDIASOUP_ANNOUNCED_IP
				}
			],
			initialAvailableOutgoingBitrate : 1000000,
			minimumAvailableOutgoingBitrate : 600000,
			maxSctpMessageSize              : 262144,
			// Additional options that are not part of WebRtcTransportOptions.
			maxIncomingBitrate              : 1500000
		},
		// mediasoup PlainTransport options for legacy RTP endpoints (FFmpeg,
		// GStreamer).
		// See https://mediasoup.org/documentation/v3/mediasoup/api/#PlainTransportOptions
		plainTransportOptions :
		{
			listenIp :
			{
				ip          : process.env.MEDIASOUP_LISTEN_IP || '0.0.0.0',
				announcedIp : process.env.MEDIASOUP_ANNOUNCED_IP
			},
			maxSctpMessageSize : 262144
		}
	
```

## 4. 安装web app依赖
源码根目录执行：
```
cd app
npm install
npm install -g gulp-cli
```

# 部署测试
1. 准备好密钥文件

    mediasoup v3把密钥文件从仓库中删除了，不过可以从git log中检索出来（git log搜索cert）
    certs\mediasoup-demo.localhost.cert.pem改名为certs\fullchain.pem
    certs\mediasoup-demo.localhost.key.pem改名为certs\privkey.pem

    或者可以直接用我[这里](../certs)提供的

## 遇到的问题
提前把这些问题列出来，要不一会遇到了不知道怎么解决

### mediasoup编译失败
执行node server.js或者npm start启动server的时候，可能会看到这样的错误：
```
UnhandledPromiseRejectionWarning: Error: spawn *****\mediasoup-demo\server\node_modules\mediasoup\worker\out\Release\mediasoup-worker ENOENT
```
这是因为安装mediasoup依赖的时候，编译mediasoup worker失败，重新安装一下试试：

mediasoup-demo\server目录下执行：
```
rm -rf node_modules\mediasoup
npm install
```
windows下收到错误：
```
npm-scripts.js [INFO] executing command: MSBuild ./worker/mediasoup-worker.sln /p:Configuration=Release
'MSBuild' 不是内部或外部命令，也不是可运行的程序或批处理文件。
```
很明显，msvc编译环境没有安装或者MSBuild没有加到环境变量，注册一下开发环境：
```
"d:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\Tools\VsDevCmd.bat"
```
接着npm install重新安装即可编译成功，然后可以运行了node server.js

## 本地测试
1. 启动server

    windows：
    ```
    cd server
    set DEBUG=${DEBUG:='*mediasoup* *INFO* *WARN* *ERROR*'} & set INTERACTIVE=${INTERACTIVE:='true'} & node server.js
    ```

    非windows：
    ```
    cd server
    npm start
    ```
2. 启动app
    ```
    cd app
    npm start
    ```
    看到如下结果，访问链接即可
    ```
    Access URLs:
    --------------------------------------------------
       Local: https://localhost:3000/?info=true
       External: https://192.168.159.1:3000/?info=true
    --------------------------------------------------
    ```

# 参考链接
[mediasoup-demo](https://github.com/versatica/mediasoup-demo/)
[mediasoup-requirements](https://mediasoup.org/documentation/v3/mediasoup/installation/#requirements)
[Mediasoup(webrtc) Demo搭建及测试](https://blog.csdn.net/m0_37263637/article/details/89921861)


