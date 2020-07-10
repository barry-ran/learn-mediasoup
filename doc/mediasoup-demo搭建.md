# 环境
CentOS 7/Windows 10

提前安装好git、node.js(推荐使用nvm安装，方便管理node.js版本)、python2.7
CentOS 7: gcc、g++
Windows 10: vs2017 msvc编译环境

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
根据需要修改config.js中的配置

## 4. 安装web app依赖
源码根目录执行：
```
cd app
npm install
npm install -g gulp-cli
```

# 部署测试
