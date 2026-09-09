#!/bin/bash

# 参数 1：端口，默认为 47611
SSPORT="${1:-47611}"
# 参数 2：原始密码，默认为 F01g7NBz
RAW_KEY="${2:-F01g7NBz}"
# 将第二个参数计算为 MD5 值作为 SSKEY
SSKEY=$(printf "%s" "$RAW_KEY" | md5sum | awk '{print $1}')

sudo apt update
sudo apt install -y git curl wget

# 检查目录是否存在，避免重复 clone 报错
if [ ! -d "/ss" ]; then
    sudo git clone https://github.com/wlya/ss /ss
fi

sudo chmod a+x /ss/*

# 写入配置文件，使用上面定义的变量
echo "{\"server\":\"::\",\"server_port\":$SSPORT,\"local_address\":\"127.0.0.1\",\"local_port\":1080,\"password\":\"$SSKEY\",\"timeout\":600,\"method\":\"2022-blake3-chacha20-poly1305\"}" | sudo tee /ss/ssconfig.json > /dev/null

echo "ssconfig inited with Port: $SSPORT"
echo "SSKey (MD5): $SSKEY"
bash /ss/init.sh
