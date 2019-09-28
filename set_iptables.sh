#!/bin/bash

# 請先輸入您的相關參數，不要輸入錯誤了！
EXTIF="enp0s6"             # 這個是可以連上 Public IP 的網路介面
INIF="eth0"              # 內部 LAN 的連接介面；若無則寫成 INIF=""
INNET="192.168.100.0/24" # 若無內部網域介面，請填寫成 INNET=""
export EXTIF INIF INNET

#close default software firewalld
systemctl stop firewalld.service #停止firewall
systemctl disable firewalld.service #禁止firewall开机启动






# 第一部份，針對本機的防火牆設定！##########################################
# 1. 先設定好核心的網路功能：
echo "1" > /proc/sys/net/ipv4/tcp_syncookies
echo "1" > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
for i in /proc/sys/net/ipv4/conf/*/{rp_filter,log_martians}; do
	echo "1" > $i
done
for i in /proc/sys/net/ipv4/conf/*/{accept_source_route,accept_redirects,\
send_redirects}; do
	echo "0" > $i
done

# 2. 清除規則、設定預設政策及開放 lo 與相關的設定值
PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/sbin:/usr/local/bin; export PATH

service iptables start
iptables -F
iptables -X
iptables -Z
iptables -P INPUT   ACCEPT
iptables -P OUTPUT  ACCEPT
iptables -P FORWARD ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -m state --state NEW -m tcp -p tcp –dport 22 -j ACCEPT


# 4. 允許某些類型的 ICMP 封包進入
AICMP="0 3 3/4 4 8 11 12 14 16 18"
for tyicmp in $AICMP; do
	iptables -A INPUT -i $EXTIF -p icmp --icmp-type $tyicmp -j ACCEPT
done

# 5. 允許某些服務的進入，請依照你自己的環境開啟
iptables -A INPUT -p TCP -i $EXTIF --dport  21 --sport 1024:65534 -j ACCEPT # FTP
iptables -A INPUT -p TCP -i $EXTIF --dport  22 --sport 1024:65534 -j ACCEPT # SSH
iptables -A INPUT -p TCP -i $EXTIF --dport  23 --sport 1024:65534 -j ACCEPT # Telnet
iptables -A INPUT -p TCP -i $EXTIF --dport  25 --sport 1024:65534 -j ACCEPT # SMTP
iptables -A INPUT -p TCP -i $EXTIF --dport  111 --sport 1024:65534 -j ACCEPT # rpcbind
iptables -A INPUT -p TCP -i $EXTIF --dport  631 --sport 1024:65534 -j ACCEPT # ipp
iptables -A INPUT -p TCP -i $EXTIF --dport  6000 --sport 1024:65534 -j ACCEPT # x11
iptables -A INPUT -p TCP -i $EXTIF --dport  9091 --sport 1024:65534 -j ACCEPT # xmltec-xmlmail
# iptables -A INPUT -p UDP -i $EXTIF --dport  53 --sport 1024:65534 -j ACCEPT # DNS
# iptables -A INPUT -p TCP -i $EXTIF --dport  53 --sport 1024:65534 -j ACCEPT # DNS
# iptables -A INPUT -p TCP -i $EXTIF --dport  80 --sport 1024:65534 -j ACCEPT # WWW
# iptables -A INPUT -p TCP -i $EXTIF --dport 110 --sport 1024:65534 -j ACCEPT # POP3
iptables -A INPUT -p TCP -i $EXTIF --dport 443 --sport 1024:65534 -j ACCEPT # HTTPS

# 6. Add reliable network field
iptables -A INPUT -i $INIF -s $INNET -j ACCEPT


# 7. 最終將這些功能儲存下來吧！
service iptables save


