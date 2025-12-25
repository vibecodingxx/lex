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

VERSIONNAME="Adguards v"
VERSIONNUMBER="1.0"
GREEN="\e[1;32m"
RED="\e[1;31m"
WHITE="\e[1m"
NOCOLOR="\e[0m"

providers="/etc/dnsmasq/providers.txt"
dnsmasqHostFinalList="/etc/dnsmasq/adblock.hosts"
tempHostsList="/etc/dnsmasq/list.tmp"
publicIP=$(wget -qO- ipinfo.io/ip)
whitelist="/etc/dnsmasq/whitelist.hosts"

custom_dnsmasq () {
systemctl stop dnsmasq
systemctl disable dnsmasq
clear
rm /lib/systemd/system/dnsmasq.service
cat << EOF >> /lib/systemd/system/dnsmasq.service
[Unit]
Description=dnsmasq - Custom DHCP and caching DNS server By VPN vibecodingxx
Documentation=https://t.me/vibecodingxx http://${host}
Requires=network.target
Wants=nss-lookup.target
Before=nss-lookup.target
After=network.target

[Service]
Type=forking
PIDFile=/run/dnsmasq/dnsmasq.pid

ExecStartPre=/usr/sbin/dnsmasq --test
ExecStart=/etc/init.d/dnsmasq systemd-exec
ExecStartPost=/etc/init.d/dnsmasq systemd-start-resolvconf
ExecStop=/etc/init.d/dnsmasq systemd-stop-resolvconf
Restart=on-failure
RestartPreventExitStatus=23

ExecReload=/bin/kill -HUP AAA

[Install]
WantedBy=multi-user.target
EOF

sed -i 's/AAA/$MAINPID/g' /lib/systemd/system/dnsmasq.service
sed -i 's/REPORT_ABSENT_SYMLINK=y/REPORT_ABSENT_SYMLINK=n/g' /etc/resolvconf/update.d/libc
systemctl daemon-reload > /dev/null 2>&1
systemctl start dnsmasq > /dev/null 2>&1
systemctl enable dnsmasq > /dev/null 2>&1
clear
}

dnsmasqconf () {
clear
read -p " Please Input Your DNS or Tap Enter to Continue Default DNS: " defaultip
if [ -z $defaultip ]; then
defaultip="1.1.1.1"
fi
ifconfig | grep -w 'eth0:' | cut -f1 -d: >> /root/et_temp
eth0=$(cat /root/et_temp)
if [[ $eth0 == "eth0" ]]; then
eth0=eth0
else
eth0=ens3
fi
rm -rf /etc/dnsmasq.conf
cat << EOF >> /etc/dnsmasq.conf
bogus-priv
no-resolv
server=$defaultip
#listen-address=YourPublicIP
cache-size=2048
local-ttl=60
interface=$eth0
addn-hosts=/etc/dnsmasq/adblock.hosts
EOF
}

function header() {
	echo -e $GREEN" $VERSIONNAME$VERSIONNUMBER" $NOCOLOR
	echo -e -n "MOD by "
	echo -e $WHITE"VPN vibecodingxx" $NOCOLOR
	echo -e $LIGHT"Thanks To Abi Darwish" $NOCOLOR
}

function isRoot() {
	if [ "${EUID}" != 0 ]; then
		echo " You need to run this script as root"
		exit 1
	fi
}

function checkVirt() {
	if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo " OpenVZ is not supported"
		exit 1
	fi
	if [ "$(systemd-detect-virt)" == "lxc" ]; then
		echo " LXC is not supported (yet)"
		exit 1
	fi
}

function checkOS() {
 	if [[ $(grep -w "ID" /etc/os-release | awk -F'=' '{print $2}') -ne "debian" ]] || [[ $(grep -w "ID" /etc/os-release | awk -F'=' '{print $2}') -ne "ubuntu" ]]; then
		clear
        	header
 		echo
 		echo -e ${RED}" Your OS is not supported. Please use Debian/Ubuntu"$NOCOLOR
 		echo ""
 		exit 1
	fi
}

