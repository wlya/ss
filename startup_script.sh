sudo apt update
sudo apt install -y git curl wget
git clone https://github.com/wlya/ss /ss
SSKEY="$1" && echo "{\"server\":\"0.0.0.0\",\"server_port\":57611,\"local_address\":\"127.0.0.1\",\"local_port\":1080,\"password\":\"$SSKEY\",\"timeout\":600,\"method\":\"aes-256-gcm\"}" > /ss/ssconfig.json
echo "ssconfig inited."
bash /ss/init.sh
