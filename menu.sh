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

trial_wg() {
    wg_user trial
}

add_wg() {
    wg_user add
}

# Fungsi utama untuk handle kedua-dua mode
wg_user() {
    local mode=$1  # "trial" or "add"
    clear
    if [[ $mode == "trial" ]]; then
        echo -e "\033[0;34m------------------------------------\033[0m"
        echo -e "\E[44;1;39m         TRIAL WIREGUARD USER       \E[0m"
        echo -e "\033[0;34m------------------------------------\033[0m"
    else
        echo -e "\033[0;34m------------------------------------\033[0m"
        echo -e "\E[44;1;39m          ADD WIREGUARD USER        \E[0m"
        echo -e "\033[0;34m------------------------------------\033[0m"
        echo ""
    fi

    source /etc/wireguard/params
    source /var/lib/premium-script/ipvps.conf

    if [[ "$IP" == "" ]]; then
        SERVER_PUB_IP=$(wget -qO- ipinfo.io/ip)
    else
        SERVER_PUB_IP=$IP
    fi

    if [[ $mode == "trial" ]]; then
        CLIENT_NAME="TrialWG-$(</dev/urandom tr -dc 0-9A-Z | head -c4)"
    else
        while true; do
            read -rp "Client name: " CLIENT_NAME
            if [[ ! $CLIENT_NAME =~ ^[a-zA-Z0-9_]+$ ]]; then
                echo "Only letters, numbers and underscore allowed."
                continue
            fi
            CLIENT_EXISTS=$(grep -w "$CLIENT_NAME" /etc/wireguard/wg0.conf | wc -l)
            if [[ $CLIENT_EXISTS == "1" ]]; then
                echo "Client name exists, choose another."
                continue
            fi
            break
        done
    fi

    ENDPOINT="$SERVER_PUB_IP:$SERVER_PORT"
    WG_CONFIG="/etc/wireguard/wg0.conf"
    LASTIP=$(grep "/32" "$WG_CONFIG" | tail -n1 | awk '{print $3}' | cut -d "/" -f 1 | cut -d "." -f 4)
    if [[ -z "$LASTIP" ]]; then
        CLIENT_ADDRESS="10.66.66.2"
    else
        CLIENT_ADDRESS="10.66.66.$((LASTIP+1))"
    fi

    CLIENT_DNS_1="8.8.8.8"
    CLIENT_DNS_2="8.8.4.4"
    MYIP=$(wget -qO- ipinfo.io/ip)

    if [[ $mode == "trial" ]]; then
        Jumlah_Hari=1
        exp=$(date -d "$Jumlah_Hari days" +"%Y-%m-%d")
        hariini=$(date +"%Y-%m-%d")
    else
        read -rp "Expired (days): " Jumlah_Hari
        exp=$(date -d "$Jumlah_Hari days" +"%Y-%m-%d")
        hariini=$(date +"%Y-%m-%d")
    fi

    read -rp "Wildcard BUG Domain? (Y/N): " ans
    BUG=""
    if [[ "$ans" =~ ^[yY]$ ]]; then
        read -rp "Input Wildcard BUG: " BUG
        BUG="${BUG}."
    fi

    # Generate keys
    CLIENT_PRIV_KEY=$(wg genkey)
    CLIENT_PUB_KEY=$(echo "$CLIENT_PRIV_KEY" | wg pubkey)
    CLIENT_PRE_SHARED_KEY=$(wg genpsk)

    # Create client config file
    CLIENT_CONF_PATH="$HOME/$SERVER_WG_NIC-client-$CLIENT_NAME.conf"
    cat > "$CLIENT_CONF_PATH" <<EOF
[Interface]
PrivateKey = $CLIENT_PRIV_KEY
Address = $CLIENT_ADDRESS/24
DNS = $CLIENT_DNS_1,$CLIENT_DNS_2

[Peer]
PublicKey = $SERVER_PUB_KEY
PresharedKey = $CLIENT_PRE_SHARED_KEY
Endpoint = ${BUG}$ENDPOINT
AllowedIPs = 0.0.0.0/0,::/0
EOF

    # Add peer to server config
    echo -e "### Client $CLIENT_NAME $exp
[Peer]
PublicKey = $CLIENT_PUB_KEY
PresharedKey = $CLIENT_PRE_SHARED_KEY
AllowedIPs = $CLIENT_ADDRESS/32" >> "/etc/wireguard/$SERVER_WG_NIC.conf"

    systemctl restart "wg-quick@$SERVER_WG_NIC"
    cp "$CLIENT_CONF_PATH" /home/vps/public_html/$CLIENT_NAME.conf

    # Show output
    clear
    sleep 0.5
    echo "Generate PrivateKey"
    sleep 0.5
    echo "Generate PublicKey"
    sleep 0.5
    echo "Generate PresharedKey"
    sleep 1
    clear
    echo -e "\033[0;34m------------------------------------\033[0m"
    if [[ $mode == "trial" ]]; then
        echo -e "\E[44;1;39m  TRIAL WIREGUARD USER INFORMATION  \E[0m"
    else
        echo -e "\E[44;1;39m     WIREGUARD USER INFORMATION     \E[0m"
    fi
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e " Username           : $CLIENT_NAME"
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "Wireguard Config Link  : "
    echo ""
    echo "http://$MYIP:81/$CLIENT_NAME.conf"
    echo ""
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e " Created date       : $hariini"
    echo -e " Expired date       : $exp"
    echo -e "\033[0;34m------------------------------------\033[0m"

    rm -f /root/wg0-client-$CLIENT_NAME.conf
    read -n 1 -s -r -p "Press any key to back on menu"
    menu-wg
}

