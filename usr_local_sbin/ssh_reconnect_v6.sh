#!/bin/bash

# usage:
# /etc/crontab
# */2 * * * * root /usr/local/sbin/ssh_reconnect_v6.sh 1>&2> /dev/null

# IP or domain name
oppositeIP="a.y.to"
oppositeTunnelIP="1.11.1.8"
tunnel="-w0:0"

echo "testing ping ..."
ping -c 3 $oppositeTunnelIP 2>/dev/null 1>/dev/null

if [ $? -eq 0  ];then
    echo "ssh is already connected and stable!"
else
	ps -ef |grep ssh|grep fCN|grep " $tunnel "|awk -F' ' '{print $2}'|xargs -I {} kill {}
    ssh -6 -fCN $tunnel $oppositeIP
    echo "`date` $oppositeIP, ssh tunnel is restarted and reconnected" >> /var/log/ssh_reconnect.log
fi

