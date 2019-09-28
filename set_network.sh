#setting network
#set inner network

if [ 1 == 1 ]; then
	nmcli con add \
	type ethernet \
	ifname eth1\
	con-name \
	office_inner \
	connection.autoconnect yes\
	ifname eth1\
	ipv4.method manual\
	ipv4.address 192.168.100.2/24
fi


#set outer network


if [ 1 == 0 ]; then
	nmcli con add \
	type ethernet \
	ifname eth0\
	con-name \
	office_outer \
	connection.autoconnect yes\
	ifname eth1\
	ipv4.method manual\
	ipv4.address 192.168.100.3/24
fi
