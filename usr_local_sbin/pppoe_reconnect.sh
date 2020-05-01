#!/bin/bash

connection="pppoe-eth"
# keep=[0,1]=[normal,enforce alive]
# if at normal model, the program is not effect when connection is already down.
# if at enforce model, the program enforce connection up.
keep="0"

isConnectionUp=`nmcli|grep "connected to"|awk -F' ' '{print $4}'|grep -e "^$connection$"|wc -l`

if [ $isConnectionUp -eq 0  ];then
	if [ $keep -eq 0  ];then
		echo "Connection is down, exit!"
		exit
	elif [ $keep -eq 1  ];then
		echo "Connection is down, enforce up!"
		nmcli con up $connection
	else
		echo "the option 'keep' is invalid!"
	fi
else
	echo "Connection is up, then get gateway!"
	gateway=`nmcli con show $connection |grep IP4.GATEWAY | awk -F' ' '{print $2}'`
	echo "gateway is $gateway"
fi

echo "testing ping ..."
ping -c 3 $gateway 2>/dev/null 1>/dev/null

if [ $? -eq 0  ];then
	echo "ppp is already connected and stable!"
else
	echo "ppp is ready to restart and reconnect"
	nmcli con down $connection
	sleep 5
	nmcli con up $connection
fi
