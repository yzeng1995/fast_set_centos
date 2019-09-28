#!/bin/bash

# 0. 设定你的参数值                                         
EXIF='enp0s6'           # 这个是对外的网卡接口, 可能是'ppp0'等
INNET='192.168.100.0/24'       # 这个是对内的网段            

# 底下如无需要, 请不要改动了!               
# 1. 启动routing等                          
echo 1 > /proc/sys/net/ipv4/ip_forward      
iptables -F -t nat                    
iptables -X -t nat                    
iptables -Z -t nat                    
iptables -t nat -P PREROUTING   ACCEPT
iptables -t nat -P POSTROUTING  ACCEPT
iptables -t nat -P OUTPUT       ACCEPT

# 2. 载入模组                               
modprobe ip_tables 2> /dev/null       
modprobe ip_nat_ftp 2> /dev/null      
modprobe ip_nat_irc 2> /dev/null      
modprobe ip_conntrack 2> /dev/null    
modprobe ip_conntrack_ftp 2> /dev/null
modprobe ip_conntrack_irc 2> /dev/null

# 3. 启动ip伪装                                           
iptables -t nat -A POSTROUTING -o $EXIF -s $INNET -j MASQUERADE 

service iptables save


