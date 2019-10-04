# fast_set_centos

Author:Yan Zeng

E-mail:zengyan16@mails.ucas.edu.cn

License:MIT

This is a set of system scripts, which is used to
ensure server security in the public internet.

The scripts can run on Centos7 system.

#Program:
	this program is a fast setting for new centos 7 system.
	it should be root to use this program!
	include function:
	1.open ssh service
	2.set personal terminal syntax: root and all user
	3.etc.
#History:
##	Yan Zeng 20170210 version 1.0
##	Yan Zeng 20171216 version 1.2
		1.add network setting
		2.add software shutcuts
##	Yan Zeng 20190928 version 1.3
		1.Add support to centos-8, this script will nolonger support centos7.
		2.Add Network Security System Scripts
		3.Add vim 8 global configue file 'defaults.vim'

# Functions of configures

## install abaqus 2017
        1.change the hostname in license before copy the license.
        2.input the new hostname
        3.if cae running wrong due to teaching license, then delete the last row of
        /opt/DassaultSystemes/SimulationServices/V6R2017x/linux_a64/SMA/site/custom_v6.env

## install ansys18.0
        1.input the host name as real hostname 

# Functions of Network Security System Scripts

## deny_ssh_hosts.sh

This script analysis /var/log/secure file to find the
ip address whose the number of failed times is greater
than 3.

Then the script add the ipaddress to /etc/hosts.deny
to reject ssh connection.

## drop_ssh_hosts_local.sh
This script find the ip do the following things

1.Add the ip to firewall drop zone.<br>
2.Add the ip to firewall ipset ssh_drop --permanent<br>
3.This script will NOT add the ip which is already in ipset ssh_drop.<br>
4.You should run the following command to add the ipset into firewall.<br>
firewall-cmd --permanent --zone=public --add-rich-rule="rule family=ipv4 source ipset=ssh_drop drop"
<br> and add the following line in /etc/crontab to run every minite<br>
  */1 * * * * root /usr/local/sbin/drop_ssh_hosts_local.sh 1>&2> /dev/null

## drop_ssh_hosts_public.sh
If you have a ip list from internet and you want to
drop them, then you can save the ip address in a file
at /var/log/drop_ssh_hosts_public.

Run this script you can add the ip address in
the drop zone in firewall.

This script will NOT add the ip which is already in firewall drop zone.


