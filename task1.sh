#!/bin/bash
wget -O ~/HAProxylog.txt https://gist.githubusercontent.com/eugenekainara/cac28ed4f18de2e6dd59c2d5f8dc692e/raw/cea311dee0a0e3ddcbb710a595524bd6a6879f57/HAProxy%2520example%2520logs
file=~/HAProxylog.txt
echo 'Count/Code' && cat $file | awk '{print $6}' | sort | uniq -c | sort -rn
echo ""
echo 'All client IP`s:' && cat $file | awk -F ":" ' { print $1 } ' | sort | uniq
echo ""
echo 'TOP 10 Requested URL`s:' && cat $file | awk '$13 ~ "GET" { print $14 }' | sort | uniq -c | sort -nr | head
echo ""
echo 'Total number of requests:' && cat $file | awk '{print $6}' | wc -l
rm ~/HAProxylog.txt
echo ""