renew_wg() {
    clear
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "\E[44;1;39m         RENEW WIREGUARD USER       \E[0m"
    echo -e "\033[0;34m------------------------------------\033[0m"

    source /etc/wireguard/params

    NUMBER_OF_CLIENTS=$(grep -c -E "^### Client" "/etc/wireguard/$SERVER_WG_NIC.conf")
    if [[ $NUMBER_OF_CLIENTS == 0 ]]; then
        echo "You have no existing clients!"
        echo -e "\033[0;34m------------------------------------\033[0m"
        read -n 1 -s -r -p "Press any key to back on menu"
        menu-wg
        return
    fi

    echo "Select an existing client that you want to renew"
    echo " Press CTRL+C to return"
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo "     No  Expired   User"
    grep -E "^### Client" "/etc/wireguard/$SERVER_WG_NIC.conf" | cut -d ' ' -f 3-4 | nl -s ') '

    CLIENT_NUMBER=""
    until [[ $CLIENT_NUMBER =~ ^[0-9]+$ ]] && (( CLIENT_NUMBER >= 1 && CLIENT_NUMBER <= NUMBER_OF_CLIENTS )); do
        if [[ $NUMBER_OF_CLIENTS -eq 1 ]]; then
            read -rp "Select one client [1]: " CLIENT_NUMBER
            CLIENT_NUMBER=${CLIENT_NUMBER:-1}
        else
            read -rp "Select one client [1-$NUMBER_OF_CLIENTS]: " CLIENT_NUMBER
        fi
    done

    masaaktif=""
    until [[ $masaaktif =~ ^[0-9]+$ && $masaaktif -gt 0 ]]; do
        read -rp "Expired (days): " masaaktif
    done

    user=$(sed -n "${CLIENT_NUMBER}p" < <(grep -E "^### Client" "/etc/wireguard/$SERVER_WG_NIC.conf" | cut -d ' ' -f 3))
    exp=$(sed -n "${CLIENT_NUMBER}p" < <(grep -E "^### Client" "/etc/wireguard/$SERVER_WG_NIC.conf" | cut -d ' ' -f 4))

    today=$(date +%Y-%m-%d)
    d1=$(date -d "$exp" +%s)
    d2=$(date -d "$today" +%s)

    # Calculate remaining days if expiry is in future, else 0
    if (( d1 > d2 )); then
        remaining_days=$(( (d1 - d2) / 86400 ))
    else
        remaining_days=0
    fi

    new_expiry_days=$(( remaining_days + masaaktif ))
    new_expiry_date=$(date -d "$new_expiry_days days" +"%Y-%m-%d")

    # Update expiry in config
    sed -i "s/### Client $user $exp/### Client $user $new_expiry_date/g" "/etc/wireguard/$SERVER_WG_NIC.conf"

    clear
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "\E[44;1;39m   Account Was Successfully Renewed  \E[0m"
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo " Client Name  : $user"
    echo " Renew date   : $today"
    echo " New Expiry   : $new_expiry_date"
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo ""

    read -n 1 -s -r -p "Press any key to back on menu"
    menu-wg
}

