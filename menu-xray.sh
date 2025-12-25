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
multipath_status() {
    CONF="/etc/nginx/conf.d/xray.conf"

    if grep -q 'upstream ws_backend' "$CONF"; then
        echo "FULL"
    elif grep -q 'if (\$http_upgrade = "websocket")' "$CONF"; then
        echo "SINGLE"
    else
        echo "OFF"
    fi
}

MTS=$(multipath_status)

case "$MTS" in
    FULL)
        COLOR="\e[0;32m"   # Hijau
        STATUS_TEXT="ON - FULL WS"

        ANP="anypath"
        VLP="anypath"
        VMP="anypath"
        TRP="anypath"
        SSP="anypath"

        VLP1="/"
        VMP1="/"
        TRP1="/"
        SSP1="/"
        ;;
        
    SINGLE)
        COLOR="\e[0;33m"   # Kuning
        STATUS_TEXT="ON - VLESS WS"

        ANP="VL anypath,else default or any/default"
        VLP="anypath"
        VMP="/vmessws or any/vmessws"
        TRP="/trojan-ws or any/trojan-ws"
        SSP="/ss-ws or any/ss-ws"

        VLP1="/vlessws"
        VMP1="/vmessws"
        TRP1="/trojan-ws"
        SSP1="/ss-ws"
        ;;

    OFF|*)
        COLOR="\e[0;31m"   # Merah
        STATUS_TEXT="OFF"

        ANP="default or any/default"
        VLP="/vlessws or any/vlessws"
        VMP="/vmessws or any/vmessws"
        TRP="/trojan-ws or any/trojan-ws"
        SSP="/ss-ws or any/ss-ws"

        VLP1="/vlessws"
        VMP1="/vmessws"
        TRP1="/trojan-ws"
        SSP1="/ss-ws"
        ;;
esac