function initialCheck() {
	isRoot
	checkVirt
	checkOS
}

function install() {
	read -p " Are you sure to install Adguards? [y/n]: " INSTALL
	if [[ $INSTALL == "y" ]]; then
	echo -e " Installing Custom Adguards..."
    	if [[ ! -e /etc/dnsmasq ]]; then
    		mkdir -p /etc/dnsmasq
	fi
    	if [[ ! -e /etc/resolv.conf.bak ]]; then
       		cp /etc/resolv.conf /etc/resolv.conf.bak
    	fi
    	if [[ $(lsof -i :53 | grep -w -c "systemd-r") -ge "1" ]]; then
    		systemctl disable systemd-resolved
		systemctl stop systemd-resolved
		unlink /etc/resolv.conf
                echo "nameserver 1.1.1.1" > /etc/resolv.conf
    	fi
        rm -rf /var/lib/dpkg/statoverride > /dev/null 2>&1
    	apt update && apt install -y dnsmasq dnsutils vnstat resolvconf
        custom_dnsmasq
    	mv /etc/dnsmasq.conf /etc/dnsmasq.conf.bak
	rm -rf /etc/dnsmasq.conf
        dnsmasqconf
	rm -rf /root/et_temp
    	sed -i "s/YourPublicIP/${publicIP}/" /etc/dnsmasq.conf
	rm -rf ${providers}
	rm -rf ${whitelist}
    	wget -q -O ${providers} "https://raw.githubusercontent.com/vibecodingxx/adguards/main/providers.txt"
    	wget -q -O ${whitelist} "https://raw.githubusercontent.com/vibecodingxx/adguards/main/whitelist.hosts"
	sleep 1
	updateEngine
	rm -rf /etc/resolvconf/resolv.conf.d/original > /dev/null 2>&1
        > /etc/resolvconf/resolv.conf.d/original
	echo "nameserver 127.0.0.1" > /etc/resolv.conf
        echo "nameserver 127.0.0.1" > /etc/resolvconf/resolv.conf.d/head
        systemctl restart dnsmasq
	sleep 1
	clear
    	echo -e " Installation completed"
    	echo
	echo -e " System will load to Adguard menu in 5 sec"
	sleep 5
	clear
	adguard
	else
	echo -e " Adguards is not install"
	echo
	read -p " Press Enter back to menu..."
	menu
	fi
}

function start() {
	clear
	header
	echo
	if [[ $(systemctl is-active dnsmasq) == "active" ]]; then
		echo -e $GREEN" Adguards is already running"$NOCOLOR
		echo
		read -p $' Press Enter to continue...'
		mainMenu
	fi
        systemctl enable dnsmasq
	systemctl restart dnsmasq
	sleep 2
	echo -e -n " Starting Adguards..."
	echo -e $GREEN"done"$NOCOLOR
	echo
	read -p $' Press Enter to continue...'
	mainMenu
}

function stop() {
	clear
	header
	echo
	if [[ $(systemctl is-active dnsmasq) == "active" ]]; then
		echo -e $GREEN" Adguards is running"$NOCOLOR
		echo
		read -p " Are you sure to stop Adguards? [y/n]: " STOP
		if [[ $STOP == "y" ]]; then
                        systemctl disable dnsmasq
			systemctl stop dnsmasq
			echo "nameserver 1.1.1.1" > /etc/resolv.conf
			echo -e -n " Stopping Adguards..."
			sleep 2
			echo -e $GREEN"done"$NOCOLOR
			echo
			read -p " Press Enter to continue..."
			mainMenu
		else
			echo -e " Adguards is not stopped"
			echo
			read -p " Press Enter to continue..."
			mainMenu
		fi
	else
		echo -e $RED" Adguards is already stopped"$NOCOLOR
		echo
		read -p " Press Enter to continue..."
		mainMenu
	fi
}

