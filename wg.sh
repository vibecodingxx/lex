
#!/bin/bash

# Warna
DF='\e[39m'
Bold='\e[1m'
Blink='\e[5m'
yell='\e[33m'
red='\e[31m'
green='\e[32m'
blue='\e[34m'
PURPLE='\e[35m'
CYAN='\e[36m'
Lred='\e[91m'
Lgreen='\e[92m'
Lyellow='\e[93m'
NC='\e[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
LIGHT='\033[0;37m'
rm -f -- "$0"

# Variabel
host="https://t.me/vibecodingxx"
owner="vibecodingxx"
gitlink="https://raw.githubusercontent.com"
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10)
MYIP=$(wget -qO- ipinfo.io/ip)
domain=$(cat /root/domain 2>/dev/null)
int="vibecodingxx"
sc="lex"
scv=$(awk '{print $2,$3}' /home/.ver 2>/dev/null)

clear
clear

# ==================================================
# Wireguard Script By VPN vibecodingxx
# ==================================================

# Check OS version
if [[ -e /etc/debian_version ]]; then
	source /etc/os-release
	OS=$ID # debian or ubuntu
elif [[ -e /etc/centos-release ]]; then
	source /etc/os-release
	OS=centos
fi

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[information]${Font_color_suffix}"

if [[ -e /etc/wireguard/params ]]; then
    echo -e "${Info} WireGuard sudah diinstal."
    read -p "Adakah anda mahu reinstall? [y/N]: " yn
    case "$yn" in
        [Yy]* )
            echo -e "${Info} Memadam konfigurasi lama..."
            rm -rf /etc/wireguard/params
            ;;
        * )
            echo -e "${Info} Keluar tanpa reinstall."
            exit 1
            ;;
    esac
fi

echo -e "${Info} Wireguard VPS AutoScript by VPN vibecodingxx"

# Detect public interface and pre-fill for the user

SERVER_PUB_NIC=$(ip -o $ANU -4 route show to default | awk '{print $5}')

# Install WireGuard tools and module
if [[ ${OS} == 'ubuntu' ]] || [[ ${OS} == 'debian' && ${VERSION_ID} -gt 10 ]]; then
	apt-get update
	apt-get install -y wireguard iptables qrencode
elif [[ ${OS} == 'debian' ]]; then
	if ! grep -rqs "^deb .* buster-backports" /etc/apt/; then
		echo "deb http://deb.debian.org/debian buster-backports main" >/etc/apt/sources.list.d/backports.list
		apt-get update
	fi
	apt update
	apt-get install -y iptables qrencode
	apt-get install -y -t buster-backports wireguard
elif [[ ${OS} == 'fedora' ]]; then
	if [[ ${VERSION_ID} -lt 32 ]]; then
		dnf install -y dnf-plugins-core
		dnf copr enable -y jdoss/wireguard
		dnf install -y wireguard-dkms
	fi
	dnf install -y wireguard-tools iptables qrencode
elif [[ ${OS} == 'almalinux' ]]; then
	dnf -y install epel-release elrepo-release
	dnf -y install wireguard-tools iptables qrencode
	if [[ ${VERSION_ID} == 8* ]]; then
		dnf -y install kmod-wireguard
	fi
elif [[ ${OS} == 'centos' ]]; then
	yum -y install epel-release elrepo-release
	if [[ ${VERSION_ID} -eq 7 ]]; then
		yum -y install yum-plugin-elrepo
	fi
	yum -y install kmod-wireguard wireguard-tools iptables qrencode
elif [[ ${OS} == 'oracle' ]]; then
	dnf install -y oraclelinux-developer-release-el8
	dnf config-manager --disable -y ol8_developer
	dnf config-manager --enable -y ol8_developer_UEKR6
	dnf config-manager --save -y --setopt=ol8_developer_UEKR6.includepkgs='wireguard-tools*'
	dnf install -y wireguard-tools qrencode iptables
elif [[ ${OS} == 'arch' ]]; then
	pacman -S --needed --noconfirm wireguard-tools qrencode
fi

# Make sure the directory exists (this does not seem the be the case on fedora)
mkdir -p /etc/wireguard
chmod 600 -R /etc/wireguard/

# Generate server keys
SERVER_PRIV_KEY=$(wg genkey)
SERVER_PUB_KEY=$(echo "${SERVER_PRIV_KEY}" | wg pubkey)

# Pilih port utama 443
SERVER_PORT=443

# Save WireGuard settings
cat > /etc/wireguard/params <<EOF
SERVER_PUB_NIC=$SERVER_PUB_NIC
SERVER_WG_NIC=wg0
SERVER_WG_IPV4=10.66.66.1
SERVER_PORT=$SERVER_PORT
SERVER_PRIV_KEY=$SERVER_PRIV_KEY
SERVER_PUB_KEY=$SERVER_PUB_KEY
EOF

source /etc/wireguard/params

# Buat server interface config
cat > /etc/wireguard/wg0.conf <<EOF
[Interface]
Address = $SERVER_WG_IPV4/24
ListenPort = $SERVER_PORT
PrivateKey = $SERVER_PRIV_KEY

PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o $SERVER_PUB_NIC -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o $SERVER_PUB_NIC -j MASQUERADE
EOF

# Iptables rules untuk WireGuard
iptables -t nat -I POSTROUTING -s 10.66.66.0/24 -o $SERVER_PUB_NIC -j MASQUERADE
iptables -I INPUT 1 -i wg0 -j ACCEPT
iptables -I FORWARD 1 -i $SERVER_PUB_NIC -o wg0 -j ACCEPT
iptables -I FORWARD 1 -i wg0 -o $SERVER_PUB_NIC -j ACCEPT
iptables -I INPUT 1 -i $SERVER_PUB_NIC -p udp --dport $SERVER_PORT -j ACCEPT

# Tambah redirect supaya UDP 80 → 443 (satu interface je)
iptables -t nat -A PREROUTING -i $SERVER_PUB_NIC -p udp --dport 80 -j REDIRECT --to-ports $SERVER_PORT

# Simpan rules
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# Enable dan start WireGuard
systemctl enable wg-quick@wg0
systemctl restart wg-quick@wg0

# Check status
systemctl is-active --quiet "wg-quick@wg0"
WG_RUNNING=$?

rm -f /root/wg.sh 2>/dev/null