del_wg() {
    clear
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "\E[44;1;39m        DELETE WIREGUARD USER       \E[0m"
    echo -e "\033[0;34m------------------------------------\033[0m"

    source /etc/wireguard/params

    NUMBER_OF_CLIENTS=$(grep -c -E "^### Client" "/etc/wireguard/$SERVER_WG_NIC.conf")
    if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
        echo "You have no existing clients!"
        echo -e "\033[0;34m------------------------------------\033[0m"
        read -n 1 -s -r -p "Press any key to back on menu"
        menu-wg
        return
    fi

    echo " Select the existing client you want to remove"
    echo " Press CTRL+C to return"
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo "     No  Expired   User"
    grep -E "^### Client" "/etc/wireguard/$SERVER_WG_NIC.conf" | cut -d ' ' -f 3-4 | nl -s ') '

    until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
        if [[ ${NUMBER_OF_CLIENTS} == 1 ]]; then
            read -rp $'\033[0;34m------------------------------------\033[0m\nSelect one client [1]: ' CLIENT_NUMBER
        else
            read -rp $'\033[0;34m------------------------------------\033[0m\nSelect one client [1-'${NUMBER_OF_CLIENTS}']: ' CLIENT_NUMBER
        fi
    done

    # Ambil nama user dan tarikh expired dari config
    CLIENT_NAME=$(sed -n "${CLIENT_NUMBER}p" < <(grep -E "^### Client" "/etc/wireguard/$SERVER_WG_NIC.conf" | cut -d ' ' -f 3-4))
    user=$(echo "$CLIENT_NAME" | cut -d ' ' -f1)
    exp=$(echo "$CLIENT_NAME" | cut -d ' ' -f2)
    hariini=$(date +"%Y-%m-%d")

    # Hapus [Peer] block untuk user yang dipilih
    sed -i "/^### Client $user $exp/,/^AllowedIPs/d" "/etc/wireguard/$SERVER_WG_NIC.conf"

    # Hapus fail konfigurasi user
    rm -f "/home/vps/public_html/$user.conf"

    # Restart WireGuard dan cron
    systemctl restart "wg-quick@$SERVER_WG_NIC"
    systemctl restart cron

    clear
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "\E[44;1;39m  Account Was Successfully Deleted  \E[0m"
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo " Client Name  : $user"
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo " Delete date  : $hariini"
    echo " Expired On   : $exp"
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo ""

    read -n 1 -s -r -p "Press any key to back on menu"
    menu-wg
}

