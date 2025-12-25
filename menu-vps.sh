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

check_port() {
echo -e "\033[0;34m------------------------------------------------------------\033[0m"
echo -e "\E[44;1;39m                        INFO SCRIPTS INSTALL                \E[0m"
echo -e "\033[0;34m------------------------------------------------------------\033[0m"
cat /root/log-install.txt
echo -e "\033[0;34m------------------------------------------------------------\033[0m"
read -n 1 -s -r -p "Press any key to back on menu"
menu-vps
}

autoreboot() {
    clear

    # Buat skrip reboot otomatis jika belum ada
    if [ ! -e /usr/local/bin/reboot_otomatis ]; then
        cat <<'EOF' > /usr/local/bin/reboot_otomatis
#!/bin/bash
tanggal=$(date +"%m-%d-%Y")
waktu=$(date +"%T")
echo "Server successfully rebooted on the date of $tanggal hit $waktu." >> /root/log-reboot.txt
/sbin/shutdown -r now
EOF
        chmod +x /usr/local/bin/reboot_otomatis
    fi

    clear
    echo -e "\033[0;34m----------------------------------------\033[0m"
    echo -e "\E[44;1;39m          Menu Auto Reboot System       \E[0m"
    echo -e "\033[0;34m----------------------------------------\033[0m"
    echo ""
    echo -e " [\e[36m01\e[0m] Set Auto-Reboot Every 1 hr"
    echo -e " [\e[36m02\e[0m] Set Auto-Reboot Every 6 hrs"
    echo -e " [\e[36m03\e[0m] Set Auto-Reboot Every 12 hrs"
    echo -e " [\e[36m04\e[0m] Set Auto-Reboot Every 1 day"
    echo -e " [\e[36m05\e[0m] Set Auto-Reboot Every 1 week"
    echo -e " [\e[36m06\e[0m] Set Auto-Reboot Every 1 month"
    echo -e " [\e[36m07\e[0m] Turn Off Auto-Reboot"
    echo -e " [\e[36m08\e[0m] View reboot log"
    echo -e " [\e[36m09\e[0m] Remove reboot log"
    echo ""
    echo -e "Press 0 to back to menu or [ Ctrl+C ] to exit"
    echo ""
    echo -e "\033[0;34m----------------------------------------\033[0m"
    read -rp " Select option (0-9): " num

    case "$num" in
        1|01)
            echo "10 * * * * root /usr/local/bin/reboot_otomatis" > /etc/cron.d/reboot_otomatis
            echo_msg="Auto-Reboot has been set every 1 hour"
            ;;
        2|02)
            echo "10 */6 * * * root /usr/local/bin/reboot_otomatis" > /etc/cron.d/reboot_otomatis
            echo_msg="Auto-Reboot has been successfully set every 6 hours"
            ;;
        3|03)
            echo "10 */12 * * * root /usr/local/bin/reboot_otomatis" > /etc/cron.d/reboot_otomatis
            echo_msg="Auto-Reboot has been successfully set every 12 hours"
            ;;
        4|04)
            echo "10 0 * * * root /usr/local/bin/reboot_otomatis" > /etc/cron.d/reboot_otomatis
            echo_msg="Auto-Reboot has been successfully set once a day"
            ;;
        5|05)
            echo "10 0 */7 * * root /usr/local/bin/reboot_otomatis" > /etc/cron.d/reboot_otomatis
            echo_msg="Auto-Reboot has been successfully set once a week"
            ;;
        6|06)
            echo "10 0 1 * * root /usr/local/bin/reboot_otomatis" > /etc/cron.d/reboot_otomatis
            echo_msg="Auto-Reboot has been successfully set once a month"
            ;;
        7|07)
            rm -f /etc/cron.d/reboot_otomatis
            echo_msg="Auto-Reboot successfully TURNED OFF"
            ;;
        8|08)
            if [ ! -f /root/log-reboot.txt ]; then
                clear
                echo -e "\033[0;34m--------------------------\033[0m"
                echo -e "\E[44;1;39m No reboot activity found \E[0m"
                echo -e "\033[0;34m--------------------------\033[0m"
                read -n 1 -s -r -p "Press any key to back to auto reboot menu"
                autoreboot
                return
            else
                clear
                echo -e "\033[0;34m--------------------------\033[0m"
                echo -e "\E[44;1;39m       VPS REBOOT LOG      \E[0m"
                echo -e "\033[0;34m--------------------------\033[0m"
                cat /root/log-reboot.txt
                echo -e "\033[0;34m--------------------------\033[0m"
                read -n 1 -s -r -p "Press any key to back to auto reboot menu"
                autoreboot
                return
            fi
            ;;
        9|09)
            > /root/log-reboot.txt
            echo_msg="Auto Reboot Log successfully deleted!"
            ;;
        0)
            clear
            menu-vps
            return
            ;;
        *)
            clear
            echo -e "\033[0;34m---------------------------\033[0m"
            echo -e "\E[44;1;39m Options Not Found In Menu! \E[0m"
            echo -e "\033[0;34m---------------------------\033[0m"
            sleep 2
            autoreboot
            return
            ;;
    esac

    # Jika echo_msg diset, tunjukkan mesej dan kembali ke menu
    if [ -n "$echo_msg" ]; then
        clear
        echo -e "\033[0;34m----------------------------------------\033[0m"
        echo -e "\E[44;1;39m  $echo_msg  \E[0m"
        echo -e "\033[0;34m----------------------------------------\033[0m"
        read -n 1 -s -r -p "Press any key back to menu"
        menu-vps
    fi
}

