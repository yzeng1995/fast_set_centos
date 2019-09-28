#!/bin/bash
# download black ssh ip from internet
# and add the ip to /var/log/drop_ssh_ip_public
# Then add the ip to firewall
# run this script every day

# IsRun=`ps -ef |grep /usr/local/sbin/drop_ssh_hosts_ |grep -v grep|wc -l`
# if [ $IsRun -gt 1 ]
# then 
# 	echo $IsRun
# 	exit 1
# fi 

# public file is added from internet (input file of this shell)
# note!! if the public file ip load in firewall, the ip will not be 
# removed until firewall restarts
[ -f /var/log/drop_ssh_ip_public ] || touch /var/log/drop_ssh_ip_public


# curl http://antivirus.neu.edu.cn/ssh/lists/neu_sshbl_hosts.deny \
#	2>/dev/null |awk '/sshd/{print $2}' > /var/log/drop_ssh_ip_public

# 2.deal with the ip in known bad ip file
# the ip exist in black drop file /var/log/drop_ssh_ip
DropIP=`firewall-cmd --zone=drop --list-sources`
for IP in `cat /var/log/drop_ssh_ip_public|uniq`
do
	ipExists=`echo $DropIP|grep $IP|wc -l`
	if [ $ipExists -lt 1 ]
	then 
		firewall-cmd --zone=drop --add-source=$IP
	fi 
done