cek_wg() {
    clear
    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "\E[44;1;39m        Wireguard User Login        \E[0m"
    echo -e "\033[0;34m------------------------------------\033[0m"

    > /etc/wireguard/clients.txt
    mapfile -t clients < <(grep "^### Client" /etc/wireguard/wg0.conf | awk '{print $3}')

    hr() {
        numfmt --to=iec-i --suffix=B "$1"
    }

    if [[ ${#clients[@]} -eq 0 ]]; then
        echo "::: There are no clients to list"
        read -n 1 -s -r -p "Press any key to back on menu"
        menu-wg
        return
    fi

    # Ambil PublicKey list selari dengan clients
    mapfile -t pubs < <(grep -A 1 '^PublicKey' /etc/wireguard/wg0.conf | grep 'PublicKey' | awk '{print $3}')

    # Simpan username dan publickey ke clients.txt
    for i in "${!clients[@]}"; do
        echo "${clients[$i]} ${pubs[$i]}" >> /etc/wireguard/clients.txt
    done

    CLIENTS_FILE="/etc/wireguard/clients.txt"

    listClients() {
        if ! DUMP=$(wg show wg0 dump); then
            echo "Failed to get wg dump"
            exit 1
        fi
        DUMP=$(tail -n +2 <<< "$DUMP")

        printf "\e[1m::: Connected Clients List :::\e[0m\n"
        printf "\e[4mName\e[0m  \t  \e[4mRemote IP\e[0m  \t  \e[4mVirtual IP\e[0m  \t  \e[4mBytes Received\e[0m  \t  \e[4mBytes Sent\e[0m  \t  \e[4mLast Seen\e[0m\n"

        while IFS= read -r LINE; do
            [[ -z "$LINE" ]] && continue

            PUBLIC_KEY=$(awk '{print $1}' <<< "$LINE")
            REMOTE_IP=$(awk '{print $3}' <<< "$LINE")
            VIRTUAL_IP=$(awk '{print $4}' <<< "$LINE")
            BYTES_RECEIVED=$(awk '{print $6}' <<< "$LINE")
            BYTES_SENT=$(awk '{print $7}' <<< "$LINE")
            LAST_SEEN=$(awk '{print $5}' <<< "$LINE")
            CLIENT_NAME=$(grep "$PUBLIC_KEY" "$CLIENTS_FILE" | awk '{print $1}')

            if [[ "$LAST_SEEN" -ne 0 ]]; then
                LAST_SEEN_FORMATTED=$(date -d @"$LAST_SEEN" '+%b %d %Y - %T')
            else
                LAST_SEEN_FORMATTED="(not yet)"
            fi

            printf "%s  \t  %s  \t  %s  \t  %'d  \t  %'d  \t  %s\n" \
                "$CLIENT_NAME" "$REMOTE_IP" "${VIRTUAL_IP/\/32/}" "$BYTES_RECEIVED" "$BYTES_SENT" "$LAST_SEEN_FORMATTED"
        done <<< "$DUMP" | column -t -s $'\t'

        echo ""
    }

    listClients

    echo -e "\033[0;34m------------------------------------\033[0m"
    echo -e "Script By VPN vibecodingxx"
    read -n 1 -s -r -p "Press any key to back on menu"
    menu-wg
}

fix_wg() {
    echo "[INFO] Stopping WireGuard interface wg0..."
    systemctl stop wg-quick@wg0

    echo "[INFO] Installing dependencies..."
    apt install -y lsb-release net-tools iproute2 openresolv dnsutils linux-headers-$(uname -r)

    # Tambah backports repo jika belum ada
    BACKPORTS_LIST="/etc/apt/sources.list.d/backports.list"
    if ! grep -q "$(lsb_release -sc)-backports" "$BACKPORTS_LIST" 2>/dev/null; then
        echo "deb http://deb.debian.org/debian $(lsb_release -sc)-backports main" > "$BACKPORTS_LIST"
        echo "[INFO] Added backports repository."
    else
        echo "[INFO] Backports repository already exists."
    fi

    apt update -y

    echo "[INFO] Installing WireGuard tools from backports..."
    apt -y --no-install-recommends install wireguard-tools wireguard-dkms

    echo "[INFO] Starting and enabling WireGuard service..."
    systemctl start wg-quick@wg0
    systemctl enable wg-quick@wg0

    echo "[WARNING] The system will reboot now to apply changes."
    read -p "Press ENTER to reboot or Ctrl+C to cancel..."

    reboot
}

menu-wg() {
clear
echo -e "\033[0;34m------------------------------------\033[0m"
echo -e "\E[44;1;39m            WIREGUARD MENU          \E[0m"
echo -e "\033[0;34m------------------------------------\033[0m"
echo ""
echo -e " [\e[36m 01 \e[0m] Trial Wireguard"
echo -e " [\e[36m 02 \e[0m] Add Wireguard"
echo -e " [\e[36m 03 \e[0m] Delete Wireguard"
echo -e " [\e[36m 04 \e[0m] Extend Wireguard"
echo -e " [\e[36m 05 \e[0m] Check User Login"
echo -e " [\e[36m 06 \e[0m] Fix Wireguard Service"
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
    trial_wg
    ;;
2|02)
    clear
    add_wg
    ;;
3|03)
    clear
    del_wg
    ;;
4|04)
    clear
    renew_wg
    ;;   
5|05)
    clear
    cek_wg
    ;;
6|06)
    clear
    fix_wg
    ;;   
x|X)
    clear
    menu
    ;;
*)
    echo -e ""
    echo "Sila Pilih Semula"
    sleep 1
    menu-wg
    ;;
esac
}

