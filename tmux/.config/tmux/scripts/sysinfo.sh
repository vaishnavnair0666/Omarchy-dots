#!/usr/bin/env bash
cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4 "%"}')
mem=$(free -h | awk '/Mem:/ { print $3 "/" $2 }')
echo " $cpu |  $mem" >/tmp/tmux_sysinfo.txt
