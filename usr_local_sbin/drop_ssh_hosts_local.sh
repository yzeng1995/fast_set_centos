#!/bin/bash
#Drophosts SHELL SCRIPT 
# if the number of password failed using ssh is great that 5
# then drop!

# IsRun=`ps -ef |grep /usr/local/sbin/drop_ssh_hosts_ |grep -v grep|wc -l`
# if [ $IsRun -gt 0 ]
# then 
# 	exit 1
# fi 


# local file is generate by /var/log/secure (output file of this shell)
[ -f /var/log/drop_ssh_ip_local ] || touch /var/log/drop_ssh_ip_local

# node!!
# id ip in IP_ssh_drop, the ip must also in IP_ssh_drop_permanent

# the ip exist in firewall drop list
# DropIP=`firewall-cmd --zone=drop --list-sources`
# the ip exist in ipset=ssh_drop
# IP_ssh_drop=`firewall-cmd --info-ipset=ssh_drop |grep entries|awk 'END{for(i=1;i<NF;i++){print $(i+1);}}'`
# the ip exist in ipset=ssh_drop --permanent
IP_ssh_drop_permanent=`awk -F"[<>]" '/entry/{print $3}' /etc/firewalld/ipsets/ssh_drop.xml`


# 1.deal with the ip in /var/log/secure
for IP in `awk '/Failed/{ip[$(NF-3)]++;}END{for (i in ip){if (ip[i]>5){print i}}}' /var/log/secure`
do
	# if ip is not in IP_ssh_drop_permanent
	# then add new ip
	ipExists=`echo $IP_ssh_drop_permanent|grep $IP|wc -l`
	if [ $ipExists -lt 1 ]
	then 
		firewall-cmd --zone=drop --add-source=$IP && echo $IP >> /var/log/drop_ssh_ip_local
		firewall-cmd --permanent --ipset=ssh_drop --add-entry=$IP
	fi 
done