add-bug() {
BUG_DIR="/root/bug"

# Hanya buat directory kalau belum ada
[ ! -d "$BUG_DIR" ] && mkdir -p "$BUG_DIR"

while true; do
    clear
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e "\E[44;1;39m   MENU PENGURUSAN TELCO BUG  \E[0m"
    echo -e "\033[0;34m-------------------------------\033[0m"
    echo -e " [\e[36m 01 \e[0m] Tambah Bug / Telco"
    echo -e " [\e[36m 02 \e[0m] Delete Bug Telco"
    echo -e " [\e[36m 03 \e[0m] Delete Telco"
    echo ""
    echo -e "Press x or [ Ctrl+C ]   To-Exit"
    echo -e "\033[0;34m-------------------------------\033[0m"
    read -p "Pilih menu: " MENU

    case "$MENU" in
        1) # Tambah bug / buat telco baru
            TELCOS=($(ls "$BUG_DIR"))
            if [ ${#TELCOS[@]} -eq 0 ]; then
                echo "Tiada telco sedia ada, sila buat telco baru."
                while true; do
                    read -p "Masukkan nama telco baru (x untuk back): " TELCO
                    [[ "$TELCO" == "x" ]] && break 2
                    [[ -z "$TELCO" ]] && break
                    FILE="$BUG_DIR/$TELCO"
                    if [ -f "$FILE" ]; then
                        echo "Telco [$TELCO] sudah wujud. Masukkan nama lain."
                    else
                        read -p "Masukkan domain bug pertama (x untuk back): " BUG
                        [[ "$BUG" == "x" ]] && break 2
                        echo "$BUG" > "$FILE"
                        echo "Telco [$TELCO] berjaya dibuat dengan bug [$BUG]"
                        break
                    fi
                done
                read -p "Tekan Enter untuk kembali..."
                continue
            fi

            echo "Senarai telco sedia ada:"
            for i in "${!TELCOS[@]}"; do
                echo "$((i+1)). ${TELCOS[$i]}"
            done
            NEXT=$(( ${#TELCOS[@]} + 1 ))
            echo "$NEXT. Buat telco baru"
            read -p "Pilih nombor telco (x untuk back): " IDX
            [[ "$IDX" == "x" ]] && continue

            if [ "$IDX" -eq "$NEXT" ]; then
                while true; do
                    read -p "Masukkan nama telco baru (x untuk back): " TELCO
                    [[ "$TELCO" == "x" ]] && break 2
                    [[ -z "$TELCO" ]] && break
                    FILE="$BUG_DIR/$TELCO"
                    if [ -f "$FILE" ]; then
                        echo "Telco [$TELCO] sudah wujud. Masukkan nama lain."
                    else
                        read -p "Masukkan domain bug pertama (x untuk back): " BUG
                        [[ "$BUG" == "x" ]] && break 2
                        echo "$BUG" > "$FILE"
                        echo "Telco [$TELCO] berjaya dibuat dengan bug [$BUG]"
                        break
                    fi
                done
                read -p "Tekan Enter untuk kembali..."
                continue
            fi

            if ! [[ "$IDX" =~ ^[0-9]+$ ]] || [ "$IDX" -lt 1 ] || [ "$IDX" -gt ${#TELCOS[@]} ]; then
                echo "Pilihan tidak sah!"
                read -p "Tekan Enter untuk kembali..."
                continue
            fi

            TELCO="${TELCOS[$((IDX-1))]}"
            FILE="$BUG_DIR/$TELCO"

            while true; do
                read -p "Masukkan domain bug baru (x untuk back): " BUG
                [[ "$BUG" == "x" ]] && break
                [[ -z "$BUG" ]] && break
                if grep -Fxq "$BUG" "$FILE"; then
                    echo "Bug [$BUG] sudah wujud dalam telco [$TELCO]!"
                else
                    echo "$BUG" >> "$FILE"
                    echo "Bug [$BUG] berjaya ditambah ke telco [$TELCO]"
                fi
                read -p "Tekan Enter untuk teruskan..."
                break
            done
            ;;

        2) # Delete bug
            TELCOS=($(ls "$BUG_DIR"))
            if [ ${#TELCOS[@]} -eq 0 ]; then
                echo "Tiada telco tersedia!"
                read -p "Tekan Enter untuk kembali..."
                continue
            fi
            echo "Senarai telco:"
            for i in "${!TELCOS[@]}"; do
                echo "$((i+1)). ${TELCOS[$i]}"
            done
            read -p "Pilih nombor telco (x untuk back): " IDX
            [[ "$IDX" == "x" ]] && continue
            if ! [[ "$IDX" =~ ^[0-9]+$ ]] || [ "$IDX" -lt 1 ] || [ "$IDX" -gt ${#TELCOS[@]} ]; then
                echo "Pilihan tidak sah!"
                read -p "Tekan Enter untuk kembali..."
                continue
            fi
            TELCO="${TELCOS[$((IDX-1))]}"
            FILE="$BUG_DIR/$TELCO"

            mapfile -t BUGS < "$FILE"
            if [ ${#BUGS[@]} -eq 0 ]; then
                echo "Tiada bug dalam telco [$TELCO]"
                read -p "Tekan Enter untuk kembali..."
                continue
            fi

            echo "Senarai bug dalam [$TELCO]:"
            for i in "${!BUGS[@]}"; do
                echo "$((i+1)). ${BUGS[$i]}"
            done
            read -p "Pilih nombor bug untuk delete (x untuk back): " BIDX
            [[ "$BIDX" == "x" ]] && continue
            if ! [[ "$BIDX" =~ ^[0-9]+$ ]] || [ "$BIDX" -lt 1 ] || [ "$BIDX" -gt ${#BUGS[@]} ]; then
                echo "Pilihan tidak sah!"
                read -p "Tekan Enter untuk kembali..."
                continue
            fi
            BUG_DEL="${BUGS[$((BIDX-1))]}"
            sed -i "${BIDX}d" "$FILE"
            echo "Bug [$BUG_DEL] berjaya dibuang dari telco [$TELCO]"

            # Kalau fail jadi kosong ? auto delete
            if [ ! -s "$FILE" ]; then
                rm -f "$FILE"
                echo "Telco [$TELCO] dibuang sebab tiada bug tersisa."
            fi

            read -p "Tekan Enter untuk kembali..."
            ;;

        3) # Delete telco terus
            TELCOS=($(ls "$BUG_DIR"))
            if [ ${#TELCOS[@]} -eq 0 ]; then
                echo "Tiada telco tersedia!"
                read -p "Tekan Enter untuk kembali..."
                continue
            fi
            echo "Senarai telco:"
            for i in "${!TELCOS[@]}"; do
                echo "$((i+1)). ${TELCOS[$i]}"
            done
            read -p "Pilih nombor telco untuk delete (x untuk back): " IDX
            [[ "$IDX" == "x" ]] && continue
            if ! [[ "$IDX" =~ ^[0-9]+$ ]] || [ "$IDX" -lt 1 ] || [ "$IDX" -gt ${#TELCOS[@]} ]; then
                echo "Pilihan tidak sah!"
                read -p "Tekan Enter untuk kembali..."
                continue
            fi
            TELCO="${TELCOS[$((IDX-1))]}"
            FILE="$BUG_DIR/$TELCO"

            read -p "Anda pasti mahu delete telco [$TELCO]? (y/n): " CONFIRM
            if [[ "$CONFIRM" == "y" ]]; then
                rm -f "$FILE"
                echo "Telco [$TELCO] berjaya dibuang."
            else
                echo "Batal delete telco [$TELCO]."
            fi
            read -p "Tekan Enter untuk kembali..."
            ;;

        x)
            menu
            ;;
        *)
            echo "Pilihan tak sah!"
            read -p "Tekan Enter untuk kembali..."
            ;;
    esac
done
}

admin-cek() {
    admin=$(curl -sS "${gitlink}/${owner}/ip-admin/main/access" | awk '{print $2}' | grep -w "$MYIP")
    tokengit=$(cat /etc/admin/token 2>/dev/null)

    if [[ "$admin" == "$MYIP" ]]; then
        echo -e "${green}Permission Accepted...${NC}"

        if [[ -z "$tokengit" ]]; then
            clear
            read -rp "Do you wish to setup Admin Access? (Y/N): " ans
            if [[ "$ans" =~ ^[Yy]$ ]]; then
                wget "${gitlink}/${owner}/ip-admin/main/admin/install.sh" -O install.sh
                chmod +x install.sh
                ./install.sh
                menu-admin
            else
                echo -e "${yellow}Admin setup skipped.${NC}"
                menu
            fi
        else
	    clear
            echo -e "\033[0;34m----------------------------------------\033[0m"
            echo -e "\E[44;1;39m        INFO MENU ADMIN VPN vibecodingxx     \E[0m"
            echo -e "\033[0;34m----------------------------------------\033[0m"
            echo -e "Choose option:"
            echo -e "1) Continue to Admin Menu"
            echo -e "2) Reset Admin Setup"
            echo -e "3) Delete Admin Setup"
            echo -e "\033[0;34m----------------------------------------\033[0m"
            read -rp "Enter choice [1-3] Or [0] back to menu: " choice
            case $choice in
                1)
                    menu-admin
                    ;;
                2)
                    echo -e "${green}Resetting Admin Setup...${NC}"
                    rm -rf /etc/admin
                    sed -i '/# IPREGBEGIN_EXP/,/# IPREGEND_EXPIP/d' /etc/crontab
                    wget "${gitlink}/${owner}/ip-admin/main/admin/install.sh" -O install.sh
                    chmod +x install.sh
                    ./install.sh
                    menu-admin
                    ;;
                3)
                    echo -e "${yellow}Deleting Admin Setup only...${NC}"
                    rm -rf /etc/admin
                    sed -i '/# IPREGBEGIN_EXP/,/# IPREGEND_EXPIP/d' /etc/crontab
                    sleep 2
                    menu
                    ;;
                0)
                    menu
                    ;;
                *)
                    echo -e "${red}Invalid choice!${NC}"
                    sleep 2
                    menu
                    ;;
            esac
        fi

    else
        echo -e "${red}Permission Denied!${NC}"
        clear
        rm -rf /etc/admin > /dev/null 2>&1
        sed -i '/# IPREGBEGIN_EXP/,/# IPREGEND_EXPIP/d' /etc/crontab
        echo "Your IP is not allowed to access this feature"
        sleep 5
        menu
    fi
}

# Variable to check access status
if [[ "$admin_check" == "$MYIP" ]]; then
    adAccess="Allowed"
else
    adAccess="Not Allowed"
fi

ads-guard() {
if [[ ! -z $(which dnsmasq) ]] && [[ -e /etc/dnsmasq ]]; then
	clear
	adguard
else
	clear
	wget -O /usr/bin/adguard "${gitlink}/${int}/${sc}/main/ads-guard.sh" && chmod +x /usr/bin/adguard && adguard
	
fi
}

# ============================
# Get VPS Info (Safe Version)
# ============================

# VPS Type
Checkstart1=$(ip route | grep default | awk '{print $3}' | head -n 1)
if [[ "$Checkstart1" == "venet0" ]]; then 
    lan_net="venet0"
    typevps="OpenVZ"
else
    lan_net="eth0"
    typevps="KVM"
fi

# OS Uptime
uptime="$(uptime -p | cut -d " " -f 2-10)"

# Download & Upload (sum of interfaces)
download=$(grep -E "lo:|wlan0:|eth0:" /proc/net/dev | awk '{print $2}' | paste -sd+ - | bc)
downloadsize=$((download / 1073741824))

upload=$(grep -E "lo:|wlan0:|eth0:" /proc/net/dev | awk '{print $10}' | paste -sd+ - | bc)
uploadsize=$((upload / 1073741824))

# Download/Upload today using vnstat for eth0
ddtoday=$(vnstat -i eth0 | awk '/today/ {print $2, substr($3,1,1)}')
uutoday=$(vnstat -i eth0 | awk '/today/ {print $5, substr($6,1,1)}')
tttoday=$(vnstat -i eth0 | awk '/today/ {print $8, substr($9,1,1)}')

fr="\033[0;34m"
bck="\033[0m"
dtoday="${fr}${ddtoday}${bck}"
utoday="${fr}${uutoday}${bck}"
ttoday="${fr}${tttoday}${bck}"

# CPU Usage
cpu_usage1=$(ps aux | awk 'BEGIN{sum=0} {sum+=$3} END{print sum}')
corediilik=$(nproc 2>/dev/null || echo 1)
cpu_usage=$(( ${cpu_usage1%.*} / corediilik ))
cpu_usage="${cpu_usage} %"

# Shell Version
versibash="Bash Version ${BASH_VERSION%%-*}"

# OS Info
source /etc/os-release
Versi_OS=$VERSION
ver=$VERSION_ID
Tipe=$NAME
URL_SUPPORT=$HOME_URL
basedong=$ID
OS=$(hostnamectl | grep "Operating System" | cut -d ':' -f2- | sed 's/^ *//')

# Get VPS IP, ISP, City, Timezone (no token needed)
IPVPS=$(curl -s https://ipinfo.io/ip)
ISP=$(curl -s "http://ip-api.com/line/?fields=isp")
CITY=$(curl -s "http://ip-api.com/line/?fields=city")
WKT=$(curl -s "http://ip-api.com/line/?fields=timezone")
DAY=$(date +%A)
DATE=$(date +%Y-%m-%d)
msa=$(date +"%X")

# Domain
domain="/root/domain"
if [[ -f "$domain" ]]; then
    domain=$(cat "$domain")
else
    domain="(not set)"
fi

# Telegram
tele="@vibecodingxx"

# CPU Info
cname=$(awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^ //')
cores=$(awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo)
freq=$(awk -F: '/cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo | sed 's/^ //')

# RAM Info
tram=$(free -m | awk 'NR==2 {print $2}')
uram=$(free -m | awk 'NR==2 {print $3}')
fram=$(free -m | awk 'NR==2 {print $4}')
swap=$(free -m | awk 'NR==4 {print $2}')

# Total User counts
SSHUSER=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)
VLESSUSER=$(grep -E "^### " "/usr/local/etc/xray/vless.json" 2>/dev/null | sort -u | wc -l)
VMESSUSER=$(grep -E "^### " "/usr/local/etc/xray/vmess.json" 2>/dev/null | sort -u | wc -l)
TROJANUSER=$(grep -E "^### " "/usr/local/etc/xray/trojan.json" 2>/dev/null | sort -u | wc -l)
SODOSOKUSER=$(grep -E "^### " "/usr/local/etc/xray/sodosok.json" 2>/dev/null | sort -u | wc -l)

# Default values for unknown variables used below
Name="${Name:-Unknown}"
scexpireddate="${scexpireddate:-N/A}"
sisa_hari="${sisa_hari:-0}"
sc="${sc:-Script}"
scv="${scv:-Version}"

clear
echo -e "\033[0;34m----------------------------------------\033[0m"
echo -e "\E[44;1;39m          INFO VPS BY VPN vibecodingxx        \E[0m"
echo -e "\033[0;34m----------------------------------------\033[0m"
echo -e " VPS Type             :  \033[0;34m$typevps\033[0m"
echo -e " CPU Model            :  \033[0;34m$cname\033[0m"
echo -e " CPU Frequency        :  \033[0;34m$freq MHz\033[0m"
echo -e " Number Of Cores      :  \033[0;34m$cores\033[0m"
echo -e " CPU Usage            :  \033[0;34m$cpu_usage\033[0m"
echo -e " Operating System     :  \033[0;34m$OS\033[0m"
echo -e " OS Family            :  \033[0;34m$(uname -s)\033[0m"	
echo -e " Kernel               :  \033[0;34m$(uname -r)\033[0m"
echo -e " Bash Ver             :  \033[0;34m$versibash\033[0m"
echo -e " Total Amount Of RAM  :  \033[0;34m$tram MB\033[0m"
echo -e " Used RAM             :  \033[0;34m$uram MB\033[0m"
echo -e " Free RAM             :  \033[0;34m$fram MB\033[0m"
echo -e " System Uptime        :  \033[0;34m$uptime (From VPS Booting)\033[0m"
echo -e " Download             :  \033[0;34m$downloadsize GB (From VPS Booting)\033[0m"
echo -e " Upload               :  \033[0;34m$uploadsize GB (From VPS Booting)\033[0m"
echo -e " Domain VPS           :  \033[0;34m$domain\033[0m"	
echo -e " IP VPS               :  \033[0;34m$IPVPS\033[0m"	
echo -e " Day, Date & Time     :  \033[0;34m$DAY $DATE $msa\033[0m"
echo -e " Telegram             :  \033[0;34m$tele\033[0m"
echo -e "\033[0;34m----------------------------------------\033[0m"
echo -e  "Traffic    Download     Upload     Total"
echo -e  "Today      $dtoday      $utoday    $ttoday"  
echo -e "\033[0;34m----------------------------------------\033[0m"
echo -e  "Proto  SSH    Vless    Vmess  Trojan  Sodosok"
echo -e  "User\t$SSHUSER\t$VLESSUSER\t$VMESSUSER\t$TROJANUSER\t$SODOSOKUSER"  
echo -e "\033[0;34m----------------------------------------\033[0m"
echo -e "\E[44;1;39m           MENU SCRIPT VPN vibecodingxx       \E[0m"
echo -e "\033[0;34m----------------------------------------\033[0m"
echo ""
echo -e " [\e[36m 01 \e[0m] Menu SSH"
echo -e " [\e[36m 02 \e[0m] Menu Wireguard"
echo -e " [\e[36m 03 \e[0m] Menu XRAY"
echo -e " [\e[36m 04 \e[0m] Menu VPS"
echo -e " [\e[36m 05 \e[0m] Menu AdGuard"
echo -e " [\e[36m 06 \e[0m] Bug Telco Management"

# Menu admin hanya keluar jika Allowed
if [[ "$adAccess" == "Allowed" ]]; then
    echo -e " [\e[36m 07 \e[0m] MENU ADMIN ($adAccess)"
fi

echo ""
echo -e "Press x or [ Ctrl+C ] to exit"
echo ""
echo -e "\033[0;34m------------------------------------\033[0m"
echo -e "Client Name    : $Name"
echo -e "Expiry script  : $scexpireddate"
echo -e "Countdown Days : $sisa_hari Days Left"
echo -e "Script Type    : $sc $scv"
echo -e "\033[0;34m------------------------------------\033[0m"
echo ""

read -rp " Select menu : " opt
echo ""

case $opt in
1|01)
    clear
    menu-ssh
    ;;
2|02)
    clear
    menu-wg
    ;;
3|03)
    clear
    menu-xray
    ;;
4|04)
    clear
    menu-vps
    ;;
5|05)
    clear
    ads-guard
    ;;
6|06)
    clear
    add-bug
    ;;
7|07)
    if [[ "$adAccess" == "Allowed" ]]; then
        clear
        admin-cek
    else
        echo "Access denied!"
        sleep 1
        menu
    fi
    ;;
x|X)
    exit 0
    ;;
*)
    echo ""
    echo "Sila Pilih Semula"
    sleep 1
    menu
    ;;
esac