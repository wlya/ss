
#!/bin/bash

# 参数 1：端口（已废弃，使用随机端口）
# 参数 2：原始密码（已废弃，使用随机密码）
PWD="${1:-wh0am1}"
#
# 1. 生成随机端口（40000-50000）和随机密码
SSPORT=$(( RANDOM % 10001 + 40000 ))
RAW_KEY=$(openssl rand -base64 12)
# 将随机密码计算为 SHA256 值作为 SSKEY
SSKEY=$(printf "%s" "$RAW_KEY" | openssl dgst -sha256 -binary | base64)

# 2. 获取 IPv4 和 IPv6 地址
VPS_IPV4=$(curl -s --ipv4 http://v4.ipip.net/)
VPS_IPV6=$(curl -s --ipv6 http://v6.ipip.net/)

echo "VPS_IPV4: $VPS_IPV4"
echo "VPS_IPV6: $VPS_IPV6"

# 3. 通过 ipinfo.io 获取国家代码
VPS_COUNTRY=$(curl -s ipinfo.io | grep '"country"' | cut -d'"' -f4)
echo "VPS_COUNTRY: $VPS_COUNTRY"

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
echo "SSKey (SHA256): $SSKEY"
bash /ss/init.sh

# 4. 将 IPv4 和 IPv6 分别作为两个服务器 POST 到 vip.val.run
# IPv4 服务器
curl --url 'https://vip.val.run/api/servers' \
  -H "X-API-Key: ${PWD}" \
  --data-raw "{\"name\":\"${VPS_COUNTRY}_4\",\"type\":\"ss\",\"server\":\"${VPS_IPV4}\",\"port\":${SSPORT},\"cipher\":\"2022-blake3-chacha20-poly1305\",\"password\":\"${SSKEY}\",\"udp\":true}"

echo ""

# IPv6 服务器
curl --url 'https://vip.val.run/api/servers' \
  -H "X-API-Key: ${PWD}" \
  --data-raw "{\"name\":\"${VPS_COUNTRY}_6\",\"type\":\"ss\",\"server\":\"${VPS_IPV6}\",\"port\":${SSPORT},\"cipher\":\"2022-blake3-chacha20-poly1305\",\"password\":\"${SSKEY}\",\"udp\":true}"
