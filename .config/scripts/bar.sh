#!/bin/bash
while :
do
    battery=$(cat /sys/class/power_supply/BAT1/capacity)
    ethprice=$(curl 'https://api.coingecko.com/api/v3/simple/price?ids=ethereum&vs_currencies=USD' | jq '.ethereum.usd')
    diskused=$(df -lah | grep /dev/sda2 | awk '{print $3}')
    disktotal=$(df -lah | grep /dev/sda2 | awk '{print $2}')
    memused="$(free -m | grep "Mem" | awk '{print $3}')"
    cpupercent=$(top -bn1 | grep "Cpu(s)" | \
           sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
           awk '{print 100 - $1"%"}')
    xsetroot -name "|  disk: ${diskused}/${disktotal}  |  cpu: ${cpupercent}  |  memory: ${memused}Mb  |  bat: ${battery}%  |  eth: Ξ ${ethprice}  |  $(date +%F) $(date +%I:%M)  |"
    sleep 1m
done
