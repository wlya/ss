#!/bin/bash

# 参数 1：端口，默认为 57611
SSPORT="${1:-47611}"
# 参数 2：密码，默认为 F01g7NBz
SSKEY="${2:-F01g7NBz}"

sudo apt update
sudo apt install -y git curl wget

# 检查目录是否存在，避免重复 clone 报错
if [ ! -d "/ss" ]; then
    sudo git clone https://github.com/wlya/ss /ss
fi

sudo chmod a+x /ss/*

# 写入配置文件，使用上面定义的变量
echo "{\"server\":\"0.0.0.0\",\"server_port\":$SSPORT,\"local_address\":\"127.0.0.1\",\"local_port\":1080,\"password\":\"$SSKEY\",\"timeout\":600,\"method\":\"aes-256-gcm\"}" | sudo tee /ss/ssconfig.json > /dev/null

echo "ssconfig inited with Port: $SSPORT"
bash /ss/init.sh
