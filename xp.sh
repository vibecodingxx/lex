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

# ==================================================
#  Auto Remove Expired Users (SSH, Xray, WireGuard)
# ==================================================

TODAY=`date +"%Y-%m-%d"`
TODAY_HUMAN=`date +%d-%m-%Y`

# ------------------------------
#  Fungsi Hapus SSH Expired
# ------------------------------
remove_ssh_expired() {
    local EXPIRELIST="/tmp/expirelist.txt"
    cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > "$EXPIRELIST"
    local TOTAL=$(wc -l < "$EXPIRELIST")

    for ((i=1; i<=TOTAL; i++)); do
        local TUSERVAL=$(sed -n "${i}p" "$EXPIRELIST")
        local USERNAME=$(echo "$TUSERVAL" | cut -f1 -d:)
        local USEREXP=$(echo "$TUSERVAL" | cut -f2 -d:)
        local USEREXPIRE_SEC=$(( USEREXP * 86400 ))

        if [ $USEREXPIRE_SEC -lt $(date +%s) ]; then
            echo "Expired - SSH user: $USERNAME removed on: $TODAY_HUMAN"
            userdel --force "$USERNAME"
        fi
    done
}

# ------------------------------
#  Fungsi Hapus Xray Expired
# ------------------------------
remove_xray_expired() {
    local PROTOCOL=$1
    local CONFIG="/usr/local/etc/xray/${PROTOCOL}.json"
    local TODAY=$(date +%Y-%m-%d)

    if [[ ! -f "$CONFIG" ]]; then
        echo "Config file $CONFIG not found!"
        return
    fi

    local USERS=($(grep '^###' "$CONFIG" | awk '{print $2}' | sort -u))

    for USER in "${USERS[@]}"; do
        local EXP=$(grep -w "^### $USER" "$CONFIG" | awk '{print $3}' | sort -u)
        local D1=$(date -d "$EXP" +%s)
        local D2=$(date -d "$TODAY" +%s)
        local REMAIN=$(( (D1 - D2) / 86400 ))

        if [[ "$REMAIN" -le 0 ]]; then
            echo "Expired - $PROTOCOL user: $USER removed"
            # Buang block dari ### username expiry sampai "email": "username"
            sed -i "/^### $USER $EXP/,/\"email\": \"$USER\"/d" "$CONFIG"

            # Buang yaml/user file
            rm -rf /home/vps/public_html/$USER*

            # Extra untuk vmess (config tambahan)
            if [[ "$PROTOCOL" == "vmess" ]]; then
                rm -f /etc/xray/$USER-tls.json /etc/xray/$USER-none.json
            fi
        fi
    done
}

# ------------------------------
#  Fungsi Hapus WireGuard Expired
# ------------------------------
remove_wg_expired() {
    local CONFIG="/etc/wireguard/wg0.conf"
    local USERS=($(grep '^### Client' "$CONFIG" | awk '{print $3}'))

    for USER in "${USERS[@]}"; do
        local EXP=$(grep -w "^### Client $USER" "$CONFIG" | awk '{print $4}')
        local D1=$(date -d "$EXP" +%s)
        local D2=$(date -d "$TODAY" +%s)
        local REMAIN=$(( (D1 - D2) / 86400 ))

        if [[ "$REMAIN" -eq 0 ]]; then
            echo "Expired - WireGuard client: $USER removed"
            sed -i "/^### Client $USER $EXP/,/^AllowedIPs/d" "$CONFIG"
            rm -f /home/vps/public_html/$USER.conf
        fi
    done
}

# ------------------------------
#  Jalankan Fungsi
# ------------------------------
remove_ssh_expired
remove_xray_expired "vmess"
remove_xray_expired "vless"
remove_xray_expired "trojan"
remove_xray_expired "sodosok"
remove_wg_expired

# ------------------------------
#  Restart Semua Service
# ------------------------------
systemctl restart wg-quick@wg0
systemctl restart xray
systemctl restart xray@vmess
systemctl restart xray@trojan
systemctl restart xray@sodosok