function changeDNS() {
	clear
   	header
    	echo
    	echo -e " Proxy server IP address to bypass Netflix"
    	read -p " (press c to cancel): " DNS
    	oldDNS=$(grep -E -w "^server" /etc/dnsmasq.conf | cut -d '=' -f2 | tail -1)
    	if [[ $DNS == "c" ]]; then
        	mainMenu
    	fi
    	if [[ -z $DNS ]]; then
        	changeDNS
    	fi
    	sed -i "s/server=${oldDNS}/server=${DNS}/" /etc/dnsmasq.conf
        systemctl restart dnsmasq
    	sleep 1
    	echo -e -n " DNS server has been changed to "
    	echo -e $GREEN"$DNS"$NOCOLOR
    	echo
    	read -p " Press Enter to continue..."
    	mainMenu
}

function uninstall() {
	clear
	header
	echo
	read -p " Are you sure to uninstall Adguards? [y/n]: " UNINSTALL
	if [[ $UNINSTALL == "y" ]]; then
		systemctl stop dnsmasq
		systemctl disable dnsmasq
		apt remove -y dnsmasq > /dev/null 2>&1
		rm -rf /etc/dnsmasq
                > /etc/resolvconf/resolv.conf.d/original
                > /etc/resolvconf/resolv.conf.d/head
		mv /etc/resolv.conf.bak /etc/resolv.conf
		sed -i 's/REPORT_ABSENT_SYMLINK=n/REPORT_ABSENT_SYMLINK=y/g' /etc/resolvconf/update.d/libc
		systemctl daemon-reload
		echo -e -n " Uninstalling Adguards..."
		sleep 2
		echo -e $GREEN"done"$NOCOLOR
		echo
		echo -e " System will back to menu in 5 sec"
		sleep 5
		clear
		menu
	else
		echo -e " Adguards is not removed"
		echo
		read -p " Press Enter to continue..."
		mainMenu
	fi
}

function updateEngine() {
	echo -e -n " Updating blocked hostnames..."
	> ${tempHostsList}
    	while IFS= read -r line; do
        	list_url=$(echo $line | grep -E -v "^#" | cut -d '"' -f2)
        	curl "${list_url}" 2> /dev/null | sed -E '/^!/d' | sed '/#/d' | sed -E 's/^\|\|/0.0.0.0 /g' | awk -F '^' '{print $1}' | grep -E "^0.0.0.0" >> ${tempHostsList}
    	done < ${providers}
    	if [[ ! -z $(ip a | grep -w "inet6") ]]; then
    		grep -E "^0.0.0.0" ${tempHostsList} | sed -E 's/^0.0.0.0/::1/g' >> ${tempHostsList}
	fi
    	cat ${tempHostsList} | sed '/^$/d' | sed -E '/^0.0.0.0 0.0.0.0/d' | sed -E '/^::1 0.0.0.0/d' | sort | uniq > ${dnsmasqHostFinalList}
	if [[ ! -e /etc/dnsmasq/whitelist.hosts ]]; then
		touch /etc/dnsmasq/whitelist.hosts
	fi
	DATA=$(cat /etc/dnsmasq/whitelist.hosts)
	for HOSTNAME in ${DATA}; do
		sed -E -i "/${HOSTNAME}/d" /etc/dnsmasq/adblock.hosts
	done
    	systemctl restart dnsmasq
    	echo -e ${GREEN}"done"${NOCOLOR}
    	sleep 1
    	echo -e -n $GREEN" $(cat ${dnsmasqHostFinalList} | wc -l) "$NOCOLOR
   	echo -e "hostnames have been blocked"
}

function listUpdate() {
    	clear
    	header
    	echo
    	read -p " Do you want to update blocked hostnames? [y/n]: " UPDATE
    	if [[ $UPDATE == "y" ]]; then
    	       updateEngine
    	       echo
    	       read -p " Press Enter to continue..."
    	       mainMenu
    	 else
    	       mainMenu
    	 fi
}

