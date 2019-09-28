#!/bin/bash
#program:
#	send message "ifconfig" to a known host.
#history:
#	2017-04-08
TIME_SPACE=3
T=0
T_TIMEOUT=10
HOST_IP="2001:cc0:2020:4008:842b:c1b6:6356:ec1"
GREEN_STR="\033[32m\033[1m"
RES_STR="\E[0m"
SUCCESS=0
while [ 1 == 1 ]
do
	T=`expr $T + 1`
	STR="At `date`, $T request sent"
	echo  $STR 
	echo -e "$GREEN_STR\n" "$STR\n" "$RES_STR\n" "`ifconfig`" > net_log

	echo -e "$GREEN_STR\n" "$STR\n" "$RES_STR\n" "`ifconfig`" |\
		nc $HOST_IP 1234

	if [ $? == 0 ]; then
		SUCCESS=1
	elif [ $SUCCESS == 1 ]; then
		break
	fi

	if (($T >= $T_TIMEOUT)); then
		break
	fi

	sleep $TIME_SPACE
done
