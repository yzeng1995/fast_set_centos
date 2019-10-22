#!/bin/bash

# This program establish ddns service
# to modify the public ip address of dns server.
# The dns server is dnspod.

TOKEN="12,4c"
DOMAIN="yz.t"
SUB_DOMAIN="tt"

# TOKEN=`cat /etc/dnspod_ddns.conf|grep TOKEN|awk -F'=' '{print $2}'`
# DOMAIN=`cat /etc/dnspod_ddns.conf|grep -e '^DOMAIN'|awk -F'=' '{print $2}'`
# SUB_DOMAIN=`cat /etc/dnspod_ddns.conf|grep SUB_DOMAIN|awk -F'=' '{print $2}'`


DATA="login_token=$TOKEN&format=json&domain=$DOMAIN&sub_domain=$SUB_DOMAIN&record_type=A&offset=0&length=3"
JOSN_RECORDS=`curl -s -X POST https://dnsapi.cn/Record.List -d $DATA|jq '.records[0]'`

RECORD_ID=`echo $JOSN_RECORDS|jq '.id'|sed 's/\"//g'`
LINE_ID=`echo $JOSN_RECORDS|jq '.line_id'|sed 's/\"//g'`
#=================get record ip
IP_RESOLVED=`echo $JOSN_RECORDS|jq '.value'|sed 's/\"//g'`

#================get real ip
REAL_IP=`cat</dev/tcp/ns1.dnspod.net/6666`
if [ $REAL_IP != $IP_RESOLVED ]; then
	#================modify record
	DATA="login_token=$TOKEN&format=json&domain=$DOMAIN&record_id=$RECORD_ID&sub_domain=$SUB_DOMAIN&value=$REAL_IP&record_type=A&record_line_id=$LINE_ID"
	# echo $DATA
	JSON_RESULT=`curl -s -X POST https://dnsapi.cn/Record.Modify -d $DATA`
	echo $JSON_RESULT|jq '.status.created_at + " " + .status.message' >> /var/log/dnspod_ddns.log
	IP_RESOLVED=$REAL_IP
fi