function activateProvider() {
	clear
	header
	echo
	if [[ ! -e /etc/dnsmasq/providers.tmp ]]; then
	       cp /etc/dnsmasq/providers.txt /etc/dnsmasq/providers.tmp
	fi
	printf " ${WHITE}%-26s %10s${NOCOLOR}\n" "LIST PROVIDER" "STATUS"
	echo " --------------------------------------"
	while IFS= read -r line; do
		ACTIVE_PROVIDER=$(echo $line | grep -v -E "^#" | cut -d '=' -f1)
		INACTIVE_PROVIDER=$(echo $line | grep -E "^#" | cut -d '=' -f1 | sed -E 's/^#//g')
		if [[ $(echo $line | grep -v -c -E "^#") -gt 0 ]]; then
		 	printf " %-25s \e[1;32m%12s\e[0m\n" "${ACTIVE_PROVIDER}" "active"
		else
			printf " %-25s \e[1;31m%12s\e[0m\n" "${INACTIVE_PROVIDER}" "inactive"
		fi
	done < /etc/dnsmasq/providers.tmp
	echo
	if [[ ! -z $(diff -q /etc/dnsmasq/providers.tmp /etc/dnsmasq/providers.txt) ]]; then
		read -p " Select a provider to be activated
 (press s to apply changes or c to cancel): " SELECT
	else
		read -p " Select a provider to be activated
 (press c to cancel): " SELECT
	fi
    	if [[ $SELECT == s ]]; then
		mv /etc/dnsmasq/providers.tmp /etc/dnsmasq/providers.txt
		echo " Applying changes..."
		updateEngine
		echo
		read -p " Press Enter to continue..."
		mainMenu
    	fi
    	if [[ $SELECT == c ]]; then
		rm -rf /etc/dnsmasq/providers.tmp
		mainMenu
	fi
	if [[ -z $SELECT ]]; then
		activateProvider
	fi
	if [[ $(grep -E -c -w "^#${SELECT}" /etc/dnsmasq/providers.tmp) != 0 ]]; then
		sed -E -i "s/^\#${SELECT}/${SELECT}/" /etc/dnsmasq/providers.tmp
		activateProvider
	else
		echo -e " ${SELECT} is already active"
	fi
    	echo
    	read -p " Press Enter to continue..."
	activateProvider
}

function deactivateProvider() {
	clear
	header
	echo
	if [[ ! -e /etc/dnsmasq/providers.tmp ]]; then
	       cp /etc/dnsmasq/providers.txt /etc/dnsmasq/providers.tmp
	fi
	printf " ${WHITE}%-26s %10s${NOCOLOR}\n" "LIST PROVIDER" "STATUS"
	echo " --------------------------------------"
	while IFS= read -r line; do
		ACTIVE_PROVIDER=$(echo $line | grep -v -E "^#" | cut -d '=' -f1)
		INACTIVE_PROVIDER=$(echo $line | grep -E "^#" | cut -d '=' -f1 | sed -E 's/^#//g')
		if [[ $(echo $line | grep -v -c -E "^#") -gt 0 ]]; then
		 	printf " %-25s \e[1;32m%12s\e[0m\n" "${ACTIVE_PROVIDER}" "active"
		else
			printf " %-25s \e[1;31m%12s\e[0m\n" "${INACTIVE_PROVIDER}" "inactive"
		fi
	done < /etc/dnsmasq/providers.tmp
	echo
	if [[ ! -z $(diff -q /etc/dnsmasq/providers.tmp /etc/dnsmasq/providers.txt) ]]; then
		read -p " Select a provider to be activated
 (press s to apply changes or c to cancel): " SELECT
       else
       		read -p " Select a provider to be deactivated
 (press c to cancel): " SELECT
       fi
       if [[ $SELECT == s ]]; then
       		mv /etc/dnsmasq/providers.tmp /etc/dnsmasq/providers.txt
		echo " Applying changes..."
		updateEngine
		echo
		read -p " Press Enter to continue..."
		mainMenu
	fi
	if [[ $SELECT == c ]]; then
		rm -rf /etc/dnsmasq/providers.tmp
		mainMenu
    	fi
    	if [[ -z $SELECT ]]; then
        	deactivateProvider
    	fi
	if [[ $(grep -E -c -w "^#${SELECT}" /etc/dnsmasq/providers.tmp) == 0 ]]; then
		sed -E -i "s/^${SELECT}/\#${SELECT}/" /etc/dnsmasq/providers.tmp
		deactivateProvider
	else
		echo -e " ${SELECT} is already inactive"
	fi
    	echo
    	read -p " Press Enter to continue..."
	deactivateProvider
}

