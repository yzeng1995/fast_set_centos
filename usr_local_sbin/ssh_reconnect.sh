#!/bin/bash

# IP or domain name
oppositeIP="a.y.to"
oppositeTunnelIP="1.11.1.8"

echo "testing ping ..."
ping -c 3 $oppositeTunnelIP 2>/dev/null 1>/dev/null

if [ $? -eq 0  ];then
    echo "ssh is already connected and stable!"
else
    ssh  -fCN -w0:0 $oppositeIP
    echo "`date` ali.yzeng1995.top, ssh tunnel is ready to restart and reconnect" >> /var/log/ssh_reconnect.log
fi