add-host() {
    clear
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "\E[44;1;39m        CHANGE DOMAIN VPS           \E[0m"
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo ""
    read -rp "Add New Domain / Host: " -e pp
    echo ""

    if [[ -z "$pp" ]]; then
        echo -e "[ \033[1;31mERROR\033[0m ] Domain tidak dimasukkan!"
        sleep 2
        menu-vps
        return
    fi

    # Simpan domain baru
    rm -rf /etc/xray/domain /etc/xray/scdomain /root/domain /var/lib/premium-script/ipvps.conf
    echo "$pp" | tee /etc/xray/domain /etc/xray/scdomain /root/domain >/dev/null
    echo "IP=$pp" > /var/lib/premium-script/ipvps.conf

    echo -e "[ ${green}INFO${NC} ] Hentikan service lama..."
    systemctl stop nginx xray.service xray@vmess xray@trojan xray@sodosok
    sleep 1

    domain=$pp
    # Cari PID yang guna port 80 (ambil satu je, kalau ada)
    Cek=$(lsof -ti:80 | head -n1)
    if [[ -n "$Cek" ]]; then
        echo -e "[ ${red}WARNING${NC} ] Port 80 digunakan oleh PID: $Cek"
        kill -9 "$Cek" 2>/dev/null
        sleep 1
    fi

    echo -e "[ ${green}INFO${NC} ] Renew SSL Certificate..."
    /root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
    /root/.acme.sh/acme.sh --issue -d "$domain" --standalone -k ec-256
    ~/.acme.sh/acme.sh --installcert -d "$domain" \
        --fullchainpath /etc/xray/xray.crt \
        --keypath /etc/xray/xray.key --ecc

    echo -e "[ ${green}INFO${NC} ] Generate nginx config..."
    rm -rf /etc/nginx/conf.d/xray.conf 2>/dev/null
    cat > /etc/nginx/conf.d/xray.conf <<EOF
server {
    listen 80;
    listen [::]:80;
    listen 443 ssl http2 reuseport;
    listen [::]:443 ssl http2 reuseport;
    server_name ${domain};

    ssl_certificate     /etc/xray/xray.crt;
    ssl_certificate_key /etc/xray/xray.key;
    ssl_protocols       TLSv1.1 TLSv1.2 TLSv1.3;
    ssl_ciphers         EECDH+CHACHA20:EECDH+ECDSA+AES128:EECDH+AES256:RSA+AES128:RSA+AES256:!MD5;

    root /usr/share/nginx/html;

    location ~* vlessws {
        proxy_pass http://127.0.0.1:14016;
        proxy_http_version 1.1;
        proxy_set_header X-Real-IP aaa;
        proxy_set_header X-Forwarded-For bbb;
        proxy_set_header Upgrade ddd;
        proxy_set_header Connection fff;
        proxy_set_header Host eee;
    }

    location ~* vmessws {
        proxy_pass http://127.0.0.1:23456;
        proxy_http_version 1.1;
        proxy_set_header X-Real-IP aaa;
        proxy_set_header X-Forwarded-For bbb;
        proxy_set_header Upgrade ddd;
        proxy_set_header Connection fff;
        proxy_set_header Host eee;
    }

    location ~* trojan-ws {
        proxy_pass http://127.0.0.1:25432;
        proxy_http_version 1.1;
        proxy_set_header X-Real-IP aaa;
        proxy_set_header X-Forwarded-For bbb;
        proxy_set_header Upgrade ddd;
        proxy_set_header Connection fff;
        proxy_set_header Host eee;
    }

    location ~* ss-ws {
        proxy_pass http://127.0.0.1:30300;
        proxy_http_version 1.1;
        proxy_set_header X-Real-IP aaa;
        proxy_set_header X-Forwarded-For bbb;
        proxy_set_header Upgrade ddd;
        proxy_set_header Connection fff;
        proxy_set_header Host eee;
    }

    location / {
        proxy_pass http://127.0.0.1:700;
        proxy_http_version 1.1;
        proxy_set_header X-Real-IP aaa;
        proxy_set_header X-Forwarded-For bbb;
        proxy_set_header Upgrade ddd;
        proxy_set_header Connection fff;
        proxy_set_header Host eee;
    }

    location ^~ /vless-grpc {
        grpc_pass grpc://127.0.0.1:24456;
        grpc_set_header X-Real-IP aaa;
        grpc_set_header X-Forwarded-For bbb;
        grpc_set_header Host eee;
    }

    location ^~ /vmess-grpc {
        grpc_pass grpc://127.0.0.1:31234;
        grpc_set_header X-Real-IP aaa;
        grpc_set_header X-Forwarded-For bbb;
        grpc_set_header Host eee;
    }

    location ^~ /trojan-grpc {
        grpc_pass grpc://127.0.0.1:33456;
        grpc_set_header X-Real-IP aaa;
        grpc_set_header X-Forwarded-For bbb;
        grpc_set_header Host eee;
    }

    location ^~ /ss-grpc {
        grpc_pass grpc://127.0.0.1:30310;
        grpc_set_header X-Real-IP aaa;
        grpc_set_header X-Forwarded-For bbb;
        grpc_set_header Host eee;
    }
}
EOF

    # Gantikan placeholder menggunakan sed
    sed -i 's/aaa/$remote_addr/g'                /etc/nginx/conf.d/xray.conf
    sed -i 's/bbb/$proxy_add_x_forwarded_for/g'  /etc/nginx/conf.d/xray.conf
    sed -i 's/ddd/$http_upgrade/g'               /etc/nginx/conf.d/xray.conf
    sed -i 's/eee/$http_host/g'                  /etc/nginx/conf.d/xray.conf
    sed -i 's/fff/"upgrade"/g'                   /etc/nginx/conf.d/xray.conf
    sed -i 's/ggg/"websocket"/g'                 /etc/nginx/conf.d/xray.conf

    echo -e "[ ${green}INFO${NC} ] Restarting services..."
    systemctl daemon-reload
    systemctl restart nginx xray.service xray@vmess xray@trojan xray@sodosok

    clear
    echo -e "[ ${green}SUCCESS${NC} ] Domain changed to: \033[1;36m${domain}\033[0m"
    echo ""
    read -n 1 -s -r -p "Press any key to return to menu..."
    menu-vps
}

add_dns() {
    clear
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "\E[44;1;39m         ADD DNS SERVER        \E[0m"
    echo -e "\033[0;34m-------------------------------\033[0m"

    # Check if resolvconf command exists
    if command -v resolvconf >/dev/null 2>&1; then
        HAS_RESOLVCONF=true
    else
        HAS_RESOLVCONF=false
    fi

    # Check if systemd-resolved is active
    if systemctl is-active --quiet systemd-resolved.service; then
        HAS_SYSTEMD_RESOLVED=true
    else
        HAS_SYSTEMD_RESOLVED=false
    fi

    echo "AUTO SCRIPT BY VPN vibecodingxx"
    echo "TELEGRAM : https://t.me/vibecodingxx / @vibecodingxx "
    echo "PLEASE INPUT THE OPTION NUMBER CORRECTLY"
    echo "   1 : INPUT DNS TEMPORARY. REBOOT VPS TO RESET TO DEFAULT DNS"
    echo "   2 : INPUT DNS PERMANENTLY"
    read -p "OPTION NUMBER: " option

    if [ "$option" = "1" ]; then
        if [ "$HAS_RESOLVCONF" = true ]; then
            echo "Using resolvconf (temporary DNS)"
            sudo systemctl enable resolvconf.service >/dev/null 2>&1
            sudo systemctl start resolvconf.service >/dev/null 2>&1
            read -p "KEY IN IP DNS: " ip1
            echo "nameserver $ip1" | sudo tee /etc/resolv.conf >/dev/null
            sudo systemctl restart resolvconf.service >/dev/null 2>&1
        elif [ "$HAS_SYSTEMD_RESOLVED" = true ]; then
            echo "Using systemd-resolved (temporary DNS)"
            read -p "KEY IN IP DNS: " ip1
            # Directly write to /etc/resolv.conf (which is symlinked)
            echo -e "nameserver $ip1" | sudo tee /etc/resolv.conf >/dev/null
            sudo systemctl restart systemd-resolved.service >/dev/null 2>&1
        else
            echo "No resolvconf or systemd-resolved detected. Editing /etc/resolv.conf directly."
            read -p "KEY IN IP DNS: " ip1
            echo "nameserver $ip1" | sudo tee /etc/resolv.conf >/dev/null
        fi
        echo -e "\nTemporary DNS set. Reboot VPS to reset."

    elif [ "$option" = "2" ]; then
        if [ "$HAS_RESOLVCONF" = true ]; then
            echo "Using resolvconf (permanent DNS)"
            sudo systemctl enable resolvconf.service >/dev/null 2>&1
            sudo systemctl start resolvconf.service >/dev/null 2>&1
            read -p "KEY IN IP DNS: " ip2
            sudo truncate -s 0 /etc/resolvconf/resolv.conf.d/head
            echo "nameserver $ip2" | sudo tee /etc/resolvconf/resolv.conf.d/head >/dev/null
            sudo systemctl restart resolvconf.service >/dev/null 2>&1
            sudo resolvconf --enable-updates >/dev/null 2>&1
            sudo resolvconf -u >/dev/null 2>&1
        elif [ "$HAS_SYSTEMD_RESOLVED" = true ]; then
            echo "Using systemd-resolved (permanent DNS)"
            read -p "KEY IN IP DNS: " ip2
            # Modify systemd resolved config for permanent DNS
            sudo sed -i '/^DNS=/d' /etc/systemd/resolved.conf
            sudo sed -i '/^FallbackDNS=/d' /etc/systemd/resolved.conf
            echo "DNS=$ip2" | sudo tee -a /etc/systemd/resolved.conf >/dev/null
            sudo systemctl restart systemd-resolved.service >/dev/null 2>&1
        else
            echo "No resolvconf or systemd-resolved detected."
            echo "Editing /etc/resolv.conf directly (note: changes may be overwritten)"
            read -p "KEY IN IP DNS: " ip2
            echo "nameserver $ip2" | sudo tee /etc/resolv.conf >/dev/null
        fi
        echo -e "\nPermanent DNS set."

    else
        echo "Invalid option selected."
    fi

    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "\E[44;1;39m         CURRENT DNS SERVER    \E[0m"
    echo -e "\033[0;34m-------------------------------\033[0m"
    cat /etc/resolv.conf
    echo -e "\033[0;34m-------------------------------\033[0m"
    read -n 1 -s -r -p "Press any key to back on menu"
    menu-vps
}

