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

# // Exporting IP Address
export IP=$( curl -s https://ipinfo.io/ip/ )
# // OpenSSH
openssh=$( systemctl status ssh | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $openssh == "running" ]]; then
    status_openssh="${GREEN}Running${NC}"
else
    status_openssh="${RED}Error${NC}"
fi
# // Stunnel5
stunnel5=$( systemctl status stunnel4 | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $stunnel5 == "running" ]]; then
    status_stunnel5="${GREEN}Running${NC}"
else
    status_stunnel5="${RED}Error${NC}"
fi
# // Dropbear
dropbear=$( systemctl status dropbear | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $dropbear == "running" ]]; then
    status_dropbear="${GREEN}Running${NC}"
else
    status_dropbear="${RED}Error${NC}"
fi
# // Squid
squid=$( systemctl status squid | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $squid == "running" ]]; then
    status_squid="${GREEN}Running${NC}"
else
    status_squid="${RED}Error${NC}"
fi
# // SSH Websocket Proxy
ssh_ws=$( systemctl status ws-stunnel | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $ssh_ws == "running" ]]; then
    status_ws_epro="${GREEN}Running${NC}"
else
    status_ws_epro="${RED}Error${NC}"
fi
# // Vless Proxy
vl="$(systemctl show xray --no-page)"
vless=$(echo "${vl}" | grep 'ActiveState=' | cut -f2 -d=)
if [[ $vless == "active" ]]; then
    status_vless="${GREEN}Running${NC}"
else
    status_vless="${RED}Error${NC}"
fi
# // Vmess Proxy
vm="$(systemctl show xray@vmess --no-page)"
vmess=$(echo "${vm}" | grep 'ActiveState=' | cut -f2 -d=)
if [[ $vmess == "active" ]]; then
    status_vmess="${GREEN}Running${NC}"
else
    status_vmess="${RED}Error${NC}"
fi
# // Trojan Proxy
tro="$(systemctl show xray@trojan --no-page)"
trojan=$(echo "${tro}" | grep 'ActiveState=' | cut -f2 -d=)
if [[ $trojan == "active" ]]; then
    status_trojan="${GREEN}Running${NC}"
else
    status_trojan="${RED}Error${NC}"
fi
# // Sodosok Proxy
sodo="$(systemctl show xray@sodosok --no-page)"
sodosok=$(echo "${sodo}" | grep 'ActiveState=' | cut -f2 -d=)
if [[ $sodosok == "active" ]]; then
    status_sodosok="${GREEN}Running${NC}"
else
    status_sodosok="${RED}Error${NC}"
fi
# // NGINX
ngi="$(systemctl show nginx --no-page)"
nginx1=$(echo "${ngi}" | grep 'ActiveState=' | cut -f2 -d=)
if [[ $nginx1 == "active" ]]; then
    status_nginx="${GREEN}Running${NC}"
else
    status_nginx="${RED}Error${NC}"
fi

# // Wireguard
swg="$(systemctl show wg-quick@wg0.service --no-page)"
wg=$(echo "${swg}" | grep 'ActiveState=' | cut -f2 -d=)
if [[ $wg == "active" ]]; then
    status_wireguard="${GREEN}Running${NC}"
else
    status_wireguard="${RED}Error${NC}"
fi

# // Adguards
ads=$( systemctl status dnsmasq | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $ads == "running" ]]; then
    status_adguard="${GREEN}Running${NC}"
elif [[ $ads == "dead" ]]; then
    status_adguard="${RED}Error${NC}"
else
    status_adguard="${blue}Adguard Service Not Install${NC}"
fi

# // Clear
clear
echo -e "\033[0;34m------------------------------------\033[0m"
echo -e "\E[44;1;39m     STATUS SERVICE INFORMATION     \E[0m"
echo -e "\033[0;34m------------------------------------\033[0m"
echo -e "Sever Uptime        : $( uptime -p  | cut -d " " -f 2-10000 ) "
echo -e "Current Time        : $( date -d "0 days" +"%d-%m-%Y %X" )"
echo -e "\033[0;34m------------------------------------\033[0m"
echo -e "    $PURPLE Service        :  Status$NC"
echo -e "\033[0;34m------------------------------------\033[0m"
echo -e "Wireguard           : $status_wireguard"
echo -e "OpenSSH             : $status_openssh"
echo -e "Dropbear            : $status_dropbear"
echo -e "Stunnel5            : $status_stunnel5"
echo -e "Squid               : $status_squid"
echo -e "NGINX               : $status_nginx"
echo -e "SSH NonTLS          : $status_ws_epro"
echo -e "SSH TLS             : $status_ws_epro"
echo -e "Vless WS/GRPC       : $status_vless"
echo -e "Vmess WS/GRPC       : $status_vmess"
echo -e "Trojan WS/GRPC      : $status_trojan"
echo -e "Shadowsocks WS/GRPC : $status_sodosok"
echo -e "Adguards Service    : $status_adguard"
echo -e "\033[0;34m------------------------------------\033[0m"