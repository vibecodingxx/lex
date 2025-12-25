#!/bin/bash

# Warna
BLUE="\033[0;34m"
GREEN="\033[0;32m"
NC="\033[0m"  # No Color

# Header
echo -e "${GREEN}=================== Memory Usage Report ===================${NC}"
echo "Generated: $(date '+%a %d %b %Y %r %Z')"
echo -e "${BLUE}-----------------------------------------------------------${NC}"
printf "| %-30s | %10s | %10s |\n" "Program" "Processes" "Memory"
echo -e "${BLUE}-----------------------------------------------------------${NC}"

# Ambil data memory per program, susun besar ke kecil, buang 0 KiB
ps --no-headers -eo comm,rss | awk '
{ mem[$1]+=$2; count[$1]++ }
END {
  for (p in mem) {
    if (mem[p]>0) printf "%s %d %d\n", p, count[p], mem[p]
  }
}' | sort -k3 -nr | while read prog proc rss; do
    # Tukar KB ke MiB/KiB
    if [ $rss -ge 1024 ]; then
        mem=$(awk "BEGIN {printf \"%.1f MiB\", $rss/1024}")
    else
        mem="${rss} KiB"
    fi
    printf "| %-30s | %10d | %10s |\n" "$prog" "$proc" "$mem"
done

echo -e "${BLUE}-----------------------------------------------------------${NC}"

# Total memory
total=$(ps --no-headers -eo rss | awk '{sum+=$1} END {printf "%.1f MiB", sum/1024}')
echo -e "Total Memory: ${total}"

# Tunggu user tekan key
echo
read -n 1 -s -r -p "Press any key to back on menu"
menu