add_data() {
    echo -e "1) Bug Domain (Wildcard / Direct)"
    echo -e "2) Use IP as Address"
    read -p "Your Option? 1/2 or press enter to continue : " ans

    # Tekan Enter ? default
    if [[ -z "$ans" ]]; then
        BUG="isi_bug_disini"
        wild=""
        return
    fi

    if [[ "$ans" == "2" ]]; then
        domain=$MYIP
        BUG="isi_bug_disini"
        wild=""
    else
        domain=$(cat /root/domain 2>/dev/null)

        echo -e "Select Bug Mode:"
        echo -e "1) Wildcard"
        echo -e "2) Direct"
        read -p "Your Option? 1/2 or press enter to continue : " bug_mode
        if [[ -z "$bug_mode" ]]; then
            BUG="isi_bug_disini"
            wild=""
        else
            if [[ "$bug_mode" == "1" ]]; then
                USE_WILD=true
            else
                USE_WILD=false
            fi
            BUG="isi_bug_disini"
        fi
    fi

    if [[ -d /root/bug ]]; then
        # Pilih Telco
        telco_dirs=(/root/bug/*)
        telco_choices=()
        for d in "${telco_dirs[@]}"; do
            [[ -f "$d" ]] || continue
            telco_choices+=("$(basename "$d" | sed 's/\..*$//')")
        done
        telco_choices+=("Manual input")

        echo -e "\nSelect Telco:"
        i=1
        for t in "${telco_choices[@]}"; do
            echo "$i) $t"
            ((i++))
        done

        read -p "Your choice or press enter to continue : " telco_ans
        if [[ -z "$telco_ans" ]]; then
            BUG="isi_bug_disini"
        else
            choice="${telco_choices[$((telco_ans-1))]}"
            if [[ "$choice" == "Manual input" ]]; then
                read -p "Enter BUG manually: " BUG
                [[ -z "$BUG" ]] && BUG="isi_bug_disini"
            else
                file_bug=$(ls /root/bug/"$choice"* 2>/dev/null | head -n1)
                if [[ -f "$file_bug" ]]; then
                    mapfile -t bugs < "$file_bug"
                    bugs+=("Manual input")

                    echo -e "\nAvailable BUGs for $choice:"
                    i=1
                    for b in "${bugs[@]}"; do
                        echo "$i) $b"
                        ((i++))
                    done

                    read -p "Select BUG or press enter to continue : " bug_ans
                    if [[ -z "$bug_ans" ]]; then
                        BUG="isi_bug_disini"
                    else
                        BUG="${bugs[$((bug_ans-1))]}"
                        if [[ "$BUG" == "Manual input" ]]; then
                            read -p "Enter BUG manually: " BUG
                            [[ -z "$BUG" ]] && BUG="isi_bug_disini"
                        fi
                    fi
                else
                    BUG="isi_bug_disini"
                fi
            fi
        fi
    else
        read -p "Enter BUG or press enter to continue : " BUG
        [[ -z "$BUG" ]] && BUG="isi_bug_disini"
    fi

    if [[ "$ans" == "1" && "$USE_WILD" == true ]]; then
        [[ -n "$BUG" && "$BUG" != "isi_bug_disini" ]] && wild="${BUG}." || wild=""
    else
        wild=""
    fi
}

trojan_yaml() {
    local type="$1" # ntls / tls
    local file_suffix port sni host_header

    if [[ "$type" == "ntls" ]]; then
        file_suffix="_trojanntls.yaml"
        port="${tr2}"
        sni="trojan-ws"
        host_header="isi_bug_disini"
    else
        file_suffix="_trojantls.yaml"
        port="${tr}"
        sni="isi_bug_disini"
        host_header=""
    fi

    cat << EOF >> /home/vps/public_html/${user}${file_suffix}
#Yaml MOD by VPN vibecodingxx
port: 7890
socks-port: 7891
redir-port: 7892
mixed-port: 7893
tproxy-port: 7895
ipv6: false
mode: rule
log-level: silent
allow-lan: true
external-controller: 0.0.0.0:9090
secret: ""
bind-address: "*"
unified-delay: true
profile:
  store-selected: true
  store-fake-ip: true
dns:
  enable: true
  ipv6: false
  use-host: true
  enhanced-mode: fake-ip
  listen: 0.0.0.0:7874
  nameserver:
    - 8.8.8.8
    - 1.0.0.1
    - https://dns.google/dns-query
  fallback:
    - 1.1.1.1
    - 8.8.4.4
    - https://cloudflare-dns.com/dns-query
    - 112.215.203.254
  default-nameserver:
    - 8.8.8.8
    - 1.1.1.1
    - 112.215.203.254
  fake-ip-range: 198.18.0.1/16
  fake-ip-filter:
    - "*.lan"
    - "*.localdomain"
    - "*.example"
    - "*.invalid"
    - "*.localhost"
    - "*.test"
    - "*.local"
    - "*.home.arpa"
    - time.*.com
    - time.*.gov
    - time.*.edu.cn
    - time.*.apple.com
    - time1.*.com
    - time2.*.com
    - time3.*.com
    - time4.*.com
    - time5.*.com
    - time6.*.com
    - time7.*.com
    - ntp.*.com
    - ntp1.*.com
    - ntp2.*.com
    - ntp3.*.com
    - ntp4.*.com
    - ntp5.*.com
    - ntp6.*.com
    - ntp7.*.com
    - "*.time.edu.cn"
    - "*.ntp.org.cn"
    - +.pool.ntp.org
    - time1.cloud.tencent.com
    - music.163.com
    - "*.music.163.com"
    - "*.126.net"
    - musicapi.taihe.com
    - music.taihe.com
    - songsearch.kugou.com
    - trackercdn.kugou.com
    - "*.kuwo.cn"
    - api-jooxtt.sanook.com
    - api.joox.com
    - joox.com
    - y.qq.com
    - "*.y.qq.com"
    - streamoc.music.tc.qq.com
    - mobileoc.music.tc.qq.com
    - isure.stream.qqmusic.qq.com
    - dl.stream.qqmusic.qq.com
    - aqqmusic.tc.qq.com
    - amobile.music.tc.qq.com
    - "*.xiami.com"
    - "*.music.migu.cn"
    - music.migu.cn
    - "*.msftconnecttest.com"
    - "*.msftncsi.com
    - msftconnecttest.com
    - msftncsi.com
    - localhost.ptlogin2.qq.com
    - localhost.sec.qq.com
    - +.srv.nintendo.net
    - +.stun.playstation.net
    - xbox.*.microsoft.com
    - xnotify.xboxlive.com
    - +.battlenet.com.cn
    - +.wotgame.cn
    - +.wggames.cn
    - +.wowsgame.cn
    - +.wargaming.net
    - proxy.golang.org
    - stun.*.*
    - stun.*.*.*
    - +.stun.*.*
    - +.stun.*.*.*
    - +.stun.*.*.*.*
    - heartbeat.belkin.com
    - "*.linksys.com"
    - "*.linksyssmartwifi.com"
    - "*.router.asus.com"
    - mesu.apple.com
    - swscan.apple.com
    - swquery.apple.com
    - swdownload.apple.com
    - swcdn.apple.com
    - swdist.apple.com
    - lens.l.google.com
    - stun.l.google.com
    - +.nflxvideo.net
    - "*.square-enix.com"
    - "*.finalfantasyxiv.com"
    - "*.ffxiv.com"
    - "*.mcdn.bilivideo.cn"
    - +.media.dssott.com
proxies:
  - name: ${user}
    server: ${wild}${domain}
    port: ${port}
    type: trojan
    password: ${uuid}
    skip-cert-verify: true
    sni: ${sni}
    network: ws
    ws-opts:
      path: $TRP
      headers:
        Host: ${host_header}
    udp: true
proxy-groups:
  - name: YAML-VPN-vibecodingxx
    type: select
    proxies:
      - ${user}
      - DIRECT
rules:
  - MATCH,YAML-VPN-vibecodingxx
EOF
}

generate_yaml() {
    local proto="$1"
    local mode="$2"
    local file
    local port
    local tls_flag
    local sni
    local host_header
    local path_ws

    if [[ "$proto" == "vless" ]]; then
        path_ws="${VLP1}"
    else
        path_ws="${VMP1}"
    fi

    if [[ "$mode" == "tls" ]]; then
        file="/home/vps/public_html/${user}_${proto}tls.yaml"
        port="${tls}"
        tls_flag="true"
        sni="isi_bug_disini"
        host_header="${domain}"
    else
        file="/home/vps/public_html/${user}_${proto}ntls.yaml"
        port="${none}"
        tls_flag="false"
        sni=""
        host_header="isi_bug_disini"
    fi

    cat << EOF > "$file"
#Yaml MOD by VPN vibecodingxx
port: 7890
socks-port: 7891
redir-port: 7892
mixed-port: 7893
tproxy-port: 7895
ipv6: false
mode: rule
log-level: silent
allow-lan: true
external-controller: 0.0.0.0:9090
secret: ""
bind-address: "*"
unified-delay: true
profile:
  store-selected: true
  store-fake-ip: true
dns:
  enable: true
  ipv6: false
  use-host: true
  enhanced-mode: fake-ip
  listen: 0.0.0.0:7874
  nameserver:
    - 8.8.8.8
    - 1.0.0.1
    - https://dns.google/dns-query
  fallback:
    - 1.1.1.1
    - 8.8.4.4
    - https://cloudflare-dns.com/dns-query
    - 112.215.203.254
  default-nameserver:
    - 8.8.8.8
    - 1.1.1.1
    - 112.215.203.254
  fake-ip-range: 198.18.0.1/16
  fake-ip-filter:
    - "*.lan"
    - "*.localdomain"
    - "*.example"
    - "*.invalid"
    - "*.localhost"
    - "*.test"
    - "*.local"
    - "*.home.arpa"
    - time.*.com
    - time.*.gov
    - time.*.edu.cn
    - time.*.apple.com
    - time1.*.com
    - time2.*.com
    - time3.*.com
    - time4.*.com
    - time5.*.com
    - time6.*.com
    - time7.*.com
    - ntp.*.com
    - ntp1.*.com
    - ntp2.*.com
    - ntp3.*.com
    - ntp4.*.com
    - ntp5.*.com
    - ntp6.*.com
    - ntp7.*.com
    - "*.time.edu.cn"
    - "*.ntp.org.cn"
    - +.pool.ntp.org
    - time1.cloud.tencent.com
    - music.163.com
    - "*.music.163.com"
    - "*.126.net"
    - musicapi.taihe.com
    - music.taihe.com
    - songsearch.kugou.com
    - trackercdn.kugou.com
    - "*.kuwo.cn"
    - api-jooxtt.sanook.com
    - api.joox.com
    - joox.com
    - y.qq.com
    - "*.y.qq.com"
    - streamoc.music.tc.qq.com
    - mobileoc.music.tc.qq.com
    - isure.stream.qqmusic.qq.com
    - dl.stream.qqmusic.qq.com
    - aqqmusic.tc.qq.com
    - amobile.music.tc.qq.com
    - "*.xiami.com"
    - "*.music.migu.cn"
    - music.migu.cn
    - "*.msftconnecttest.com"
    - "*.msftncsi.com"
    - msftconnecttest.com
    - msftncsi.com
    - localhost.ptlogin2.qq.com
    - localhost.sec.qq.com
    - +.srv.nintendo.net
    - +.stun.playstation.net
    - xbox.*.microsoft.com
    - xnotify.xboxlive.com
    - +.battlenet.com.cn
    - +.wotgame.cn
    - +.wggames.cn
    - +.wowsgame.cn
    - +.wargaming.net
    - proxy.golang.org
    - stun.*.*
    - stun.*.*.*
    - +.stun.*.*
    - +.stun.*.*.*
    - +.stun.*.*.*.*
    - heartbeat.belkin.com
    - "*.linksys.com"
    - "*.linksyssmartwifi.com"
    - "*.router.asus.com"
    - mesu.apple.com
    - swscan.apple.com
    - swquery.apple.com
    - swdownload.apple.com
    - swcdn.apple.com
    - swdist.apple.com
    - lens.l.google.com
    - stun.l.google.com
    - +.nflxvideo.net
    - "*.square-enix.com"
    - "*.finalfantasyxiv.com"
    - "*.ffxiv.com"
    - "*.mcdn.bilivideo.cn"
    - +.media.dssott.com
proxies:
  - name: ${user}
    server: ${wild}${domain}
    port: ${port}
    type: ${proto}
    uuid: ${uuid}
    $( [[ "$proto" == "vmess" ]] && echo "alterId: 0" )
    cipher: auto
    tls: ${tls_flag}
    skip-cert-verify: true
    servername: ${sni}
    network: ws
    ws-opts:
      path: ${path_ws}
      headers:
        Host: ${host_header}
    udp: true
proxy-groups:
  - name: YAML-VPN-vibecodingxx
    type: select
    proxies:
      - ${user}
      - DIRECT
rules:
  - MATCH,YAML-VPN-vibecodingxx
EOF
}

sodosok() {
    local type=$1
    local file="/home/vps/public_html/${user}-${type}"
    local sniff="false"
    local mux="false"
    local network="ws"
    local security="none"
    local portnum=${none}
    local extra_settings='
        "wsSettings": {
          "headers": {
            "Host": "'"${BUG}"'"
          },
          "path": "${SSP1}"
        }'

    if [[ $type == "TLS" ]]; then
        sniff="true"
        mux="true"
        security="tls"
        portnum=${tls}
        extra_settings='
        "tlsSettings": {
          "allowInsecure": true,
          "serverName": "'"${BUG}"'"
        },
        "wsSettings": {
          "headers": {
            "Host": "'"${domain}"'"
          },
          "path": "${SSP1}"
        }'
    elif [[ $type == "gRPC" ]]; then
        sniff="true"
        mux="true"
        network="grpc"
        security="tls"
        portnum=${tls}
        extra_settings='
        "grpcSettings": {
          "multiMode": true,
          "serviceName": "ss-grpc"
        },
        "tlsSettings": {
          "allowInsecure": true,
          "serverName": "'"${BUG}"'"
        }'
    fi

cat <<EOF >"$file"
{
  "dns": {
    "servers": [
      "8.8.8.8",
      "8.8.4.4"
    ]
  },
 "inbounds": [
   {
      "port": 10808,
      "protocol": "socks",
      "settings": {
        "auth": "noauth",
        "udp": true,
        "userLevel": 8
      },
      "sniffing": {
        "destOverride": [
          "http",
          "tls"
        ],
        "enabled": ${sniff}
      },
      "tag": "socks"
    },
    {
      "port": 10809,
      "protocol": "http",
      "settings": {
        "userLevel": 8
      },
      "tag": "http"
    }
  ],
  "log": {
    "loglevel": "none"
  },
  "outbounds": [
    {
      "mux": {
        "enabled": ${mux}
      },
      "protocol": "shadowsocks",
      "settings": {
        "servers": [
          {
            "address": "${wild}${domain}",
            "level": 8,
            "method": "aes-128-gcm",
            "password": "${uuid}",
            "port": ${portnum}
          }
        ]
      },
      "streamSettings": {
        "network": "${network}",
        "security": "${security}",${extra_settings}
      },
      "tag": "proxy"
    },
    {
      "protocol": "freedom",
      "settings": {},
      "tag": "direct"
    },
    {
      "protocol": "blackhole",
      "settings": {
        "response": {
          "type": "http"
        }
      },
      "tag": "block"
    }
  ],
  "policy": {
    "levels": {
      "8": {
        "connIdle": 300,
        "downlinkOnly": 1,
        "handshake": 4,
        "uplinkOnly": 1
      }
    },
    "system": {
      "statsOutboundUplink": true,
      "statsOutboundDownlink": true
    }
  },
  "routing": {
    "domainStrategy": "Asls",
    "rules": []
  },
  "stats": {}
}
EOF
}

# ===== Helper untuk generate config & link =====

generate_vmess_links() {
source /var/lib/premium-script/ipvps.conf
    [[ "$IP" = "" ]] && domain=$(cat /root/domain) || domain=$IP
    tls_port=$(grep -w "Vmess TLS" ~/log-install.txt | cut -d: -f2 | tr -d ' ' | cut -d, -f1)
    none_port=$(grep -w "Vmess None TLS" ~/log-install.txt | cut -d: -f2 | tr -d ' ' | cut -d, -f1)
    none_port1=$(grep -w "Vmess None TLS" ~/log-install.txt | cut -d: -f2 | tr -d ' ')
    local user="$1"
    local uuid="$2"
    local domain="$3"

    asu=$(cat <<EOF
{
  "v": "2",
  "ps": "${user}",
  "add": "${wild}${domain}",
  "port": "${tls_port}",
  "id": "${uuid}",
  "aid": "0",
  "net": "ws",
  "path": "${VMP1}",
  "type": "none",
  "host": "${BUG}",
  "tls": "tls"
}
EOF
)

    ask=$(cat <<EOF
{
  "v": "2",
  "ps": "${user}",
  "add": "${wild}${domain}",
  "port": "${none_port}",
  "id": "${uuid}",
  "aid": "0",
  "net": "ws",
  "path": "${VMP1}",
  "type": "none",
  "host": "${BUG}",
  "tls": "none"
}
EOF
)

    grpc=$(cat <<EOF
{
  "v": "2",
  "ps": "${user}",
  "add": "${wild}${domain}",
  "port": "${tls_port}",
  "id": "${uuid}",
  "aid": "0",
  "net": "grpc",
  "path": "vmess-grpc",
  "type": "none",
  "host": "${BUG}",
  "tls": "tls"
}
EOF
)

    vmesslink1="vmess://$(echo "$asu" | base64 -w 0)"
    vmesslink2="vmess://$(echo "$ask" | base64 -w 0)"
    vmesslink3="vmess://$(echo "$grpc" | base64 -w 0)"
}

# ===== Helper untuk print output =====
print_vmess_info() {
    local user="$1" uuid="$2" hariini="$3" exp="$4"
    local vmessyamltls="$5" vmessyamlntls="$6"

    clear
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "\E[44;1;39m        User Xray Vmess Account     \E[0m"
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "Remarks       : ${user}"
    echo -e "IP Address    : ${MYIP}"
    echo -e "Domain        : ${domain}"
    echo -e "Port TLS      : ${tls_port}"
    echo -e "Port GRPC     : ${tls_port}"
    echo -e "Port none TLS : ${none_port1}"
    echo -e "Path WS       : ${VMP}"
    echo -e "id            : ${uuid}"
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "Link TLS :"
    echo -e '```'
    echo -e "${vmesslink1}"
    echo -e '```'
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "Link none TLS :"
    echo -e '```'
    echo -e "${vmesslink2}"
    echo -e '```'
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "Link GRPC :"
    echo -e '```'
    echo -e "${vmesslink3}"
    echo -e '```'
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "Link Yaml TLS :"
    echo -e ""
    echo -e "${vmessyamltls}"
    echo -e ""
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "Link Yaml none TLS :"
    echo -e ""
    echo -e "${vmessyamlntls}"
    echo -e ""
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "Created On    : $hariini"
    echo -e "Expired On    : $exp"
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo ""
}

# ===== Trial VMess =====
trial-vmess() {
    clear
    until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
        echo -e "\033[0;34m-------------------------------\033[0m"
        echo -e "\E[44;1;39m    Trial Xray Vmess Account   \E[0m"
        echo -e "\033[0;34m-------------------------------\033[0m"
        user="VMESS$(</dev/urandom tr -dc X-Z0-9 | head -c4)"
        CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/vmess.json | wc -l)
        [[ ${CLIENT_EXISTS} == '1' ]] && menu-xray
        add_data
    done

    masaaktif=1
    uuid=$(cat /proc/sys/kernel/random/uuid)
    hariini=$(date +"%Y-%m-%d")
    exp=$(date -d "$masaaktif days" +"%Y-%m-%d")

    sed -i '/#vmess$/a\### '"$user $exp"'\
    },{"id": "'""$uuid""'","alterId": 0,"email": "'""$user""'"' /usr/local/etc/xray/vmess.json
    sed -i '/#vmessgrpc$/a\### '"$user $exp"'\
    },{"id": "'""$uuid""'","alterId": 0,"email": "'""$user""'"' /usr/local/etc/xray/vmess.json

    generate_vmess_links "$user" "$uuid" "$domain"
    rm -rf /home/vps/public_html/${user}*
    generate_yaml vmess tls
    generate_yaml vmess ntls
    vmessyamltls=http://$MYIP:81/${user}_vmesstls.yaml
    vmessyamlntls=http://$MYIP:81/${user}_vmessntls.yaml

    systemctl restart xray >/dev/null 2>&1
    systemctl restart xray@vmess >/dev/null 2>&1
    service cron restart >/dev/null 2>&1

    print_vmess_info "$user" "$uuid" "$hariini" "$exp" "$vmessyamltls" "$vmessyamlntls"
    read -n 1 -s -r -p "Press any key to back on menu"
    menu-xray
}

# ===== Add VMess =====
add-vmess() {
    clear
    until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
        echo -e "\033[0;34m-------------------------------\033[0m"
        echo -e "\E[44;1;39m     Add Xray Vmess Account    \E[0m"
        echo -e "\033[0;34m-------------------------------\033[0m"
        read -rp "User: " -e user
        CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/vmess.json | wc -l)
        [[ ${CLIENT_EXISTS} == '1' ]] && menu-xray
        add_data
    done

    read -p "Expired (days): " masaaktif
    uuid=$(cat /proc/sys/kernel/random/uuid)
    hariini=$(date +"%Y-%m-%d")
    exp=$(date -d "$masaaktif days" +"%Y-%m-%d")

    sed -i '/#vmess$/a\### '"$user $exp"'\
    },{"id": "'""$uuid""'","alterId": 0,"email": "'""$user""'"' /usr/local/etc/xray/vmess.json
    sed -i '/#vmessgrpc$/a\### '"$user $exp"'\
    },{"id": "'""$uuid""'","alterId": 0,"email": "'""$user""'"' /usr/local/etc/xray/vmess.json

    generate_vmess_links "$user" "$uuid" "$domain"
    rm -rf /home/vps/public_html/${user}*
    generate_yaml vmess tls
    generate_yaml vmess ntls
    vmessyamltls=http://$MYIP:81/${user}_vmesstls.yaml
    vmessyamlntls=http://$MYIP:81/${user}_vmessntls.yaml

    systemctl restart xray >/dev/null 2>&1
    systemctl restart xray@vmess >/dev/null 2>&1
    service cron restart >/dev/null 2>&1

    print_vmess_info "$user" "$uuid" "$hariini" "$exp" "$vmessyamltls" "$vmessyamlntls"
    read -n 1 -s -r -p "Press any key to back on menu"
    menu-xray
}

# ===== Recreate VMess =====
recreate-vmess() {
    rm -rf /root/user_tmp.txt
    grep -E "^### " "/usr/local/etc/xray/vmess.json" | sort | uniq > /root/user_tmp.txt
    NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/root/user_tmp.txt")

    [[ ${NUMBER_OF_CLIENTS} == '0' ]] && echo "No clients found!" && exit 1

    clear
    echo "     No  User   Expired"
    grep -E "^### " "/root/user_tmp.txt" | cut -d ' ' -f 2-4 | nl -s ') '
    read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER

    user=$(grep -E "^### " "/root/user_tmp.txt" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
    exp=$(grep -w "$user" /root/user_tmp.txt | awk '{print $3}')
    hariini=$(date +"%Y-%m-%d")
    uuid=$(grep -w "$user" /usr/local/etc/xray/vmess.json | grep "id" | cut -d '"' -f4 | sort | uniq)
    add_data

    generate_vmess_links "$user" "$uuid" "$domain"
    rm -rf /home/vps/public_html/${user}*
    generate_yaml vmess tls
    generate_yaml vmess ntls
    vmessyamltls=http://$MYIP:81/${user}_vmesstls.yaml
    vmessyamlntls=http://$MYIP:81/${user}_vmessntls.yaml

    systemctl restart xray >/dev/null 2>&1
    systemctl restart xray@vmess >/dev/null 2>&1
    service cron restart >/dev/null 2>&1

    print_vmess_info "$user" "$uuid" "$hariini" "$exp" "$vmessyamltls" "$vmessyamlntls"

    rm -rf /root/user_tmp.txt
    rm -f /etc/xray/$user-tls.json /etc/xray/$user-none.json
    read -n 1 -s -r -p "Press any key to back on menu"
    menu-xray
}

vless_manage() {
    local mode=$1
    local user masaaktif exp hariini uuid domain domainn tls none vlesslink1 vlesslink2 vlesslink3 vlessyamltls vlessyamlntls CLIENT_EXISTS CLIENT_NUMBER

    clear
    source /var/lib/premium-script/ipvps.conf
    domain=$(cat /root/domain)
    domainn=$domain
    tls=$(grep -w "Vless TLS" ~/log-install.txt | cut -d: -f2 | tr -d ' ' | cut -d, -f1)
    none=$(grep -w "Vless None TLS" ~/log-install.txt | cut -d: -f2 | tr -d ' ' | cut -d, -f1)
    none1=$(grep -w "Vless None TLS" ~/log-install.txt | cut -d: -f2 | tr -d ' ')

    if [[ $mode == "trial" ]]; then
        until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
            echo -e "\033[0;34m------------------------------------\033[0m"
            echo -e "\E[44;1;39m       Trial Xray Vless Account     \E[0m"
            echo -e "\033[0;34m------------------------------------\033[0m"
            user="VLESS$(</dev/urandom tr -dc X-Z0-9 | head -c4)"
            CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/vless.json | wc -l)
            [[ ${CLIENT_EXISTS} == '1' ]] && menu-xray
            add_data
        done
        masaaktif=1

    elif [[ $mode == "add" ]]; then
        until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
            echo -e "\033[0;34m------------------------------------\033[0m"
            echo -e "\E[44;1;39m        Add Xray Vless Account      \E[0m"
            echo -e "\033[0;34m------------------------------------\033[0m"
            read -rp "User: " -e user
            CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/vless.json | wc -l)
            [[ ${CLIENT_EXISTS} == '1' ]] && menu-xray
            add_data
        done
        read -p "Expired (days): " masaaktif

    elif [[ $mode == "recreate" ]]; then
        rm -rf /root/user_tmp.txt
        grep -E "^### " "/usr/local/etc/xray/vless.json" | sort | uniq > /root/user_tmp.txt
        NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/root/user_tmp.txt")
        [[ ${NUMBER_OF_CLIENTS} == '0' ]] && { echo "No clients found!"; exit 1; }
        grep -E "^### " "/root/user_tmp.txt" | cut -d ' ' -f 2-4 | nl -s ') '
        read -rp "Select client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
        user=$(grep -E "^### " "/root/user_tmp.txt" | awk "NR==${CLIENT_NUMBER} {print \$2}")
        exp=$(grep -w "$user" /root/user_tmp.txt | awk '{print $3}')
        uuid=$(grep -w "$user" /usr/local/etc/xray/vless.json | grep "id" | cut -d'"' -f4 | sort -u)
        hariini=$(date +%Y-%m-%d)
        add_data
    fi

    # Data untuk user baru
    if [[ $mode != "recreate" ]]; then
        uuid=$(cat /proc/sys/kernel/random/uuid)
        hariini=$(date +%Y-%m-%d)
        exp=$(date -d "$masaaktif days" +"%Y-%m-%d")
        sed -i '/#vless$/a\### '"$user $exp"'\
        },{"id": "'$uuid'","email": "'$user'"' /usr/local/etc/xray/vless.json
        sed -i '/#vlessgrpc$/a\### '"$user $exp"'\
        },{"id": "'$uuid'","email": "'$user'"' /usr/local/etc/xray/vless.json
    fi

    # Link
    vlesslink1="vless://${uuid}@${wild}${domain}:$tls?path=${VLP1}&security=tls&encryption=none&type=ws&sni=${BUG}#${user}"
    vlesslink2="vless://${uuid}@${wild}${domain}:$none?path=${VLP1}&encryption=none&type=ws&host=${BUG}#${user}"
    vlesslink3="vless://${uuid}@${wild}${domain}:$tls?mode=gun&security=tls&encryption=none&type=grpc&serviceName=vless-grpc&sni=${BUG}#${user}"

    # Yaml
    rm -rf /home/vps/public_html/${user}*
    generate_yaml vless tls
    generate_yaml vless ntls
    vlessyamltls=http://$MYIP:81/${user}_vlesstls.yaml
    vlessyamlntls=http://$MYIP:81/${user}_vlessntls.yaml

    systemctl restart xray

    clear
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "\E[44;1;39m        User Xray Vless Account     \E[0m"
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "Remarks       : ${user}"
    echo -e "IP Address    : ${MYIP}"
    echo -e "Domain        : ${domainn}"
    echo -e "Port TLS      : ${tls}"
    echo -e "Port GRPC     : ${tls}"
    echo -e "Port none TLS : ${none1}"
    echo -e "Path WS       : ${VLP}"
    echo -e "id            : ${uuid}"
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "Link TLS :"
    echo -e '```'
    echo -e "${vlesslink1}"
    echo -e '```'
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "Link none TLS :"
    echo -e '```'
    echo -e "${vlesslink2}"
    echo -e '```'
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "Link GRPC :"
    echo -e '```'
    echo -e "${vlesslink3}"
    echo -e '```'
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "Link Yaml TLS :"
    echo -e ""
    echo -e "${vlessyamltls}"
    echo -e ""
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "Link Yaml none TLS :"
    echo -e ""
    echo -e "${vlessyamlntls}"
    echo -e ""
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "Created On    : $hariini"
    echo -e "Expired On    : $exp"
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo ""
    read -n 1 -s -r -p "Press any key to back on menu"
    menu-xray
}

trial-vless() { vless_manage trial; }
add-vless() { vless_manage add; }
recreate-vless() { vless_manage recreate; }

trojan_core() {
    local mode="$1" # trial / add / recreate
    clear
    source /var/lib/premium-script/ipvps.conf
    if [[ "$IP" = "" ]]; then
        domain=$(cat /root/domain)
    else
        domain=$IP
    fi
    domainn=$(cat /root/domain)
    tr=$( grep -w "Trojan TLS " ~/log-install.txt | cut -d: -f2 | tr -d ' ' | cut -d, -f1)
    tr2=$( grep -w "Trojan None TLS " ~/log-install.txt | cut -d: -f2 | tr -d ' ' | cut -d, -f1)
    tr3=$( grep -w "Trojan None TLS " ~/log-install.txt | cut -d: -f2 | tr -d ' ')

    if [[ "$mode" == "trial" ]]; then
        until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${user_EXISTS} == '0' ]]; do
            echo -e "\033[0;34m------------------------------------\033[0m"
            echo -e "\E[44;1;39m      Trial Xray Trojan Account     \E[0m"
            echo -e "\033[0;34m------------------------------------\033[0m"
            user=TROJAN`</dev/urandom tr -dc X-Z0-9 | head -c4`
            user_EXISTS=$(grep -w $user /usr/local/etc/xray/trojan.json | wc -l)
            add_data
        done
        masaaktif=1

    elif [[ "$mode" == "add" ]]; then
        until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${user_EXISTS} == '0' ]]; do
            echo -e "\033[0;34m------------------------------------\033[0m"
            echo -e "\E[44;1;39m       ADD Xray Trojan Account      \E[0m"
            echo -e "\033[0;34m------------------------------------\033[0m"
            read -rp "User: " -e user
            user_EXISTS=$(grep -w $user /usr/local/etc/xray/trojan.json | wc -l)
            add_data
        done
        read -p "Expired (days): " masaaktif

    elif [[ "$mode" == "recreate" ]]; then
        grep -E "^### " "/usr/local/etc/xray/trojan.json" | sort | uniq > /root/user_tmp.txt
        NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/root/user_tmp.txt")
        if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
            clear
            echo -e "\033[0;34m-------------------------------\033[0m"
            echo -e "\E[44;1;39m     Select Trojan Account     \E[0m"
            echo -e "\033[0;34m-------------------------------\033[0m"
            echo "You have no existing clients!"
            echo -e "\033[0;34m-------------------------------\033[0m"
            return
        fi
        clear
        echo -e "\033[0;34m-------------------------------\033[0m"
        echo -e "\E[44;1;39m     Select Trojan Account     \E[0m"
        echo -e "\033[0;34m-------------------------------\033[0m"
        echo "     No  User   Expired"
        grep -E "^### " "/root/user_tmp.txt" | cut -d ' ' -f 2-4 | nl -s ') '
        read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
        user=$(grep -E "^### " "/root/user_tmp.txt" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
        exp=$(grep -w "$user" /root/user_tmp.txt | awk '{print $3}')
        uuid=$(grep -w "$user" /usr/local/etc/xray/trojan.json | grep "password" | cut -d '"' -f4 | sort | uniq)
        hariini=$(date +%Y-%m-%d)
        rm -rf /root/user_tmp.txt
        add_data
        build_links
        return
    fi

    uuid=$(cat /proc/sys/kernel/random/uuid)
    hariini=$(date +%Y-%m-%d)
    exp=$(date -d "$masaaktif days" +"%Y-%m-%d")

    sed -i '/#trojanws$/a\### '"$user $exp"'\
},{"password": "'$uuid'","email": "'$user'"' /usr/local/etc/xray/trojan.json
    sed -i '/#trojangrpc$/a\### '"$user $exp"'\
},{"password": "'$uuid'","email": "'$user'"' /usr/local/etc/xray/trojan.json

    rm -rf /home/vps/public_html/${user}*
    trojan_yaml ntls
    trojan_yaml tls

    build_links
}

build_links() {
    trojanyamltls=http://$MYIP:81/${user}_trojantls.yaml
    trojanyamlntls=http://$MYIP:81/${user}_trojanntls.yaml
    trojanlink1="trojan://${uuid}@${wild}${domain}:${tr}?mode=gun&security=tls&type=grpc&serviceName=trojan-grpc&sni=$BUG#$user"
    trojanlink="trojan://${uuid}@${wild}${domain}:${tr}?path=${TRP1}&security=tls&host=&type=ws&sni=$BUG#${user}"
    trojanlink2="trojan://${uuid}@${wild}${domain}:${tr2}?security=none&type=ws&headerType=none&path=${TRP1}&host=$BUG#${user}"

    systemctl restart xray
    systemctl restart xray@trojan

    clear
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "\E[44;1;39m       User Xray Trojan Account     \E[0m"
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "Remarks       : ${user}"
    echo -e "IP Address    : ${MYIP}"
    echo -e "Domain        : ${domainn}"
    echo -e "Port TLS      : ${tr}"
    echo -e "Port GRPC     : ${tr}"
    echo -e "Port none TLS : ${tr3}"
    echo -e "Path WS       : ${TRP}"
    echo -e "id            : ${uuid}"
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "Link TLS :"
    echo -e '```'
    echo -e "${trojanlink}"
    echo -e '```'
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "Link None TLS :"
    echo -e '```'
    echo -e "${trojanlink2}"
    echo -e '```'
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "Link GRPC :"
    echo -e '```'
    echo -e "${trojanlink1}"
    echo -e '```'
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "Link Yaml TLS :"
    echo -e "${trojanyamltls}"
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "Link Yaml none TLS :"
    echo -e "${trojanyamlntls}"
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "Created On    : $hariini"
    echo -e "Expired On    : $exp"
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo ""
    read -n 1 -s -r -p "Press any key to back on menu"
    menu-xray
}

trial-trojan() { trojan_core trial; }
add-trojan() { trojan_core add; }
recreate-trojan() { trojan_core recreate; }

sodosok_core() {
    clear
    source /var/lib/premium-script/ipvps.conf
    if [[ "$IP" = "" ]]; then
        domain=$(cat /root/domain)
    else
        domain=$IP
    fi

    tls=$( grep -w "Sodosok TLS" ~/log-install.txt | cut -d: -f2 | tr -d ' ' | cut -d, -f1)
    none=$( grep -w "Sodosok None TLS" ~/log-install.txt | cut -d: -f2 | tr -d ' ' | cut -d, -f1)
    none1=$( grep -w "Sodosok None TLS" ~/log-install.txt | cut -d: -f2 | tr -d ' ')

    if [[ $1 == "trial" ]]; then
        until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
            echo -e "\033[0;34m------------------------------------\033[0m"
            echo -e "\E[44;1;39m   Trial Sodosok Ws/Grpc Account    \E[0m"
            echo -e "\033[0;34m------------------------------------\033[0m"
            user=SODOSOK`</dev/urandom tr -dc X-Z0-9 | head -c4`
            CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/sodosok.json | wc -l)
            if [[ ${CLIENT_EXISTS} == '1' ]]; then
                clear
                echo -e "\033[0;34m------------------------------------\033[0m"
                echo -e "\E[44;1;39m   Trial Sodosok Ws/Grpc Account    \E[0m"
                echo -e "\033[0;34m------------------------------------\033[0m"
                echo ""
                echo "A client with the specified name was already created, please choose another name."
                echo ""
                echo -e "\033[0;34m------------------------------------\033[0m"
                read -n 1 -s -r -p "Press any key to back on menu"
                menu-xray
            fi

        done
        masaaktif=1
    else
        until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
            echo -e "\033[0;34m------------------------------------\033[0m"
            echo -e "\E[44;1;39m     Add Sodosok Ws/Grpc Account    \E[0m"
            echo -e "\033[0;34m------------------------------------\033[0m"
            read -rp "User: " -e user
            CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/sodosok.json | wc -l)
            if [[ ${CLIENT_EXISTS} == '1' ]]; then
                clear
                echo -e "\033[0;34m------------------------------------\033[0m"
                echo -e "\E[44;1;39m     Add Sodosok Ws/Grpc Account    \E[0m"
                echo -e "\033[0;34m------------------------------------\033[0m"
                echo ""
                echo "A client with the specified name was already created, please choose another name."
                echo ""
                echo -e "\033[0;34m------------------------------------\033[0m"
                read -n 1 -s -r -p "Press any key to back on menu"
                menu-xray
            fi

        done
        read -p "Expired (days): " masaaktif
    fi

    add_data
    cipher="aes-128-gcm"
    uuid=$(cat /proc/sys/kernel/random/uuid)
    hariini=`date -d "0 days" +"%Y-%m-%d"`
    exp=`date -d "$masaaktif days" +"%Y-%m-%d"`

    sed -i '/#ssws$/a\### '"$user $exp"'\
    },{"password": "'""$uuid""'","method": "'""$cipher""'","email": "'""$user""'"' /usr/local/etc/xray/sodosok.json
    sed -i '/#ssgrpc$/a\### '"$user $exp"'\
    },{"password": "'""$uuid""'","method": "'""$cipher""'","email": "'""$user""'"' /usr/local/etc/xray/sodosok.json

    echo $cipher:$uuid > /tmp/log
    shadowsocks_base64=$(cat /tmp/log)
    echo -n "${shadowsocks_base64}" | base64 > /tmp/log1
    shadowsocks_base64e=$(cat /tmp/log1)

    rm -rf /tmp/log /tmp/log1

    sodosok "NTLS"
    sodosok "TLS"
    sodosok "gRPC"

    link="http://${MYIP}:81/${user}-TLS"
    link0="http://${MYIP}:81/${user}-NTLS"
    link1="http://${MYIP}:81/${user}-gRPC"

    systemctl restart xray > /dev/null 2>&1
    systemctl restart xray@sodosok > /dev/null 2>&1
    service cron restart > /dev/null 2>&1

    clear
    echo -e "\033[0;34m------------------------------------\033[0m"
    if [[ $1 == "trial" ]]; then
        echo -e "\E[44;1;39m   Trial Sodosok Ws/Grpc Account    \E[0m"
    else
        echo -e "\E[44;1;39m    User Sodosok Ws/Grpc Account    \E[0m"
    fi
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "Remarks       : ${user}"
    echo -e "IP Address    : ${MYIP}"
    echo -e "Domain        : ${domain}"
    echo -e "Port None TLS : ${none1}"
    echo -e "Port TLS      : ${tls}"
    echo -e "Port  GRPC    : ${tls}"
    echo -e "Password      : ${uuid}"
    echo -e "Cipers        : aes-128-gcm"
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "Link TLS :\n\n${link}"
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "Link none TLS :\n\n${link0}"
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "Link GRPC :\n\n${link1}"
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "Created On    : $hariini"
    echo -e "Expired On    : $exp"
    echo -e "\033[0;34m------------------------------------\033[0m\n"
    echo "DOWNLOAD FILE,OPEN WITH TEXT DOCUMENT,COPY & PASTE DI v2rayNG"
    echo "Custom Config"
    echo -e "\033[0;34m------------------------------------\033[0m"
    read -n 1 -s -r -p "Press any key to back on menu"
    menu-xray
}

trial-sodosok() { sodosok_core "trial"; }
add-sodosok() { sodosok_core "add"; }


check-port() {
echo -e "\033[0;34m------------------------------------------------------------\033[0m"
echo -e "\E[44;1;39m                        INFO SCRIPTS INSTALL                \E[0m"
echo -e "\033[0;34m------------------------------------------------------------\033[0m"
cat /root/log-install.txt
echo -e "\033[0;34m------------------------------------------------------------\033[0m"
    read -n 1 -s -r -p "Press any key to back on menu"
    menu-xray
}

trial-all() {
    clear
    source /var/lib/premium-script/ipvps.conf

    # Set domain
    if [[ -z "$IP" ]]; then
        domain=$(cat /root/domain)
    else
        domain=$IP
    fi

    # Ambil port dari log-install.txt
    tls=$(grep -w "Vmess TLS" ~/log-install.txt | cut -d: -f2 | tr -d ' ')
    none=$(grep -w "Vmess None TLS" ~/log-install.txt | cut -d: -f2 | tr -d ' ')
    none1=$( grep -w "Vmess None TLS" ~/log-install.txt | cut -d: -f2 | tr -d ' ')
    tr=$( grep -w "Trojan TLS " ~/log-install.txt | cut -d: -f2 | tr -d ' ' | cut -d, -f1)
    tr2=$( grep -w "Trojan None TLS " ~/log-install.txt | cut -d: -f2 | tr -d ' ' | cut -d, -f1)

    # Fungsi check duplicate semua protokol
    check_duplicate() {
        local user=$1
        local count=0
        for proto in vless vmess trojan sodosok; do
            [[ -f "/usr/local/etc/xray/${proto}.json" ]] && \
            count=$(( count + $(grep -w "$user" /usr/local/etc/xray/${proto}.json | wc -l) ))
        done
        echo $count
    }

    # Menu trial/add
    clear
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "\E[44;1;39m    Trial All Xray Account     \E[0m"
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo "1) Create Trial User"
    echo "2) Add User"
    echo -e "\033[0;34m-------------------------------\033[0m"
    read -rp "Please Input Your Option: " ans

    if [[ "$ans" == "1" ]]; then
        clear
        until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
            user=XRAYWS$(tr -dc X-Z0-9 < /dev/urandom | head -c4)
            masaaktif=1
            CLIENT_EXISTS=$(check_duplicate "$user")

            if [[ $CLIENT_EXISTS -ge 1 ]]; then
                echo -e "\nA client with the specified name was already created, generating another...\n"
                sleep 1
            fi
            add_data  # Pastikan fungsi add_data didefinisikan
        done

    elif [[ "$ans" == "2" ]]; then
        clear
        until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
            read -rp "User: " user
            read -p "Expired (days): " masaaktif
            CLIENT_EXISTS=$(check_duplicate "$user")

            if [[ $CLIENT_EXISTS -ge 1 ]]; then
                echo -e "\nA client with the specified name was already created, please choose another name.\n"
                sleep 1
            fi
            add_data
        done

    else
        echo "INPUT YOUR OPTION NUMBER!!!"
        sleep 2
        trial-all
        return
    fi

    # Generate UUID & tanggal
    cipher="aes-128-gcm"
    uuid=$(cat /proc/sys/kernel/random/uuid)
    hariini=$(date +"%Y-%m-%d")
    exp=$(date -d "$masaaktif days" +"%Y-%m-%d")

    # Tambah user ke semua JSON config
    sed -i '/#vmess$/a\### '"$user $exp"'\
    },{"id": "'""$uuid""'","alterId": 0,"email": "'""$user""'"' /usr/local/etc/xray/vmess.json
    sed -i '/#vmessgrpc$/a\### '"$user $exp"'\
    },{"id": "'""$uuid""'","alterId": 0,"email": "'""$user""'"' /usr/local/etc/xray/vmess.json
    sed -i '/#vless$/a\### '"$user $exp"'\
    },{"id": "'$uuid'","email": "'$user'"' /usr/local/etc/xray/vless.json
    sed -i '/#vlessgrpc$/a\### '"$user $exp"'\
    },{"id": "'$uuid'","email": "'$user'"' /usr/local/etc/xray/vless.json
    sed -i '/#trojanws$/a\### '"$user $exp"'\
    },{"password": "'$uuid'","email": "'$user'"' /usr/local/etc/xray/trojan.json
    sed -i '/#trojangrpc$/a\### '"$user $exp"'\
    },{"password": "'$uuid'","email": "'$user'"' /usr/local/etc/xray/trojan.json
    sed -i '/#ssws$/a\### '"$user $exp"'\
    },{"password": "'""$uuid""'","method": "'""$cipher""'","email": "'""$user""'"' /usr/local/etc/xray/sodosok.json
    sed -i '/#ssgrpc$/a\### '"$user $exp"'\
    },{"password": "'""$uuid""'","method": "'""$cipher""'","email": "'""$user""'"' /usr/local/etc/xray/sodosok.json

    # Bersihkan file lama
    rm -rf /home/vps/public_html/${user}*
    rm -rf /tmp/log /tmp/log1

    # Generate JSON config & link VMess
    asu=$(cat <<EOF
{
  "v": "2",
  "ps": "${user}",
  "add": "${wild}${domain}",
  "port": "${tls}",
  "id": "${uuid}",
  "aid": "0",
  "net": "ws",
  "path": "${VMP1}",
  "type": "none",
  "host": "${BUG}",
  "tls": "tls"
}
EOF
    )
    ask=$(cat <<EOF
{
  "v": "2",
  "ps": "${user}",
  "add": "${wild}${domain}",
  "port": "${none}",
  "id": "${uuid}",
  "aid": "0",
  "net": "ws",
  "path": "${VMP1}",
  "type": "none",
  "host": "${BUG}",
  "tls": "none"
}
EOF
    )
    grpc=$(cat <<EOF
{
  "v": "2",
  "ps": "${user}",
  "add": "${wild}${domain}",
  "port": "${tls}",
  "id": "${uuid}",
  "aid": "0",
  "net": "grpc",
  "path": "vmess-grpc",
  "type": "none",
  "host": "${BUG}",
  "tls": "tls"
}
EOF
    )

    # VMess link
    vmesslink1="vmess://$(echo $asu | base64 -w 0)"
    vmesslink2="vmess://$(echo $ask | base64 -w 0)"
    vmesslink3="vmess://$(echo $grpc | base64 -w 0)"

    # VLESS link
    vlesslink1="vless://${uuid}@${wild}${domain}:$tls?path=${VLP1}&security=tls&encryption=none&type=ws&sni=${BUG}#${user}"
    vlesslink2="vless://${uuid}@${wild}${domain}:$none?path=${VLP1}&encryption=none&type=ws&host=${BUG}#${user}"
    vlesslink3="vless://${uuid}@${wild}${domain}:$tls?mode=gun&security=tls&encryption=none&type=grpc&serviceName=vless-grpc&sni=${BUG}#${user}"

    # Trojan link
    trojanlink1="trojan://${uuid}@${wild}${domain}:${tr}?mode=gun&security=tls&type=grpc&serviceName=trojan-grpc&sni=${BUG}#${user}"
    trojanlink2="trojan://${uuid}@${wild}${domain}:${tr2}?security=none&type=ws&headerType=none&path=${TRP1}&host=${BUG}#${user}"
    trojanlink="trojan://${uuid}@${wild}${domain}:${tr}?path=${TRP1}&security=tls&host=&type=ws&sni=${BUG}#${user}"

    # Yaml
    sodosok "NTLS"
    sodosok "TLS"
    sodosok "gRPC"
    generate_yaml vless tls
    generate_yaml vless ntls
    generate_yaml vmess tls
    generate_yaml vmess ntls
    trojan_yaml ntls
    trojan_yaml tls

    # Link file YAML
    trojanyamltls="http://${MYIP}:81/${user}_trojantls.yaml"
    trojanyamlntls="http://${MYIP}:81/${user}_trojanntls.yaml"
    vlessyamltls="http://${MYIP}:81/${user}_vlesstls.yaml"
    vlessyamlntls="http://${MYIP}:81/${user}_vlessntls.yaml"
    vmessyamltls="http://${MYIP}:81/${user}_vmesstls.yaml"
    vmessyamlntls="http://${MYIP}:81/${user}_vmessntls.yaml"
    link="http://${MYIP}:81/${user}-TLS"
    link0="http://${MYIP}:81/${user}-NTLS"
    link1="http://${MYIP}:81/${user}-gRPC"

    # Restart services
    systemctl restart xray > /dev/null 2>&1
    systemctl restart xray@vmess > /dev/null 2>&1
    systemctl restart xray@trojan > /dev/null 2>&1
    systemctl restart xray@sodosok > /dev/null 2>&1
    service cron restart > /dev/null 2>&1

    clear
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "\E[44;1;39m    Trial All Xray Account     \E[0m"
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "Remarks       : ${user}"
    echo -e "IP Address    : ${MYIP}"
    echo -e "Domain        : ${domain}"
    echo -e "Port TLS      : ${tls}"
    echo -e "Port GRPC     : ${tls}"
    echo -e "Port none TLS : ${none1}"
    echo -e "Path WS       : ${ANP}"
    echo -e "id            : ${uuid}"
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "Link VMess TLS :"
    echo -e '```'
    echo "${vmesslink1}"
    echo -e '```'
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "Link Vmess none TLS :"
    echo -e '```'
    echo "${vmesslink2}"
    echo -e '```'
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "Link Vmess GRPC :"
    echo -e '```'
    echo "${vmesslink3}"
    echo -e '```'
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "Link Vless TLS :"
    echo -e '```'
    echo "${vlesslink1}"
    echo -e '```'
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "Link Vless none TLS :"
    echo -e '```'
    echo "${vlesslink2}"
    echo -e '```'
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "Link GRPC :"
    echo -e '```'
    echo "${vlesslink3}"
    echo -e '```'
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "Link Trojan WS TLS:"
    echo -e '```'
    echo "${trojanlink}"
    echo -e '```'
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "Link Trojan WS none TLS:"
    echo -e '```'
    echo "${trojanlink2}"
    echo -e '```'
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "Link Trojan GRPC :"
    echo -e '```'
    echo "${trojanlink1}"
    echo -e '```'
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "Link Sodosok TLS :"
    echo -e "${link}"
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "Link Sodosok none TLS :"
    echo -e "${link0}"
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "Link Sodosok GRPC :"
    echo -e "${link1}"
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "Link Yaml Vmess TLS :"
    echo -e "${vmessyamltls}"
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "Link Yaml Vmess none TLS :"
    echo -e "${vmessyamlntls}"
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "Link Yaml Vless TLS :"
    echo -e "${vlessyamltls}"
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "Link Yaml Vless none TLS :"
    echo -e "${vlessyamlntls}"
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "Link Yaml Trojan TLS :"
    echo -e "${trojanyamltls}"
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "Link Yaml Trojan none TLS :"
    echo -e "${trojanyamlntls}"
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "Expired On : $exp"
    echo -e "\033[0;34m-------------------------------\033[0m"
    read -n 1 -s -r -p "Press any key to back on menu"
    menu-xray
}

cek-login() {
    clear
    tmp_other="/tmp/other.txt"
    tmp_ip="/tmp/ipvmess.txt"

    print_header() {
        local title="XRAY $1 User Login"
        local width=40   # kasi semua seragam panjang
        echo -e "\033[0;34m$(printf '%.0s-' $(seq 1 $width))\033[0m"
        printf "\E[44;1;39m%*s%s%*s\E[0m\n" \
            $(((width - ${#title}) / 2)) "" "$title" \
            $(((width - ${#title} + 1) / 2)) ""
        echo -e "\033[0;34m$(printf '%.0s-' $(seq 1 $width))\033[0m"
    }

    process_log() {
        local config_file=$1
        local log_file=$2
        local protocol_name=$3

        echo -n > "$tmp_other"
        data=( $(grep '^###' "$config_file" | cut -d ' ' -f 2 | sort -u) )

        print_header "$protocol_name"

        for akun in "${data[@]}"; do
            [[ -z "$akun" ]] && akun="tidakada"
            echo -n > "$tmp_ip"

            data2=( $(tail -n 500 "$log_file" | cut -d ' ' -f 3 | sed 's/tcp://g' | cut -d ':' -f 1 | sort -u) )

            for ip in "${data2[@]}"; do
                jum=$(grep -w "$akun" "$log_file" | tail -n 500 | \
                      cut -d ' ' -f 3 | sed 's/tcp://g' | cut -d ':' -f 1 | \
                      grep -w "$ip" | sort -u)

                if [[ "$jum" == "$ip" ]]; then
                    echo "$jum" >> "$tmp_ip"
                else
                    echo "$ip" >> "$tmp_other"
                fi

                while read -r line; do
                    sed -i "/^$line$/d" "$tmp_other"
                done < "$tmp_ip"
            done

            if [[ -s "$tmp_ip" ]]; then
                echo "user : $akun"
                nl "$tmp_ip"
            fi

            rm -f "$tmp_ip"
        done
    }

    case "$1" in
        vmess)
            process_log "/usr/local/etc/xray/vmess.json" "/var/log/xray/access1.log" "Vmess"
            ;;
        vless)
            process_log "/usr/local/etc/xray/vless.json" "/var/log/xray/access.log" "Vless"
            ;;
        trojan)
            process_log "/usr/local/etc/xray/trojan.json" "/var/log/xray/access2.log" "Trojan"
            ;;
        sodosok)
            process_log "/usr/local/etc/xray/sodosok.json" "/var/log/xray/access3.log" "Sodosok"
            ;;
        all|*)
            process_log "/usr/local/etc/xray/vmess.json" "/var/log/xray/access1.log" "Vmess"
            process_log "/usr/local/etc/xray/vless.json" "/var/log/xray/access.log" "Vless"
            process_log "/usr/local/etc/xray/trojan.json" "/var/log/xray/access2.log" "Trojan"
            process_log "/usr/local/etc/xray/sodosok.json" "/var/log/xray/access3.log" "Sodosok"
            ;;
    esac

    rm -f "$tmp_other" "$tmp_ip"
    echo -e "\033[0;34m$(printf '%.0s-' $(seq 1 40))\033[0m"
    read -n 1 -s -r -p "Press any key to back on menu"
    menu-xray
}

cek-all() {
    clear
    tmp_other="/tmp/other.txt"
    tmp_ip="/tmp/ipvmess.txt"

    print_header() {
        local title="XRAY $1 User Login"
        local width=35

        echo -e "\033[0;34m$(printf '%.0s-' $(seq 1 $width))\033[0m"
        printf "\E[44;1;39m%*s%s%*s\E[0m\n" $(((width - ${#title}) / 2)) "" "$title" $(((width - ${#title} + 1) / 2)) ""
        echo -e "\033[0;34m$(printf '%.0s-' $(seq 1 $width))\033[0m"
    }
    process_log() {
        local config_file=$1
        local log_file=$2
        local protocol_name=$3

        echo -n > "$tmp_other"
        data=( $(grep '^###' "$config_file" | cut -d ' ' -f 2 | sort -u) )

        print_header "$protocol_name"

        for akun in "${data[@]}"; do
            [[ -z "$akun" ]] && akun="tidakada"
            echo -n > "$tmp_ip"

            data2=( $(tail -n 500 "$log_file" | cut -d ' ' -f 3 | sed 's/tcp://g' | cut -d ':' -f 1 | sort -u) )

            for ip in "${data2[@]}"; do
                jum=$(grep -w "$akun" "$log_file" | tail -n 500 | cut -d ' ' -f 3 | sed 's/tcp://g' | cut -d ':' -f 1 | grep -w "$ip" | sort -u)

                if [[ "$jum" == "$ip" ]]; then
                    echo "$jum" >> "$tmp_ip"
                else
                    echo "$ip" >> "$tmp_other"
                fi

                # Hapus IP yang sudah tercatat di tmp_ip dari tmp_other
                while read -r line; do
                    sed -i "/^$line$/d" "$tmp_other"
                done < "$tmp_ip"
            done

            if [[ -s "$tmp_ip" ]]; then
                echo "user : $akun"
                nl "$tmp_ip"
            fi

            rm -f "$tmp_ip"
        done
    }

    # Process masing-masing protocol dan lognya
    process_log "/usr/local/etc/xray/vmess.json" "/var/log/xray/access1.log" "Vmess"
    process_log "/usr/local/etc/xray/vless.json" "/var/log/xray/access.log" "Vless"
    process_log "/usr/local/etc/xray/trojan.json" "/var/log/xray/access2.log" "Trojan"
    process_log "/usr/local/etc/xray/sodosok.json" "/var/log/xray/access3.log" "Sodosok"

    rm -f "$tmp_other" "$tmp_ip"
    echo ""
    read -n 1 -s -r -p "Press any key to back on menu"
    menu-xray
}

renew-xray() {
    PROTO="$1"

    # Validate protocol
    if [[ ! "$PROTO" =~ ^(vmess|vless|trojan|sodosok)$ ]]; then
        echo -e "\033[0;31mError: Protocol not valid! Use: vmess, vless, trojan, sodosok\033[0m"
        return 1
    fi

    tmpfile="/root/usr_tmp.txt"
    grep -E "^### " "/usr/local/etc/xray/${PROTO}.json" | sort -u > "$tmpfile"
    NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/usr/local/etc/xray/${PROTO}.json")

    if [[ ${NUMBER_OF_CLIENTS} == 0 ]]; then
        echo -e "\nYou have no existing clients for $PROTO!\n"
        rm -f "$tmpfile"
        read -n 1 -s -r -p "Press any key to back on menu"
        menu-xray
    fi

    clear
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "\E[44;1;39m       Renew $PROTO Account     \E[0m"
    echo -e "\033[0;34m-------------------------------\033[0m"
    awk '{print $2, $3}' "$tmpfile" | sort -u | nl -s ') '
    echo "$((NUMBER_OF_CLIENTS+1))) Cancel"
    echo -e "\033[0;34m-------------------------------\033[0m"

    until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le $((NUMBER_OF_CLIENTS+1)) ]]; do
        read -rp "Select one client [1-${NUMBER_OF_CLIENTS}, Cancel=${NUMBER_OF_CLIENTS+1}]: " CLIENT_NUMBER
    done

    if [[ ${CLIENT_NUMBER} -eq $((NUMBER_OF_CLIENTS+1)) ]]; then
        echo -e "\nAction canceled!"
        rm -f "$tmpfile"
        read -n 1 -s -r -p "Press any key to back on menu"
        menu-xray
    fi

    user=$(awk '{print $2}' "$tmpfile" | sed -n "${CLIENT_NUMBER}p")
    exp=$(awk -v u="$user" '$2==u {print $3}' "/usr/local/etc/xray/${PROTO}.json" | sort -u)

    read -rp "Extend by (days): " masaaktif

    now=$(date +%Y-%m-%d)
    d1=$(date -d "$exp" +%s)
    d2=$(date -d "$now" +%s)
    exp2=$(( (d1 - d2) / 86400 ))
    exp3=$((exp2 + masaaktif))
    exp4=$(date -d "$exp3 days" +"%Y-%m-%d")

    # Update expiration in all JSON files
    for file in vless.json vmess.json trojan.json sodosok.json; do
        sed -i "/### $user/c\### $user $exp4" "/usr/local/etc/xray/$file"
    done

    clear
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "\E[44;1;39m       Renew $PROTO Account     \E[0m"
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo " Account Was Successfully Renewed"
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo " Client Name : $user"
    echo " Expired On  : $exp4"
    echo -e "\033[0;34m-------------------------------\033[0m"

    rm -f "$tmpfile"
    read -n 1 -s -r -p "Press any key to back on menu"
    menu-xray
}

del-xray() {
    PROTO="$1"

    # Validate protocol
    if [[ ! "$PROTO" =~ ^(vmess|vless|trojan|sodosok)$ ]]; then
        echo -e "\033[0;31mError: Protocol not valid! Use: vmess, vless, trojan, sodosok\033[0m"
        return 1
    fi

    tmpfile="/root/usr_tmp.txt"
    grep -E "^### " "/usr/local/etc/xray/${PROTO}.json" | sort -u > "$tmpfile"
    NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/usr/local/etc/xray/${PROTO}.json")

    if [[ ${NUMBER_OF_CLIENTS} == 0 ]]; then
        echo -e "\nYou have no existing clients for $PROTO!\n"
        rm -f "$tmpfile"
        read -n 1 -s -r -p "Press any key to back on menu"
        menu-xray
    fi

    clear
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "\E[44;1;39m      Delete $PROTO Account      \E[0m"
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo "  User       Expired"
    echo -e "\033[0;34m-------------------------------\033[0m"
    awk '{print $2, $3}' "$tmpfile" | sort -u | nl -s ') '
    echo "$((NUMBER_OF_CLIENTS+1))) Cancel"
    echo -e "\033[0;34m-------------------------------\033[0m"

    until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le $((NUMBER_OF_CLIENTS+1)) ]]; do
        read -rp "Select one client [1-${NUMBER_OF_CLIENTS}, Cancel=${NUMBER_OF_CLIENTS+1}]: " CLIENT_NUMBER
    done

    if [[ ${CLIENT_NUMBER} -eq $((NUMBER_OF_CLIENTS+1)) ]]; then
        echo -e "\nAction canceled!"
        rm -f "$tmpfile"
        read -n 1 -s -r -p "Press any key to back on menu"
        menu-xray
    fi

    user=$(awk '{print $2}' "$tmpfile" | sed -n "${CLIENT_NUMBER}p")
    exp=$(awk '{print $3}' "$tmpfile" | sed -n "${CLIENT_NUMBER}p")
    hariini=$(date +%Y-%m-%d)

    # Remove user from all JSON
    for file in vless.json vmess.json trojan.json sodosok.json; do
        sed -i "/^### $user $exp/,/\"email\": \"$user\"/d" /usr/local/etc/xray/$file
    done

    # Remove public_html files
    rm -f /home/vps/public_html/${user}*

    # Restart Xray
    systemctl restart xray >/dev/null 2>&1
    systemctl restart xray@vmess >/dev/null 2>&1
    systemctl restart xray@trojan-ws >/dev/null 2>&1
    systemctl restart xray@sodosok >/dev/null 2>&1

    clear
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "\E[44;1;39m      Delete $PROTO Account      \E[0m"
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo " Account Deleted Successfully"
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo " Client Name : $user"
    echo " Deleted On  : $hariini"
    echo -e "\033[0;34m-------------------------------\033[0m"

    rm -f "$tmpfile"
    read -n 1 -s -r -p "Press any key to back on menu"
    menu-xray
}

running-1() {
    # Warna
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    NC='\033[0m'

    # Export IP Address
    export IP=$(curl -s https://ipinfo.io/ip)

    # Fungsi cek status systemctl
    cek_status() {
        local service=$1
        local status=$(systemctl is-active "$service" 2>/dev/null)
        if [[ "$status" == "active" ]]; then
            echo -e "${GREEN}Running${NC}"
        else
            echo -e "${RED}Error${NC}"
        fi
    }

    # Cek status service
    status_openssh=$(cek_status ssh)
    status_stunnel5=$(cek_status stunnel4)
    status_dropbear=$(cek_status dropbear)
    status_squid=$(cek_status squid)
    status_ws_epro=$(cek_status ws-stunnel)
    status_vless=$(cek_status xray)
    status_vmess=$(cek_status xray@vmess)
    status_trojan=$(cek_status xray@trojan)
    status_sodosok=$(cek_status xray@sodosok)
    status_nginx=$(cek_status nginx)
    status_wireguard=$(cek_status wg-quick@wg0.service)

    # Tampilkan hasil
    clear
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "\E[44;1;39m   STATUS SERVICE INFORMATION  \E[0m"
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "Server Uptime        : $(uptime -p | cut -d ' ' -f 2-)"
    echo -e "Current Time        : $(date +"%d-%m-%Y %X")"
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "\E[44;1;39m      SERVICE INFORMATION      \E[0m"
    echo -e "\033[0;34m-------------------------------\033[0m"
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
    echo -e "\033[0;34m-------------------------------\033[0m"

    read -n 1 -s -r -p "Press any key to back on menu"
    menu-xray
}

multipath() {
mode="$1"

rm -rf /etc/nginx/conf.d/xray.conf

case "$mode" in

off|off1)
cat >/etc/nginx/conf.d/xray.conf <<EOF
    server {
             listen 80;
             listen [::]:80;
             listen 8080;
             listen [::]:8080;
             listen 443 ssl http2 reuseport;
             listen [::]:443 ssl http2 reuseport;    
             server_name ${domain};
             ssl_certificate /etc/xray/xray.crt;
             ssl_certificate_key /etc/xray/xray.key;
             ssl_ciphers EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+ECDSA+AES128:EECDH+aRSA+AES128:RSA+AES128:EECDH+ECDSA+AES256:EECDH+aRSA+AES256:RSA+AES256:EECDH+ECDSA+3DES:EECDH+aRSA+3DES:RSA+3DES:!MD5;
             ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3;
             root /home/vps/public_html;

             location ~* vlessws {
                       rewrite ^.*vlessws.*$ /vlessws break;
                       proxy_redirect off;
                       proxy_pass http://127.0.0.1:14016;
                       proxy_http_version 1.1;
             proxy_set_header X-Real-IP aaa;
             proxy_set_header X-Forwarded-For bbb;
             proxy_set_header Upgrade ddd;
             proxy_set_header Connection fff;
             proxy_set_header Host eee;
 }
             location ~* vmessws {
                       rewrite ^.*vmessws.*$ /vmessws break;
                       proxy_redirect off;
                       proxy_pass http://127.0.0.1:23456;
                       proxy_http_version 1.1;
             proxy_set_header X-Real-IP aaa;
             proxy_set_header X-Forwarded-For bbb;
             proxy_set_header Upgrade ddd;
             proxy_set_header Connection fff;
             proxy_set_header Host eee;
 }
             location ~* trojan-ws {
                       rewrite ^.*trojan-ws.*$ /trojan-ws break;
                       proxy_redirect off;
                       proxy_pass http://127.0.0.1:25432;
                       proxy_http_version 1.1;
             proxy_set_header X-Real-IP aaa;
             proxy_set_header X-Forwarded-For bbb;
             proxy_set_header Upgrade ddd;
             proxy_set_header Connection fff;
             proxy_set_header Host eee;
 }
             location ~* ss-ws {
                       rewrite ^.*ss-ws.*$ /ss-ws break;
                       proxy_redirect off;
                       proxy_pass http://127.0.0.1:30300;
                       proxy_http_version 1.1;
             proxy_set_header X-Real-IP aaa;
             proxy_set_header X-Forwarded-For bbb;
             proxy_set_header Upgrade ddd;
             proxy_set_header Connection fff;
             proxy_set_header Host eee;
 }
              location / {
                      proxy_redirect off;
                      proxy_pass http://127.0.0.1:700;
                      proxy_http_version 1.1;
             proxy_set_header X-Real-IP aaa;
             proxy_set_header X-Forwarded-For bbb;
             proxy_set_header Upgrade ddd;
             proxy_set_header Connection fff;
             proxy_set_header Host eee;
 }
             location ^~ /vless-grpc {
                      proxy_redirect off;
                      grpc_set_header X-Real-IP aaa;
                      grpc_set_header X-Forwarded-For bbb;
             grpc_set_header Host eee;
             grpc_pass grpc://127.0.0.1:24456;
 }
             location ^~ /vmess-grpc {
                      proxy_redirect off;
                      grpc_set_header X-Real-IP aaa;
                      grpc_set_header X-Forwarded-For bbb;
             grpc_set_header Host eee;
             grpc_pass grpc://127.0.0.1:31234;
 }
             location ^~ /trojan-grpc {
                      proxy_redirect off;
                      grpc_set_header X-Real-IP aaa;
                      grpc_set_header X-Forwarded-For bbb;
             grpc_set_header Host eee;
             grpc_pass grpc://127.0.0.1:33456;
 }
             location ^~ /ss-grpc {
                      proxy_redirect off;
                      grpc_set_header X-Real-IP aaa;
                      grpc_set_header X-Forwarded-For bbb;
             grpc_set_header Host eee;
             grpc_pass grpc://127.0.0.1:30310;
 }
        }    
EOF
;;

on)
cat >/etc/nginx/conf.d/xray.conf <<EOF
    map ddd iii {
        default upgrade;
        ''      close;
    }

    upstream ws_backend {
              server 127.0.0.1:14016;
              server 127.0.0.1:23456;
              server 127.0.0.1:25432;
              server 127.0.0.1:30300;
 }

    server {
             listen 80;
             listen [::]:80;
             listen 8080;
             listen [::]:8080;
             listen 443 ssl http2 reuseport;
             listen [::]:443 ssl http2 reuseport;    
             server_name ${domain};
             ssl_certificate /etc/xray/xray.crt;
             ssl_certificate_key /etc/xray/xray.key;
             ssl_ciphers EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+ECDSA+AES128:EECDH+aRSA+AES128:RSA+AES128:EECDH+ECDSA+AES256:EECDH+aRSA+AES256:RSA+AES256:EECDH+ECDSA+3DES:EECDH+aRSA+3DES:RSA+3DES:!MD5;
             ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3;
             root /home/vps/public_html;

              location / {
                      proxy_http_version 1.1;
                      proxy_set_header X-Real-IP aaa;
                      proxy_set_header X-Forwarded-For bbb;
             proxy_set_header Upgrade ddd;
             proxy_set_header Connection fff;
             proxy_set_header Host ccc;
             if (ddd = websocket) {
                      proxy_pass http://ws_backend;
             }

             proxy_pass http://127.0.0.1:700;
 }

             location ^~ /vless-grpc {
                      proxy_redirect off;
                      grpc_set_header X-Real-IP aaa;
                      grpc_set_header X-Forwarded-For bbb;
             grpc_set_header Host eee;
             grpc_pass grpc://127.0.0.1:24456;
 }

             location ^~ /vmess-grpc {
                      proxy_redirect off;
                      grpc_set_header X-Real-IP aaa;
                      grpc_set_header X-Forwarded-For bbb;
             grpc_set_header Host eee;
             grpc_pass grpc://127.0.0.1:31234;
 }

             location ^~ /trojan-grpc {
                      proxy_redirect off;
                      grpc_set_header X-Real-IP aaa;
                      grpc_set_header X-Forwarded-For bbb;
             grpc_set_header Host eee;
             grpc_pass grpc://127.0.0.1:33456;
 }

             location ^~ /ss-grpc {
                      proxy_redirect off;
                      grpc_set_header X-Real-IP aaa;
                      grpc_set_header X-Forwarded-For bbb;
             grpc_set_header Host eee;
             grpc_pass grpc://127.0.0.1:30310;
 }
        }    
EOF
;;

on1)
cat >/etc/nginx/conf.d/xray.conf <<EOF
    server {
             listen 80;
             listen [::]:80;
             listen 8080;
             listen [::]:8080;
             listen 443 ssl http2 reuseport;
             listen [::]:443 ssl http2 reuseport;    
             server_name ${domain};
             ssl_certificate /etc/xray/xray.crt;
             ssl_certificate_key /etc/xray/xray.key;
             ssl_ciphers EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+ECDSA+AES128:EECDH+aRSA+AES128:RSA+AES128:EECDH+ECDSA+AES256:EECDH+aRSA+AES256:RSA+AES256:EECDH+ECDSA+3DES:EECDH+aRSA+3DES:RSA+3DES:!MD5;
             ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3;
             root /home/vps/public_html;

             location / {
                       proxy_http_version 1.1;
                       proxy_set_header Host ccc;
             proxy_set_header X-Real-IP aaa;
             proxy_set_header X-Forwarded-For bbb;
             proxy_set_header Upgrade ddd;
             proxy_set_header Connection fff;

             if (ddd = "websocket") {
                proxy_pass http://127.0.0.1:14016;
                break;
             }

             proxy_pass http://127.0.0.1:700;
 }
             location ~* vlessws {
                       rewrite ^.*vlessws.*$ / break;
                       proxy_redirect off;
                       proxy_pass http://127.0.0.1:14016;
                       proxy_http_version 1.1;
             proxy_set_header X-Real-IP aaa;
             proxy_set_header X-Forwarded-For bbb;
             proxy_set_header Upgrade ddd;
             proxy_set_header Connection fff;
             proxy_set_header Host eee;
 }
             location ~* vmessws {
                       rewrite ^.*vmessws.*$ /vmessws break;
                       proxy_redirect off;
                       proxy_pass http://127.0.0.1:23456;
                       proxy_http_version 1.1;
             proxy_set_header X-Real-IP aaa;
             proxy_set_header X-Forwarded-For bbb;
             proxy_set_header Upgrade ddd;
             proxy_set_header Connection fff;
             proxy_set_header Host eee;
 }
             location ~* trojan-ws {
                       rewrite ^.*trojan-ws.*$ /trojan-ws break;
                       proxy_redirect off;
                       proxy_pass http://127.0.0.1:25432;
                       proxy_http_version 1.1;
             proxy_set_header X-Real-IP aaa;
             proxy_set_header X-Forwarded-For bbb;
             proxy_set_header Upgrade ddd;
             proxy_set_header Connection fff;
             proxy_set_header Host eee;
 }
             location ~* ss-ws {
                      rewrite ^.*ss-ws.*$ /ss-ws break;
                      proxy_redirect off;
                      proxy_pass http://127.0.0.1:30300;
                      proxy_http_version 1.1;
             proxy_set_header X-Real-IP aaa;
             proxy_set_header X-Forwarded-For bbb;
             proxy_set_header Upgrade ddd;
             proxy_set_header Connection fff;
             proxy_set_header Host eee;
 }
             location ^~ /vless-grpc {
                      proxy_redirect off;
                      grpc_set_header X-Real-IP aaa;
                      grpc_set_header X-Forwarded-For bbb;
             grpc_set_header Host eee;
             grpc_pass grpc://127.0.0.1:24456;
 }
             location ^~ /vmess-grpc {
                      proxy_redirect off;
                      grpc_set_header X-Real-IP aaa;
                      grpc_set_header X-Forwarded-For bbb;
             grpc_set_header Host eee;
             grpc_pass grpc://127.0.0.1:31234;
 }
             location ^~ /trojan-grpc {
                      proxy_redirect off;
                      grpc_set_header X-Real-IP aaa;
                      grpc_set_header X-Forwarded-For bbb;
             grpc_set_header Host eee;
             grpc_pass grpc://127.0.0.1:33456;
 }
             location ^~ /ss-grpc {
                      proxy_redirect off;
                      grpc_set_header X-Real-IP aaa;
                      grpc_set_header X-Forwarded-For bbb;
             grpc_set_header Host eee;
             grpc_pass grpc://127.0.0.1:30310;
 }
        }    
EOF
;;

esac

sed -i 's/aaa/$remote_addr/g' /etc/nginx/conf.d/xray.conf
sed -i 's/bbb/$proxy_add_x_forwarded_for/g' /etc/nginx/conf.d/xray.conf
sed -i 's/ccc/$host/g' /etc/nginx/conf.d/xray.conf
sed -i 's/ddd/$http_upgrade/g' /etc/nginx/conf.d/xray.conf
sed -i 's/eee/$http_host/g' /etc/nginx/conf.d/xray.conf
sed -i 's/fff/"upgrade"/g' /etc/nginx/conf.d/xray.conf
sed -i 's/ggg/"websocket"/g' /etc/nginx/conf.d/xray.conf
sed -i 's/iii/$connection_upgrade/g' /etc/nginx/conf.d/xray.conf

# Update WS paths bergantung pada mode
case "$mode" in
    on)
        sed -i 's|"path": "/[^"]*"|"path": "/"|g' /usr/local/etc/xray/*.json
        ;;
    on1)
        sed -i 's|"path": "/[^"]*"|"path": "/"|g' /usr/local/etc/xray/vless.json
        sed -i 's|"path": "/[^"]*"|"path": "/vmessws"|g' /usr/local/etc/xray/vmess.json
        sed -i 's|"path": "/[^"]*"|"path": "/trojan-ws"|g' /usr/local/etc/xray/trojan.json
        sed -i 's|"path": "/[^"]*"|"path": "/ss-ws"|g' /usr/local/etc/xray/sodosok.json
        ;;
    off|off1)
        sed -i 's|"path": "/[^"]*"|"path": "/vlessws"|g' /usr/local/etc/xray/vless.json
        sed -i 's|"path": "/[^"]*"|"path": "/vmessws"|g' /usr/local/etc/xray/vmess.json
        sed -i 's|"path": "/[^"]*"|"path": "/trojan-ws"|g' /usr/local/etc/xray/trojan.json
        sed -i 's|"path": "/[^"]*"|"path": "/ss-ws"|g' /usr/local/etc/xray/sodosok.json

        sed -i 's|"path": ""|"path": "/vlessws"|g' /usr/local/etc/xray/vless.json
        sed -i 's|"path": ""|"path": "/vmessws"|g' /usr/local/etc/xray/vmess.json
        sed -i 's|"path": ""|"path": "/trojan-ws"|g' /usr/local/etc/xray/trojan.json
        sed -i 's|"path": ""|"path": "/ss-ws"|g' /usr/local/etc/xray/sodosok.json
        ;;
esac

# Restart services
systemctl daemon-reload
systemctl restart xray
systemctl restart xray@vmess
systemctl restart xray@trojan
systemctl restart xray@sodosok
systemctl restart nginx
}

clear
echo -e "\033[0;34m------------------------------------\033[0m"
echo -e "\E[44;1;39m         XRAY MULTIPORT MENU       \E[0m"
echo -e "\033[0;34m------------------------------------\033[0m"
echo -e "Multipath Status =  ${COLOR}${STATUS_TEXT}\e[0m"
echo ""
echo -e " [\e[36m 01 \e[0m] Trial XRay VMess WS & gRPC"
echo -e " [\e[36m 02 \e[0m] Add XRay VMess WS & gRPC"
echo -e " [\e[36m 03 \e[0m] Delete XRay VMess WS & gRPC"
echo -e " [\e[36m 04 \e[0m] Renew XRay VMess WS & gRPC"
echo -e " [\e[36m 05 \e[0m] Check User Login XRay VMess WS & gRPC"
echo ""
echo -e " [\e[36m 06 \e[0m] Trial XRay VLess WS & gRPC"
echo -e " [\e[36m 07 \e[0m] Add XRay VLess WS & gRPC"
echo -e " [\e[36m 08 \e[0m] Delete XRay VLess WS & gRPC"
echo -e " [\e[36m 09 \e[0m] Renew XRay VLess WS & gRPC"
echo -e " [\e[36m 10 \e[0m] Check User Login XRay Vless WS & gRPC"
echo ""
echo -e " [\e[36m 11 \e[0m] Trial XRay Trojan TLS WS & gRPC"
echo -e " [\e[36m 12 \e[0m] Add XRay Trojan TLS WS & gRPC"
echo -e " [\e[36m 13 \e[0m] Delete XRay Trojan TLS WS & gRPC"
echo -e " [\e[36m 14 \e[0m] Renew XRay Trojan TLS WS & gRPC"
echo -e " [\e[36m 15 \e[0m] Check User XRay Trojan TLS WS & gRPC"
echo ""
echo -e " [\e[36m 16 \e[0m] Trial XRay Sodosok TLS & gRPC"
echo -e " [\e[36m 17 \e[0m] Add XRay Sodosok TLS & gRPC"
echo -e " [\e[36m 18 \e[0m] Delete XRay Sodosok TLS & gRPC"
echo -e " [\e[36m 19 \e[0m] Renew XRay Sodosok TLS & gRPC"
echo -e " [\e[36m 20 \e[0m] Check User XRay Sodosok TLS & gRPC"
echo ""
echo -e " [\e[36m 21 \e[0m] Trial All Xray Ws"
echo -e " [\e[36m 22 \e[0m] Renew Cert Xray "
echo -e " [\e[36m 23 \e[0m] Check Port Info "
echo -e " [\e[36m 24 \e[0m] Check Running Service "
echo -e " [\e[36m 25 \e[0m] Check Multilogin All Protocol Xray User "
echo -e " [\e[36m 26 \e[0m] Recall Id Vless User "
echo -e " [\e[36m 27 \e[0m] Recall Id Trojan User "
echo -e " [\e[36m 28 \e[0m] Recall Id Vmess User "
echo -e " [\e[36m 29 \e[0m] ON/OFF Multipath "
echo ""
echo -e "Press x or [ Ctrl+C ]   To-Exit"
echo -e ""
echo -e "\033[0;34m------------------------------------\033[0m"
echo -e "Client Name    : $Name"
echo -e "Expiry script  : $scexpireddate"
echo -e "Countdown Days : $sisa_hari Days Left"
echo -e "Script Type    : $sc $scv"
echo -e "\033[0;34m------------------------------------\033[0m"
echo ""
read -p " Select menu : " opt
echo -e ""
case $opt in
1|01)
    clear
    trial-vmess
    ;;
2|02)
    clear
    add-vmess
    ;;
3|03)
    clear
    del-xray vmess
    ;;
4|04)
    clear
    renew-xray vmess
    ;;
5|05)
    clear
    cek-login vmess
    ;;
6|06)
    clear
    trial-vless
    ;;
7|07)
    clear
    add-vless
    ;;
8|08)
    clear
    del-xray vless
    ;;
9|09)
    clear
    renew-xray vless
    ;;
10)
    clear
    cek-login vless
    ;;
11)
    clear
    trial-trojan
    ;;
12)
    clear
    add-trojan
    ;;
13)
    clear
    del-xray trojan
    ;;
14)
    clear
    renew-xray trojan
    ;;
15)
    clear
    cek-login trojan
    ;;
16)
    clear
    trial-sodosok
    ;;
17)
    clear
    add-sodosok
    ;;
18)
    clear
    del-xray sodosok
    ;;
19)
    clear
    renew-xray sodosok
    ;;
20)
    clear
    cek-login sodosok
    ;;
21)
    clear
    trial-all
    ;;
22)
    clear
    certv2ray
    ;;
23)
    clear
    check-port
    ;;
24)
    clear
    running-1
    ;;
25)
    clear
    cek-all
    ;;
26)
    clear
    recreate-vless
    ;;
27)
    clear
    recreate-trojan
    ;;
28)
    clear
    recreate-vmess
    ;;
29)
    clear
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "Current Multipath Status = ${COLOR}$MTS\e[0m"
    echo ""
    if [ "$MTS" = "FULL" ] || [ "$MTS" = "SINGLE" ]; then
        read -p "Do you want to turn OFF Multipath? [y/n]: " yn
        if [[ "$yn" =~ ^[Yy]$ ]]; then
            multipath off
            echo "✅ Multipath is now OFF"
        fi
    elif [ "$MTS" = "OFF" ]; then
        echo "1) Enable Multipath (FULL WS)"
        echo "2) Enable Multipath (VLESS WS)"
        read -p "Select option [1-2]: " opt
        case "$opt" in
            1) multipath on;  echo "✅ Multipath is now FULL WS mode" ;;
            2) multipath on1; echo "✅ Multipath is now VLESS WS mode" ;;
            *) echo "❌ Invalid option!" ;;
        esac
    fi
    read -n 1 -s -r -p "Press any key to return to menu"
    menu-xray
    ;;
x|X)
    clear
    menu
    ;;
*)
    clear
    echo -e ""
    echo "Sila Pilih Semula"
    sleep 1
    menu-xray
    ;;
esac
