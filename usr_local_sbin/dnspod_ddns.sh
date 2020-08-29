#!/bin/bash

# This program establish ddns service
# to modify the public ip address of dns server.
# The dns server is dnspod.
# /etc/crontab
# */10 * * * * root /usr/local/sbin/dnspod_ddns.sh 1>&2> /dev/null

TOKEN="177,4e"
DOMAIN="y5.t"
SUB_DOMAIN="test"

# TOKEN=`cat dnspod_ddns.conf|grep TOKEN|awk -F'=' '{print $2}'`
# DOMAIN=`cat dnspod_ddns.conf|grep -e '^DOMAIN'|awk -F'=' '{print $2}'`
# SUB_DOMAIN=`cat dnspod_ddns.conf|grep SUB_DOMAIN|awk -F'=' '{print $2}'`


DATA="login_token=$TOKEN&format=json&domain=$DOMAIN&sub_domain=$SUB_DOMAIN&record_type=A&offset=0&length=3"
JOSN_RECORDS=`curl -s -X POST https://dnsapi.cn/Record.List -d $DATA`

RECORD_ID=`echo $JOSN_RECORDS|sed '/id/ s/.*id":"\(.*\)","ttl.*/\1/'`
LINE_ID=`echo $JOSN_RECORDS|sed '/line_id/ s/.*line_id":"\(.*\)","type.*/\1/'`
#=================get record ip
IP_RESOLVED=`echo $JOSN_RECORDS|sed '/value/ s/.*value":"\(.*\)","enabled.*/\1/'`

#================get real ip
#REAL_IP=`cat</dev/tcp/ns1.dnspod.net/6666`
REAL_IP=`curl -s  myip.ipip.net|awk -F' |：' '{print $3}'`

#REAL_IP="2.2.3.2"
if [ $REAL_IP != $IP_RESOLVED ]; then
	#================modify record
	DATA="login_token=$TOKEN&format=json&domain=$DOMAIN&record_id=$RECORD_ID&sub_domain=$SUB_DOMAIN&value=$REAL_IP&record_type=A&record_line_id=$LINE_ID"
	# echo $DATA
	JSON_RESULT=`curl -s -X POST https://dnsapi.cn/Record.Modify -d $DATA`
	echo $JSON_RESULT >> /var/log/dnspod_ddns.log
	IP_RESOLVED=$REAL_IP
fi

