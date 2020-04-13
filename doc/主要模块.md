# worker

## Worker
每个Worker相当于一个SFU服务器，主要功能如下：
1. 管理多个router（相当于room）
2. 信号事件处理（SignalsHandler）
3. 接收外部请求，并处理部分请求，其它转发给Router处理（Channel::UnixStreamSocket）
4. 向外部发送通知（Channel::UnixStreamSocket）

## DepLibUV
封装了一个静态变量libuv::uv_loop_t，主要包括创建、销毁、运行uv_loop_t，这也是整个应用的主loop

## Logger
封装了日志相关操作，引用了一个Channel::UnixStreamSocket，用它来发送日志

## DepOpenSSL
封装了openssl的初始化，主要是RAND_poll

## DepLibSRTP
封装了libsrtp库的初始化和清理

## handles
### UnixStreamSocket
封装了uv_pipe_t进行进程间通信，UnixStreamSocket分为生产者（发送端）或者消费者（接收端）

### UdpSocket
封装了uv_udp_t进行udp通信

### Timer
封装uv_timer_t实现定时器

### TcpConnection
封装uv_tcp_t实现tcp客户端

### TcpServer
封装uv_tcp_t实现tcp服务器

### SignalsHandler
封装uv_signal_t实现信号事件处理

## Channel
### UnixStreamSocket
基于两个UnixStreamSocket实现了双向通信

首先继承UnixStreamSocket实现了生产者ProducerSocket、消费者ConsumerSocket

Channel::UnixStreamSocket基于ProducerSocket和ConsumerSocket实现pipe双向通信

### Request
定义了Worker支持的业务功能，外部和Worker通信有两种方式：
1. 外部向Worker主动发送相关业务功能的Request，Worker回复Accept/Error
2. Worker向外部主动发送Notifier广播事件

通信协议使用json，发送数据使用Channel::UnixStreamSocket，封装了快捷回复函数Accept/Error

### Notifier
Worker向外部主动发送Notifier广播事件

通信协议使用json，发送数据使用Channel::UnixStreamSocket，封装了快捷通知函数Emit