function whitelistHost() {
	clear
	header
	echo
	if [[ ! -e /etc/dnsmasq/whitelist.hosts ]]; then
		touch /etc/dnsmasq/whitelist.hosts
	fi
	if [[ ! -e /etc/dnsmasq/whitelist.hosts.tmp ]]; then
	       cp /etc/dnsmasq/whitelist.hosts /etc/dnsmasq/whitelist.hosts.tmp
	fi
	printf " ${WHITE}%-26s %10s${NOCOLOR}\n" "HOST" "STATUS"
	echo " --------------------------------------"
	if [[ -z $(cat /etc/dnsmasq/whitelist.hosts.tmp) ]]; then
		echo -e " List is empty"
	fi
	while IFS= read -r line; do
		ACTIVE_HOST=$(echo $line)
		printf " %-25s \e[1;32m%12s\e[0m\n" "${ACTIVE_HOST}" "whitelisted"
	done < /etc/dnsmasq/whitelist.hosts.tmp
	echo
	if [[ ! -z $(diff -q /etc/dnsmasq/whitelist.hosts.tmp /etc/dnsmasq/whitelist.hosts) ]]; then
		read -p " Select a url from above to delete or type a new one to whitelist
 (press s to apply changes or c to cancel): " SELECT
    	else
       		read -p " Select a url from above to delete or type a new one to whitelist
 (press c to cancel): " SELECT
    	fi
	if [[ $SELECT == s ]]; then
       		mv /etc/dnsmasq/whitelist.hosts.tmp /etc/dnsmasq/whitelist.hosts
		updateEngine
		echo
		read -p " Press Enter to continue..."
		mainMenu
	fi
	if [[ $SELECT == c ]]; then
		rm -rf /etc/dnsmasq/whitelist.hosts.tmp
		mainMenu
    	fi
    	if [[ -z $SELECT ]]; then
        	whitelistHost
    	fi
	if [[ $(grep -c -w "${SELECT}" /etc/dnsmasq/whitelist.hosts.tmp) == 0 ]]; then
		echo "${SELECT}" >> /etc/dnsmasq/whitelist.hosts.tmp
		sed -i '/^$/d' /etc/dnsmasq/whitelist.hosts.tmp | sort | uniq
		whitelistHost
	else
		read -p " Do you want to delete this url? [y/n]: " DELETE
		if [[ ${DELETE} == y ]]; then
			sed -E -i "/^${SELECT}/d" /etc/dnsmasq/whitelist.hosts.tmp
			whitelistHost
		else
			whitelistHost
		fi
	fi
}

