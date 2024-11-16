#!/bin/bash

echo "------------------ Server Performance Stats ------------------"

# Total CPU usage
echo "Total CPU Usage:"
top -l 1 | awk '/CPU usage/ {printf "User: %.2f%%, System: %.2f%%, Idle: %.2f%%\n", $3, $5, $7}'

# Total memory usage
echo -e "\nTotal Memory Usage:"
vm_stat | awk 'BEGIN {total=0; free=0} 
/Pages free:/ {free=$NF} 
/Pages active:/ {total+=$NF} 
/Pages inactive:/ {total+=$NF} 
/Pages speculative:/ {total+=$NF} 
/Pages wired down:/ {total+=$NF} 
/Pages occupied by compressor:/ {total+=$NF} 
END {total*=4096; free*=4096; used=total-free; printf "Used: %.2f GB\nFree: %.2f GB\nUsage: %.2f%%\n", used/(1024^3), free/(1024^3), (used/total)*100}'

# Total disk usage
echo -e "\nTotal Disk Usage:"
df -h / | awk 'NR==2 {printf "Used: %s\nFree: %s\nUsage: %s\n", $3, $4, $5}'


echo -e "\nTop 5 Processes by CPU Usage:"
ps -arcwwwxo pid,comm,%cpu | head -n 6


echo -e "\nTop 5 Processes by Memory Usage:"
ps -arcwwwxo pid,comm,%mem | head -n 6

echo "------------------------------------------------------------"
clea