cek-nf() {
clear
UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36";
UA_Dalvik="Dalvik/2.1.0 (Linux; U; Android 9; ALP-AL00 Build/HUAWEIALP-AL00)";
DisneyAuth="grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Atoken-exchange&latitude=0&longitude=0&platform=browser&subject_token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJiNDAzMjU0NS0yYmE2LTRiZGMtOGFlOS04ZWI3YTY2NzBjMTIiLCJhdWQiOiJ1cm46YmFtdGVjaDpzZXJ2aWNlOnRva2VuIiwibmJmIjoxNjIyNjM3OTE2LCJpc3MiOiJ1cm46YmFtdGVjaDpzZXJ2aWNlOmRldmljZSIsImV4cCI6MjQ4NjYzNzkxNiwiaWF0IjoxNjIyNjM3OTE2LCJqdGkiOiI0ZDUzMTIxMS0zMDJmLTQyNDctOWQ0ZC1lNDQ3MTFmMzNlZjkifQ.g-QUcXNzMJ8DwC9JqZbbkYUSKkB1p4JGW77OON5IwNUcTGTNRLyVIiR8mO6HFyShovsR38HRQGVa51b15iAmXg&subject_token_type=urn%3Abamtech%3Aparams%3Aoauth%3Atoken-type%3Adevice"
DisneyHeader="authorization: Bearer ZGlzbmV5JmJyb3dzZXImMS4wLjA.Cu56AgSfBTDag5NiRA81oLHkDZfu5L3CKadnefEAY84"
Font_Black="\033[30m";
Font_Red="\033[31m";
Font_Green="\033[32m";
Font_Yellow="\033[33m";
Font_Blue="\033[34m";
Font_Purple="\033[35m";
Font_SkyBlue="\033[36m";
Font_White="\033[37m";
Font_Suffix="\033[0m";
tele="https://t.me/vibecodingxx"
echo -e "\033[0;34m------------------------------------\033[0m"
echo -e "\E[44;1;39m   CHECK DNS REGION BY VPN vibecodingxx   \E[0m"
echo -e "\033[0;34m------------------------------------\033[0m"
echo ""
echo -e "${Font_Blue}SCRIPT EDIT MOD BY VPN vibecodingxx"
echo -e "Streaming Unlock Content Checker By VPN vibecodingxx" 
echo -e "Contact     : ${tele} / @vibecodingxx"
echo -e "system time : $(date)"
echo -e "Message     : Keputusan ujian adalah untuk rujukan sahaja,"
echo -e "              sila rujuk penggunaan sebenar${Font_Suffix}"

export LANG="en_US";
export LANGUAGE="en_US";

function InstallJQ() {
    #Install JQ
    if [ -e "/etc/redhat-release" ];then
        echo -e "${Font_Green} is installing dependencies: epel-release${Font_Suffix}"
        yum install epel-release -y -q > /dev/null;
        echo -e "${Font_Green} is installing dependencies: jq${Font_Suffix}";
        yum install jq -y -q > /dev/null;
        elif [[ $(cat /etc/os-release | grep '^ID=') =~ ubuntu ]] || [[ $(cat /etc/os-release | grep '^ID=') =~ debian ]];then
        echo -e "${Font_Green} is updating package list...${Font_Suffix}";
        apt-get update -y > /dev/null;
        echo -e "${Font_Green} is installing dependencies: jq${Font_Suffix}";
        apt-get install jq -y > /dev/null;
        elif [[ $(cat /etc/issue | grep '^ID=') =~ alpine ]];then
        apk update > /dev/null;
        echo -e "${Font_Green} is installing dependencies: jq${Font_Suffix}";
        apk add jq > /dev/null;
    else
        echo -e "${Font_Red}Please manually install jq${Font_Suffix}";
        exit;
    fi
}

function PharseJSON() {
    # Usage: PharseJSON "Original JSON text to parse" "Key value to parse"
    # Example: PharseJSON ""Value":"123456"" "Value" [Return result: 123456]
    echo -n $1 | jq -r .$2;
}

function GameTest_Steam(){
    echo -n -e " Steam Currency : \c";
    local result=`curl --user-agent "${UA_Browser}" -${1} -fsSL --max-time 30 https://store.steampowered.com/app/761830 2>&1 | grep priceCurrency | cut -d '"' -f4`;
    
    if [ ! -n "$result" ]; then
        echo -n -e "\r Steam Currency : ${Font_Red}Failed (Network Connection)${Font_Suffix}\n" 
        echo -n -e ""
    else
        echo -n -e "\r Steam Currency : ${Font_Green}${result}${Font_Suffix}\n" 
        echo -n -e ""
    fi
}


function MediaUnlockTest_Netflix() {
    echo -n -e " Netflix        :\c";
    local result=`curl -${1} --user-agent "${UA_Browser}" -sSL "https://www.netflix.com/" 2>&1`;
    if [ "$result" == "Not Available" ];then
        echo -n -e "\r Netflix Access : ${Font_Red}Unsupport${Font_Suffix}\n"
        echo -n -e "\r Info           : ${Font_Purple}PM @vibecodingxx for rent DNS Unlock Netflix SG + MY${Font_Suffix}\n"
        return;
    fi
    
    if [[ "$result" == "curl"* ]];then
        echo -n -e "\r Netflix Access : ${Font_Red}No : Failed (Network Connection) ${Font_Suffix}\n"
        echo -n -e "\r Info           : ${Font_Purple}PM @vibecodingxx for rent DNS Unlock Netflix SG + MY${Font_Suffix}\n"
        return;
    fi
    
    local result=`curl -${1} --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/80018499" 2>&1`;
    if [[ "$result" == *"page-404"* ]] || [[ "$result" == *"NSEZ-403"* ]];then
        echo -n -e "\r Netflix Access : ${Font_Red}No${Font_Suffix}\n"
        echo -n -e "\r Info           : ${Font_Purple}PM @vibecodingxx for rent DNS Unlock Netflix SG + MY${Font_Suffix}\n"
        return;
    fi
    
    local result1=`curl -${1} --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/70143836" 2>&1`;
    local result2=`curl -${1} --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/80027042" 2>&1`;
    local result3=`curl -${1} --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/70140425" 2>&1`;
    local result4=`curl -${1} --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/70283261" 2>&1`;
    local result5=`curl -${1} --user-agent "${UA_Browser}"-sL "https://www.netflix.com/title/70143860" 2>&1`;
    local result6=`curl -${1} --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/70202589" 2>&1`;

    if [[ "$result1" == *"page-404"* ]] && [[ "$result2" == *"page-404"* ]] && [[ "$result3" == *"page-404"* ]] && [[ "$result4" == *"page-404"* ]] && [[ "$result5" == *"page-404"* ]] && [[ "$result6" == *"page-404"* ]];then
        echo -n -e "\r Netflix Access : ${Font_Green}Yes${Font_Suffix}\n"
        echo -n -e "\r Netflix Type   : ${Font_Yellow}Only Homemade : Limited Movie :) ${Font_Suffix}\n"
        echo -n -e "\r Info           : ${Font_Purple}PM @vibecodingxx for rent DNS Unlock Netflix SG + MY${Font_Suffix}\n"
        return;
    fi
    
    local region=`tr [:lower:] [:upper:] <<< $(curl -${1} --user-agent "${UA_Browser}" -fs --write-out %{redirect_url} --output /dev/null "https://www.netflix.com/title/80018499" | cut -d '/' -f4 | cut -d '-' -f1)` ;
    
    if [[ ! -n "$region" ]];then
        region="US";
    fi
        echo -n -e "\r Netflix Access : ${Font_Green}Yes${Font_Suffix}\n"
        echo -n -e "\r Netflix Type   : ${Font_SkyBlue}Full (Region: ${region}) : Enjoy Your Movie :) ${Font_Suffix}\n" 
    return;
}    


function MediaUnlockTest_HotStar() {
    echo -n -e " Hotstar Region :\c";
    local result=$(curl $useNIC $xForward --user-agent "${UA_Browser}" -${1} ${ssll} -fsL --write-out %{http_code} --output /dev/null --max-time 10 "https://api.hotstar.com/o/v1/page/1557?offset=0&size=20&tao=0&tas=20")
    if [ "$result" = "000" ]; then
        echo -n -e "\r HotStar        : ${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        return
    elif [ "$result" = "401" ]; then
        local region=$(curl $useNIC $xForward --user-agent "${UA_Browser}" -${1} ${ssll} -sI "https://www.hotstar.com" | grep 'geo=' | sed 's/.*geo=//' | cut -f1 -d",")
        local site_region=$(curl $useNIC $xForward -${1} ${ssll} -s -o /dev/null -L --max-time 10 -w '%{url_effective}\n' "https://www.hotstar.com" | sed 's@.*com/@@' | tr [:lower:] [:upper:])
        if [ -n "$region" ] && [ "$region" = "$site_region" ]; then
            echo -n -e "\r HotStar Region : ${Font_SkyBlue}Full (Region: ${region}) : Enjoy Your Movie :) ${Font_Suffix}\n"
            return
        else
            eecho -n -e "\r Hotstar Region : ${Font_Red}No${Font_Suffix}\n"
            return
        fi
    elif [ "$result" = "475" ]; then
        echo -n -e "\r Hotstar Region : ${Font_Red}No${Font_Suffix}\n"
        return
    else
        echo -n -e "\r Hotstar Region : ${Font_Red}Failed${Font_Suffix}\n"
    fi

}

function MediaUnlockTest_iQiyi(){
    echo -n -e " iQiyi Region   :\c";
    local tmpresult=$(curl -${1} -s -I "https://www.iq.com/" 2>&1);
    if [[ "$tmpresult" == "curl"* ]];then
        	echo -n -e "\r iQiyi Region   : ${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        	return;
    fi
    
    local result=$(echo "${tmpresult}" | grep 'mod=' | awk '{print $2}' | cut -f2 -d'=' | cut -f1 -d';');
    if [ -n "$result" ]; then
		if [[ "$result" == "ntw" ]]; then
			echo -n -e "\r iQiyi Region   : ${Font_Green}Yes(Region: TW)${Font_Suffix}\n"
			return;
		else
			region=$(echo ${result} | tr 'a-z' 'A-Z') 
			echo -n -e "\r iQiyi Region   : ${Font_SkyBlue}Full (Region: ${region}) : Enjoy Your Movie :) ${Font_Suffix}\n"
			return;
		fi	
    else
		echo -n -e "\r iQiyi Region   : ${Font_Red}Failed${Font_Suffix}\n"
		return;
	fi	
}

function MediaUnlockTest_Viu_com() {
    echo -n -e " Viu.com        :\c";
    local tmpresult=$(curl -${1} -s -o /dev/null -L --max-time 30 -w '%{url_effective}\n' "https://www.viu.com/" 2>&1);
	if [[ "${tmpresult}" == "curl"* ]];then
        echo -n -e "\r Viu.com        : ${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        return;
    fi
	
	local result=$(echo ${tmpresult} | cut -f5 -d"/")
	if [ -n "${result}" ]; then
		if [[ "${result}" == "no-service" ]]; then
			echo -n -e "\r Viu.com Region : ${Font_Red}No${Font_Suffix}\n"
			return;
		else
			region=$(echo ${result} | tr 'a-z' 'A-Z')
			echo -n -e "\r Viu.com Region : ${Font_SkyBlue}Full (Region: ${region}) : Enjoy Your Movie :) ${Font_Suffix}\n"
			return;
		fi
    else
		echo -n -e "\r Viu.com Region : ${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
		return;
	fi
}


function MediaUnlockTest_YouTube_Region() {
    echo -n -e " YouTube Region : ->\c";
    local result=`curl --user-agent "${UA_Browser}" -${1} -sSL "https://www.youtube.com/" 2>&1`;
    
    if [[ "$result" == "curl"* ]];then
        echo -n -e "\r YouTube Region : ${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        echo -n -e ""
        return;
    fi
    
    local result=`curl --user-agent "${UA_Browser}" -${1} -sL "https://www.youtube.com/red" | sed 's/,/\n/g' | grep "countryCode" | cut -d '"' -f4`;
    if [ -n "$result" ]; then
        echo -n -e "\r YouTube Region : ${Font_Green}${result}${Font_Suffix}\n" 
        return;
    fi
    
    echo -n -e "\r YouTube Region : ${Font_Red}No${Font_Suffix}\n"
    return;
}

function MediaUnlockTest_DisneyPlus() {
    echo -n -e " DisneyPlus     : \c";
    local result=`curl -${1} --user-agent "${UA_Browser}" -sSL "https://global.edge.bamgrid.com/token" 2>&1`;
    
    if [[ "$result" == "curl"* ]];then
        echo -n -e "\r DisneyPlus     : ${Font_Red}Failed (Network Connection)${Font_Suffix}\n" 
        return;
    fi
    
    local previewcheck=`curl -sSL -o /dev/null -L --max-time 30 -w '%{url_effective}\n' "https://disneyplus.com" 2>&1`;
    if [[ "${previewcheck}" == "curl"* ]];then
        echo -n -e "\r DisneyPlus     : ${Font_Red}Failed (Network Connection)${Font_Suffix}\n" 
        return;
    fi
    
    if [[ "${previewcheck}" == *"preview"* ]];then
        echo -n -e "\r DisneyPlus     : ${Font_Red}No${Font_Suffix}\n" 
        return;
    fi
    
    local result=`curl -${1} --user-agent "${UA_Browser}" -fs --write-out '%{redirect_url}\n' --output /dev/null "https://www.disneyplus.com" 2>&1`;
    if [[ "${website}" == "https://disneyplus.disney.co.jp/" ]];then
        echo -n -e "\r DisneyPlus     : ${Font_Green}Yes(Region: JP)${Font_Suffix}\n"
        return;
    fi
    
    local result=`curl -${1} -sSL --user-agent "$UA_Browser" -H "Content-Type: application/x-www-form-urlencoded" -H "${DisneyHeader}" -d "${DisneyAuth}" -X POST  "https://global.edge.bamgrid.com/token" 2>&1`;
    PharseJSON "${result}" "access_token" 2>&1 > /dev/null;
    if [[ "$?" -eq 0 ]]; then
        local region=$(curl -${1} -sSL https://www.disneyplus.com | grep 'region: ' | awk '{print $2}')
        if [ -n "$region" ];then
            echo -n -e "\r DisneyPlus     : ${Font_Green}Yes(Region: $region)${Font_Suffix}\n"
            return;
        fi
        echo -n -e "\r DisneyPlus     : ${Font_Green}Yes${Font_Suffix}\n" 
        return;
    fi
        echo -n -e "\r DisneyPlus     : ${Font_Red}No${Font_Suffix}\n" 
}

function ISP(){
    local result=`curl -sSL -${1} "https://api.ip.sb/geoip" 2>&1`;
    if [[ "$result" == "curl"* ]];then
        return
    fi
    local ip=$(wget -qO- ipinfo.io/ip);
    local isp=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
    if [ $? -eq 0 ];then
        echo " ** Your IP     : ${ip}"
        echo " ** Your ISP    : ${isp}"
    fi
}

function MediaUnlockTest() {
    ISP ${1};
    MediaUnlockTest_Netflix ${1};
    MediaUnlockTest_YouTube_Region ${1};
    MediaUnlockTest_DisneyPlus ${1};
    MediaUnlockTest_HotStar ${1};
    MediaUnlockTest_Viu_com ${1};
    MediaUnlockTest_iQiyi ${1};
    GameTest_Steam ${1};
}

curl -V > /dev/null 2>&1;
if [ $? -ne 0 ];then
    echo -e "${Font_Red}Please install curl${Font_Suffix}";
    exit;
fi

jq -V > /dev/null 2>&1;
if [ $? -ne 0 ];then
    InstallJQ;
fi
echo " ** Testing IPv4 unlocking"
check4=`ping 1.1.1.1 -c 1 2>&1`;
if [[ "$check4" != *"unreachable"* ]] && [[ "$check4" != *"Unreachable"* ]];then
    MediaUnlockTest 4;
else
    echo -e "${Font_SkyBlue}The current host does not support IPv4, skip...${Font_Suffix}"
fi
    echo -n -e " "
echo -e "\033[0;34m------------------------------------\033[0m"
echo -e "\E[44;1;39m   CHECK DNS REGION BY VPN vibecodingxx   \E[0m"
echo -e "\033[0;34m------------------------------------\033[0m"
    read -n 1 -s -r -p "Press any key to back on menu"
    menu-vps
}

setbot() {
clear
rm -rf /etc/.maA*
rm -rf /etc/token_bott
rm -rf /etc/admin_id
wget -O /usr/bin/botautobckp "${gitlink}/${int}/${sc}/main/otobckpbot.sh" && chmod +x /usr/bin/botautobckp
clear
firtsTimeRun() {

    [[ ! -f /usr/bin/jq ]] && {
        wget -q --no-check-certificate "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64" -O /usr/bin/jq
        chmod +x usr/bin/jq
    }
    [[ ! -d /etc/.maAsiss ]] && mkdir -p /etc/.maAsiss
    [[ ! -f /etc/.maAsiss/.botku ]] && {
        wget -qO- ${gitlink}/${int}/${sc}/main/BotAPI.sh >/etc/.maAsiss/.botku
    }
    [[ ! -f /etc/.maAsiss/backup.conf ]] && {
        echo -ne "Input your Bot TOKEN : "
        read bot_tkn
        echo "Token: $bot_tkn" > /etc/.maAsiss/backup.conf
        echo "Token: $bot_tkn" > /etc/token_bott
        echo -ne "Input your Admin ID : "
        read adm_ids
        echo "AdminID: $adm_ids" >> /etc/.maAsiss/backup.conf
        echo "AdminID: $adm_ids" >> /etc/admin_id
    }
}
firtsTimeRun
backup_bot
fun_bot1() {
			[[ "$(grep -wc "vibecodingxxbot" "/etc/rc.local")" = '0' ]] && {
			    sed -i '$ i\screen -dmS vibecodingxxbot bkp' /etc/rc.local >/dev/null 2>&1
			}
        }
        screen -dmS vibecodingxxbot bkp >/dev/null 2>&1
        fun_bot1
        [[ $(ps x | grep "vibecodingxxbot" | grep -v grep | wc -l) != '0' ]] && echo -e "\nBot successfully activated !" || echo -e "\nError1! Information not valid !"
        sleep 2
        menu
        } || {
       clear
        echo -e "Info...\n"
        fun_bot2() {
            screen -r -S "vibecodingxxbot" -X quit >/dev/null 2>&1
            [[ $(grep -wc "vibecodingxxbot" /etc/rc.local) != '0' ]] && {
                sed -i '/vibecodingxxbot/d' /etc/rc.local
            }
            rm -f /etc/.maAsiss/backup.conf
            sleep 1
        }
        fun_bot2
        echo -e "\nBot Reseller Stopped!"
        sleep 2
        menu
clear
rm -rf /etc/.maA*
rm -rf setbot.sh
rm -rf /root/link.txt
backupmenu-bot        
}

backup_bot() {
clear
IP=$MYIP
date=$(date +"%Y-%m-%d")
token=$(cat /etc/token_bott | awk '{print $2}')
clear
if [[ -z $token ]]; then
echo -e "[ ${green}INFO${NC} ] Please Setbot FIRST!!!"
sleep 3
clear
backupmenu-bot
fi
echo -e "[ ${green}INFO${NC} ] Create password for database"
read -rp "Enter password : " -e InputPass
sleep 1
if [[ -z $InputPass ]]; then
backup_bot
fi
echo -e "[ ${green}INFO${NC} ] Processing... "
rm -rf /root/backup
mkdir -p /root/backup
cp /etc/passwd backup/
cp /etc/group backup/
cp /etc/shadow backup/
cp /etc/gshadow backup/
cp -r /etc/wireguard backup/wireguard
cp -r /usr/local/etc/xray backup/xray/
cd /root
zip -rP $InputPass $IP-$Name-$date.zip backup >/dev/null 2>&1
curl --request POST \
  --url https://api.telegram.org/bot$token/sendDocument?chat_id=$admin \
  --header 'content-type: multipart/form-data' \
  --form document=@/root/$IP-$Name-$date.zip \
  --form 'caption=Here Is Your Backup Files'
clear
rm -rf backup
rm -f /root/$IP-$Name-$date.zip
menu-vps    
}

backupmenu-bot() {
clear
cek=$(grep -c -E "^# BOTBEGIN_Backupp" /etc/crontab)
if [[ "$cek" = "1" ]]; then
sts="On"
else
sts="Off"
fi
start() {
token=$(cat /etc/token_bott | awk '{print $2}')
clear
if [[ -z $token ]]; then
echo -e "[ ${green}INFO${NC} ] Please Setbot FIRST!!!"
sleep 3
clear
backupmenu-bot
fi
sed -i "/^# BOTBEGIN_Backupp/,/^# BOTEND_Backupp/d" /etc/crontab
sed -i "/Auto Backup Status/c\   - Auto Backup Status      : [ON]" /root/log-install.txt
cat << EOF >> /etc/crontab
# BOTBEGIN_Backupp
5 0 * * * root botautobckp
# BOTEND_Backupp
EOF
service cron restart
sleep 1
echo " Please Wait"
clear
echo -e "\033[0;34m-------------------------------\033[0m"
echo -e "\E[44;1;39m Autobackup Has Been Started   \E[0m"
echo -e "\033[0;34m-------------------------------\033[0m"
echo " Noted : Data Will Be Backed Up Automatically at 00:05"
echo -e "\033[0;34m-------------------------------\033[0m"
read -n 1 -s -r -p "Press any key to back on menu"
menu
}
function stop() {
sed -i "/^# BOTBEGIN_Backupp/,/^# BOTEND_Backupp/d" /etc/crontab
sed -i "/Auto Backup Status/c\   - Auto Backup Status      : [OFF]" /root/log-install.txt
service cron restart
sleep 1
echo " Please Wait"
clear
echo -e "\033[0;34m-------------------------------\033[0m"
echo -e "\E[44;1;39m Autobackup Has Been Stopped   \E[0m"
echo -e "\033[0;34m-------------------------------\033[0m"
read -n 1 -s -r -p "Press any key to back on menu"
menu
}

clear
echo -e "\033[0;34m-------------------------------\033[0m"
echo -e "\E[44;1;39m   Telegram Backup Data Menu   \E[0m"
echo -e "\033[0;34m-------------------------------\033[0m"
echo -e " Status AutoBackup : $sts"
echo -e "  1. Setup Telegram Bot"
echo -e "  2. Start Autobackup Telegram Bot"
echo -e "  3. Stop Autobackup Telegram Bot"
echo -e "  4. Backup VPS (Telegram Bot)"
echo -e "  5. Back To Main Menu"
echo -e "\033[0;34m-------------------------------\033[0m"
read -rp " Please Enter The Correct Number : " -e num
if [[ "$num" = "1" ]]; then
setbot
elif [[ "$num" = "2" ]]; then
start
elif [[ "$num" = "3" ]]; then
stop
elif [[ "$num" = "4" ]]; then
backup_bot
elif [[ "$num" = "5" ]]; then
menu
else
echo "Please Enter An Correct Number !"
sleep 3
backupmenu-bot
fi
}

restore() {
    clear
    green='\e[0;32m'
    NC='\e[0m'

    read -p "Link : " link
    clear

    echo "Default Pass From Autobackup File: 123"
    read -p "Pass : " InputPass

    mkdir -p /root/backup
    echo -e "[ ${green}INFO${NC} ] Downloading backup file..."
    wget -q -O /root/backup/backup.zip "$link"

    echo -e "[ ${green}INFO${NC} ] Extracting backup data..."
    unzip -P "$InputPass" /root/backup/backup.zip -d /root/backup >/dev/null 2>&1

    echo -e "[ ${green}INFO${NC} ] Starting data restore..."

    sleep 1
    echo -e "[ ${green}INFO${NC} ] Restoring passwd data..."
    cp /root/backup/passwd /etc/ 2>/dev/null
    sleep 1

    echo -e "[ ${green}INFO${NC} ] Restoring group data..."
    cp /root/backup/group /etc/ 2>/dev/null
    sleep 1

    echo -e "[ ${green}INFO${NC} ] Restoring shadow data..."
    cp /root/backup/shadow /etc/ 2>/dev/null
    sleep 1

    echo -e "[ ${green}INFO${NC} ] Restoring gshadow data..."
    cp /root/backup/gshadow /etc/ 2>/dev/null
    sleep 1

    echo -e "[ ${green}INFO${NC} ] Restoring Wireguard data..."
    cp /root/backup/wireguard /etc/ 2>/dev/null
    sleep 1

    echo -e "[ ${green}INFO${NC} ] Restoring Xray data..."
    cp -r /root/backup/xray /usr/local/etc/
    sleep 1

    rm -rf /root/backup

    echo -e "[ ${green}INFO${NC} ] Restore completed."
    sleep 1

    echo -e "[ ${green}INFO${NC} ] Restarting backup services, please wait..."
    sleep 1

    /etc/init.d/cron restart
    /etc/init.d/nginx restart
    /etc/init.d/squid restart

    systemctl restart xray
    systemctl restart xray.service
    systemctl restart xray@vmess
    systemctl restart xray@trojan
    systemctl restart xray@sodosok
    systemctl restart wg-quick@wg0

    echo -e "[ ${green}INFO${NC} ] All services restarted successfully."
    sleep 3

    clear
    read -n 1 -s -r -p "Press any key to back on menu"
    menu-vps
}

update_sc() {
    versi=$(curl -sS ${gitlink}/${owner}/${sc}/main/versi/main | awk '{print $3}')
    cvursion=$(cat /opt/.ver 2>/dev/null | awk '{print $3}')
    clear
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "\E[44;1;39m        UPDATE SCRIPT VPS      \E[0m"
    echo -e "\033[0;34m-------------------------------\033[0m"

    if [ "$versi" = "$cvursion" ]; then
        echo "Script is already up to date (version $versi)."
        read -p "Do you still want to update? (y/n): " ans
        if [[ $ans =~ ^[Yy]$ ]]; then
            do_update=true
        else
            do_update=false
        fi
    else
        echo "Your script version is outdated (current: $cvursion, latest: $versi)."
        read -p "Do you want to update now? (y/n): " ans
        if [[ $ans =~ ^[Yy]$ ]]; then
            do_update=true
        else
            do_update=false
        fi
    fi

    if [ "$do_update" = true ]; then
        echo "Updating script..."
        wget -q -O /usr/bin/menu "${gitlink}/${int}/${sc}/main/menu.sh" && chmod +x /usr/bin/menu
        wget -q -O /usr/bin/menu-ssh "${gitlink}/${int}/${sc}/main/menu-ssh.sh" && chmod +x /usr/bin/menu-ssh
        wget -q -O /usr/bin/menu-vps "${gitlink}/${int}/${sc}/main/menu-vps.sh" && chmod +x /usr/bin/menu-vps
        wget -q -O /usr/bin/menu-xray "${gitlink}/${int}/${sc}/main/menu-xray.sh" && chmod +x /usr/bin/menu-xray
        wget -q -O /usr/bin/xp "${gitlink}/${int}/${sc}/main/xp.sh" && chmod +x /usr/bin/xp
        wget -q -O /usr/bin/botautobckp "${gitlink}/${int}/${sc}/main/otobckpbot.sh" && chmod +x /usr/bin/botautobckp
        wget -q -O /usr/bin/clearlog "${gitlink}/${int}/${sc}/main/clear-log.sh" && chmod +x /usr/bin/clearlog
        wget -q -O /usr/bin/running "${gitlink}/${int}/${sc}/main/running.sh" && chmod +x /usr/bin/running

        rm -f /opt/.ver
        curl -sS ${gitlink}/${owner}/${sc}/main/versi/main > /opt/.ver

        echo -e "\n\033[0;32mUpdate completed successfully.\033[0m"
    else
        echo -e "\n\033[0;33mUpdate canceled.\033[0m"
    fi

    read -n 1 -s -r -p "Press any key to back on menu"
    menu-vps
}

swap_kvm() {
clear
echo -e "\033[0;34m-------------------------------\033[0m"
echo -e "\E[44;1;39m       SWAP VPS KVM MEMORY     \E[0m"
echo -e "\033[0;34m-------------------------------\033[0m"
dd if=/dev/zero of=/swapfile1 bs=1024 count=524288
dd if=/dev/zero of=/swapfile2 bs=1024 count=524288
mkswap /swapfile1
mkswap /swapfile2
chown root:root /swapfile1
chown root:root /swapfile2
chmod 0600 /swapfile1
chmod 0600 /swapfile2
swapon /swapfile1
swapon /swapfile2
sed -i '$ i\swapon /swapfile1' /etc/rc.local
sed -i '$ i\swapon /swapfile2' /etc/rc.local
sed -i '$ i\/swapfile1      swap swap   defaults    0 0' /etc/fstab
sed -i '$ i\/swapfile2      swap swap   defaults    0 0' /etc/fstab
clear
echo -e "\033[0;34m-------------------------------\033[0m"
echo -e "\E[44;1;39mSWAP VPS KVM MEMORY SUCCESFULLY\E[0m"
echo -e "\033[0;34m-------------------------------\033[0m"
read -n 1 -s -r -p "Press any key to back on menu"
menu-vps 
}

clear_log() {
    clear
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "\E[44;1;39m           CLEAR LOG VPS       \E[0m"
    echo -e "\033[0;34m-------------------------------\033[0m"

    # Kosongkan semua file .log, .err, mail.*
    for log in $(find /var/log/ -type f \( -name "*.log" -o -name "*.err" -o -name "mail.*" \)); do
        echo "$log clear"
        : > "$log"
    done

    # Senarai log spesifik
    logs=(
        /var/log/syslog
        /var/log/btmp
        /var/log/messages
        /var/log/debug
        /var/log/auth.log
        /var/log/alternatives.log
        /var/log/cloud-init.log
        /var/log/cloud-init-output.log
        /var/log/daemon.log
        /var/log/dpkg.log
        /var/log/droplet-agent.update.log
        /var/log/fail2ban.log
        /var/log/kern.log
        /var/log/user.log
        /var/log/xray/access.log
        /var/log/xray/access1.log
        /var/log/xray/access2.log
        /var/log/xray/access3.log
        /var/log/xray/access4.log
        /var/log/xray/error.log
        /var/log/nginx/access.log
        /var/log/nginx/error.log
        /var/log/nginx/vps-access.log
        /var/log/nginx/vps-error.log
    )

    # Kosongkan setiap log dalam array
    for log in "${logs[@]}"; do
        [[ -f "$log" ]] && : > "$log"
    done

    # Buang log rotate file
    rm -f /var/log/btmp.* \
          /var/log/debug.* \
          /var/log/messages.* \
          /var/log/syslog.* \
          /var/log/*.log.* \
          /var/log/nginx/*.log.*

    clear
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "\E[44;1;39m    CLEAR LOG VPS SUCCESFULLY  \E[0m"
    echo -e "\033[0;34m-------------------------------\033[0m"
    read -n 1 -s -r -p "Press any key to back on menu"
    menu-vps
}

restart_all() {
    clear
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "\E[44;1;39m     RESTART ALL SERVICE VPS   \E[0m"
    echo -e "\033[0;34m-------------------------------\033[0m"

    # Restart init.d services
    for svc in ssh dropbear stunnel4 openvpn fail2ban cron nginx squid; do
        /etc/init.d/$svc restart >/dev/null 2>&1
    done

    # Restart systemd services
    for svc in wg-quick@wg0 xray xray.service xray@vmess xray@trojan xray@sodosok dnsmasq; do
        systemctl restart $svc >/dev/null 2>&1
    done

    # Restart badvpn
    screen -dmS badvpn badvpn-udpgw \
        --listen-addr 127.0.0.1:7300 \
        --max-clients 1000

    clear
    running() {
        export IP=$(curl -s https://ipinfo.io/ip/)

        # helper untuk simplify status
        get_status() {
            local svc="$1"
            local running_txt="$2"
            local status=$(systemctl is-active "$svc" 2>/dev/null)
            [[ $status == "active" ]] && echo "${GREEN}Running${NC}" || echo "${RED}Error${NC}"
        }

        # OpenSSH
        openssh=$(get_status ssh "OpenSSH")
        # Stunnel5
        stunnel5=$(get_status stunnel4 "Stunnel5")
        # Dropbear
        dropbear=$(get_status dropbear "Dropbear")
        # Squid
        squid=$(get_status squid "Squid")
        # SSH Websocket
        ssh_ws=$(get_status ws-stunnel "SSH Websocket Proxy")
        # Vless
        vless=$(systemctl show xray --no-page | grep 'ActiveState=' | cut -f2 -d=)
        [[ $vless == "active" ]] && status_vless="${GREEN}Running${NC}" || status_vless="${RED}Error${NC}"
        # Vmess
        vmess=$(systemctl show xray@vmess --no-page | grep 'ActiveState=' | cut -f2 -d=)
        [[ $vmess == "active" ]] && status_vmess="${GREEN}Running${NC}" || status_vmess="${RED}Error${NC}"
        # Trojan
        trojan=$(systemctl show xray@trojan --no-page | grep 'ActiveState=' | cut -f2 -d=)
        [[ $trojan == "active" ]] && status_trojan="${GREEN}Running${NC}" || status_trojan="${RED}Error${NC}"
        # Sodosok
        sodosok=$(systemctl show xray@sodosok --no-page | grep 'ActiveState=' | cut -f2 -d=)
        [[ $sodosok == "active" ]] && status_sodosok="${GREEN}Running${NC}" || status_sodosok="${RED}Error${NC}"
        # NGINX
        nginx1=$(systemctl show nginx --no-page | grep 'ActiveState=' | cut -f2 -d=)
        [[ $nginx1 == "active" ]] && status_nginx="${GREEN}Running${NC}" || status_nginx="${RED}Error${NC}"
        # Wireguard
        wg=$(systemctl show wg-quick@wg0.service --no-page | grep 'ActiveState=' | cut -f2 -d=)
        [[ $wg == "active" ]] && status_wireguard="${GREEN}Running${NC}" || status_wireguard="${RED}Error${NC}"
        # Adguard
        ads=$(systemctl is-active dnsmasq 2>/dev/null)
        if [[ $ads == "active" ]]; then
            status_adguard="${GREEN}Running${NC}"
        elif [[ $ads == "inactive" || $ads == "failed" ]]; then
            status_adguard="${RED}Error${NC}"
        else
            status_adguard="${blue}Adguard Service Not Install${NC}"
        fi

        clear
        echo -e "\033[0;34m----------------------------------------\033[0m"
        echo -e "\E[44;1;39m       SYSTEM       :       STATUS      \E[0m"
        echo -e "\033[0;34m----------------------------------------\033[0m"
        echo -e "Wireguard           :      $status_wireguard"
        echo -e "OpenSSH             :      $openssh"
        echo -e "Dropbear            :      $dropbear"
        echo -e "Stunnel5            :      $stunnel5"
        echo -e "Squid               :      $squid"
        echo -e "NGINX               :      $status_nginx"
        echo -e "SSH NonTLS          :      $ssh_ws"
        echo -e "SSH TLS             :      $ssh_ws"
        echo -e "Vless WS/GRPC       :      $status_vless"
        echo -e "Vmess WS/GRPC       :      $status_vmess"
        echo -e "Trojan WS/GRPC      :      $status_trojan"
        echo -e "Shadowsocks WS/GRPC :      $status_sodosok"
        echo -e "Adguards Service    :      $status_adguard"
    }

    clear
    running
    echo -e "\033[0;34m----------------------------------------\033[0m"
    echo -e "\E[44;1;39m       SUCCESFULLY RUN RESTART VPS      \E[0m"
    echo -e "\033[0;34m----------------------------------------\033[0m"
    read -n 1 -s -r -p "Press any key to back on menu"
    menu-vps
}

check_ram() {
    clear
    echo -e "\033[0;34m----------------------------------------\033[0m"
    echo -e "\E[44;1;39m           CHECK VPS RAM SERVICE        \E[0m"
    echo -e "\033[0;34m----------------------------------------\033[0m"
    ram
    echo -e "\033[0;34m----------------------------------------\033[0m"
    read -n 1 -s -r -p "Press any key to back on menu"
    menu-vps 
}

cert_xray() {
    clear
    domain=$(cat /root/domain)

    echo -e "[ ${green}INFO${NC} ] Starting process..."
    sleep 1

    # Hentikan nginx
    systemctl stop nginx

    # Semak port 80
    Cek=$(lsof -ti:80 | head -n1)
    if [[ -n "$Cek" ]]; then
        ServiceName=$(ps -p "$Cek" -o comm=)
        echo -e "[ ${red}WARNING${NC} ] Port 80 digunakan oleh: $ServiceName (PID: $Cek)"
        sleep 1
        systemctl stop "$ServiceName"
        echo -e "[ ${green}INFO${NC} ] Service $ServiceName dihentikan..."
        sleep 1
    fi

    # Renew SSL cert
    echo -e "[ ${green}INFO${NC} ] Renew SSL Certificate untuk domain: $domain"
    sleep 1
    /root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
    /root/.acme.sh/acme.sh --issue -d "$domain" --standalone -k ec-256
    ~/.acme.sh/acme.sh --installcert -d "$domain" \
        --fullchainpath /etc/xray/xray.crt \
        --keypath /etc/xray/xray.key --ecc

    echo -e "[ ${green}INFO${NC} ] Renew SSL Certificate selesai!"
    sleep 1

    # Restart balik service
    [[ -n "$ServiceName" ]] && systemctl restart "$ServiceName"
    systemctl restart nginx

    clear
    echo -e "[ ${green}SUCCESS${NC} ] Semua selesai untuk domain: \033[1;36m${domain}\033[0m"
    echo ""
    read -n 1 -s -r -p "Tekan sebarang key untuk kembali ke menu..."
    menu-vps
}

running_1() {
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
read -n 1 -s -r -p "Press any key to back on menu"
menu-vps
}

clear
echo -e "\033[0;34m------------------------------------\033[0m"
echo -e "\E[44;1;39m               VPS MENU             \E[0m"
echo -e "\033[0;34m------------------------------------\033[0m"
echo ""
echo -e " [\e[36m 01 \e[0m] Change Domain VPS"
echo -e " [\e[36m 02 \e[0m] Renew Domain Xray Cert"
echo -e " [\e[36m 03 \e[0m] Backup VPS Use Bot Telegram"
echo -e " [\e[36m 04 \e[0m] Restore VPS"
echo -e " [\e[36m 05 \e[0m] Add DNS Server"
echo -e " [\e[36m 06 \e[0m] Check Netflix Region"
echo -e " [\e[36m 07 \e[0m] Update Script"
echo -e " [\e[36m 08 \e[0m] Clear Log VPS"
echo -e " [\e[36m 09 \e[0m] Info Script VPS"
echo -e " [\e[36m 10 \e[0m] Check VPS Ram Usage"
echo -e " [\e[36m 11 \e[0m] Restart All Service"
echo -e " [\e[36m 12 \e[0m] Check All Service Status"
echo -e " [\e[36m 13 \e[0m] Swap KVM Memory Service"
echo -e " [\e[36m 14 \e[0m] Set Auto Reboot VPS"
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
opt=$(echo "$opt" | sed 's/^0*//')

case $opt in
1)
    clear
    add-host
    ;;
2)
    cert_xray
    ;;  
3)
    clear
    backupmenu-bot
    ;;
4)
    clear
    restore
    ;;
5)
    clear
    add_dns
    ;;
6)
    clear
    cek-nf
    ;;
7)
    clear
    update_sc
    ;;
8)
    clear
    clear_log
    ;;
9)
    clear
    check_port
    ;;
10)
    clear
    check_ram
    ;; 
11)
    restart_all
    ;;
12)
    running_1
    ;;   
13)
    swap_kvm
    ;; 
14)
    autoreboot
    ;; 
x)  clear
    menu
    ;;
*)
    echo -e ""
    echo "Sila Pilih Semula"
    sleep 1
    menu-vps
    ;;
esac