function mainMenu() {
	clear
	header
	echo
	echo -e " \e[1mSystem Status\e[0m"
	if [[ $(systemctl is-active dnsmasq) == active ]]; then
        	printf " %-25s %1s \e[1;32m%7s\e[0m" "Dnsmasq" ":" "running"
		printf "\n %-25s %1s \e[1;32m%7s\e[0m" "Active since" ":" "$(systemctl status dnsmasq.service | grep -w "Active" | awk '{print $9,$10,$11,$12}')"
    	else
        	printf " %-25s %1s \e[1;31m%7s\e[0m" "Dnsmasq" ":" "stopped"
    	fi
     	NAMESERVER=$(grep -w -E "^server" /etc/dnsmasq.conf | head -n 1 | awk -F'=' '{print $2}')
        DNS=$(grep -w -E "^server" /etc/dnsmasq.conf | tail -1 | awk -F'=' '{print $2}')
     	printf "\n %-25s %1s \e[1;32m%7s\e[0m" "Nameserver" ":" "$NAMESERVER"
        printf "\n %-25s %1s \e[1;32m%7s\e[0m" "DNS RESOLVER" ":" "$DNS"
	printf "\n %-25s %1s \e[1;32m%'d\n\e[0m" "Blocked hostnames" ":" "$(cat ${dnsmasqHostFinalList} | wc -l)"
    	echo
	echo -e " \e[1mVPS Info\e[0m"
	CPU=$(cat /proc/cpuinfo | grep "model\|Model" | tail -n 1 | awk -F: '{print $2}' | cut -d " " -f2-4)
	CPU_CORE=$(lscpu | grep "CPU(s)" | head -n 1 | awk '{print $2}')
	CPU_MHZ=$(lscpu | grep "MHz" | head -n 1 | sed 's/ //g' | awk -F: '{print $2}' | cut -d. -f1)
	OS=$(cat /etc/os-release |grep "PRETTY_NAME" | awk -F\" '{print $2}')
	KERNEL=$(uname -r)
	RAM_USED=$(free -m | grep Mem: | awk '{print $3}')
	TOTAL_RAM=$(free -m | grep Mem: | awk '{print $2}')
	RAM_USAGE=$(echo "scale=2; ($RAM_USED / $TOTAL_RAM) * 100" | bc | cut -d. -f1)
	DATE=$(date | awk '{print $2,$3,$4,$5,$6}')
    	UPTIME=$(uptime -p | sed 's/,//g' | awk '{print $2,$3", "$4,$5}')
	DAILY_USAGE=$(vnstat -d --oneline | awk -F\; '{print $6}' | sed 's/ //')
	MONTHLY_USAGE=$(vnstat -m --oneline | awk -F\; '{print $11}' | sed 's/ //')
	if [[ ${CPU_CORE} == 1 ]]; then
		printf " %-25s %1s %-7s\e[0m" "CPU (single core)" ":" "${CPU} @ ${CPU_MHZ}Mhz"
	else
		printf " %-25s %1s %-7s\e[0m" "CPU (${CPU_CORE} cores)" ":" "${CPU} @ ${CPU_MHZ}Mhz"
	fi
	printf "\n %-25s %1s %-7s\e[0m" "OS Version" ":" "${OS}"
	printf "\n %-25s %1s %-7s\e[0m" "Kernel Version" ":" "${KERNEL}"
	printf "\n %-25s %1s %-7s\e[0m" "RAM Usage" ":" "${RAM_USED}MB / ${TOTAL_RAM}MB (${RAM_USAGE}%)"
	printf "\n %-25s %1s %-7s\e[0m" "Date" ":" "${DATE}"
    	printf "\n %-25s %1s %-7s\e[0m" "Uptime" ":" "${UPTIME}"
 	printf "\n %-25s %1s %-7s\e[0m" "IP Address" ":" "${publicIP}"
	printf "\n %-25s %1s %-7s\e[0m" "Daily Data Usage" ":" "${DAILY_USAGE}"
	printf "\n %-25s %1s %-7s\e[0m" "Monthly Data Usage" ":" "${MONTHLY_USAGE}"
	echo
	echo
	echo -e $WHITE" Manage Adguards"$NOCOLOR
 	echo -e " [1] Start Dnsmasq\t   [6] Deactivate provider
 [2] Stop Dnsmasq\t   [7] Whitelist host
 [3] Update hostnames\t   [8] Uninstall Adguards
 [4] Bypass Netflix\t   [9] Exit to Menu
 [5] Activate Provider"
	echo
	read -p $' Enter option [1-9]: ' MENU_OPTION
	case ${MENU_OPTION} in
	1)
		start
	   	;;
	2)
		stop
		;;
	3)
		listUpdate
		;;
	4)
		changeDNS
		;;
   	5)
		activateProvider
		;;
    	6)
        	deactivateProvider
        	;;
	7)
		whitelistHost
		;;
	8)
		uninstall
		;;
	9)
		menu
		;;
	*)
	mainMenu
	esac
}

initialCheck
if [[ ! -z $(which dnsmasq) ]] && [[ -e /etc/dnsmasq ]]; then
	mainMenu
else
	clear
	header
	echo
	install
fi