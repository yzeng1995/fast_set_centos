#!/bin/bash
	




bash_dir="$( cd "$( dirname "$0"  )" && pwd  )"


# basic tools
if [ 1 == 1 ]; then
	yum -y install ssh
	yum -y install sshd
	yum -y install vim 
	yum -y install wget
	yum -y install ftp
	yum -y install unzip
	yum -y install lynx
	yum -y install expect
	yum -y install bash-completion
#	screen gun needed
	yum -y install ncurses-devel
#	centos8 update (need by installing some software)
	yum install epel-release
fi

# install obs
if [ 1 == 1 ]; then
    yum -y install libcurl libcurl-devel
    yum -y install nasm
    yum -y install yasm
fi

# python3 centos8 and pip3
if [ 1 == 1 ]; then
	yum -y install python36 python36-devel python36-debug
#	ranger
#	https://github.com/ranger/ranger
	pip3 install ranger-fm
fi






# network tools and other service 

if [ 1 == 0 ]; then
	yum -y install nmap
	yum -y install bind-utils # host, nslookup, dig
	yum -y install links
	yum -y install xinetd
	yum -y install telnet-server
	yum -y install telnet
	yum -y install transmission-cli transmission-common transmission-daemon
	yum -y install wireshark
fi

# service transmission-daemon start


# mail smtp service
if [ 1 == 0 ]; then
	yum -y install sendmail
	yum -y install mailx
	rpm -qc mailx
fi

# MCS Microcontroller
#set personal terminal syntax: root and all other users
if [ 1 == 1 ]; then
	cat $bash_dir/set_root_ps1 > /root/.bashrc
	cat $bash_dir/set_other_ps1 >> /etc/bashrc
fi


#set root can log ssh
if [ 1 == 0 ]; then
	cat $bash_dir/set_sshd > /etc/ssh/sshd_config
fi

#set vim 
if [ 1 == 1 ]; then
#	update to vim8
	cat $bash_dir/vim8_added_config.vim >> /etc/vimrc
#	cp $bash_dir/apdl.vim /usr/share/vim/vim74/syntax/
fi

#set power-up default
#systemctl set-default multi-user.target
#systemctl set-default graphical.target


#set mail smtp service
#cat $bash_dir/set_mail_smtp > /etc/mail.rc


#set period program running
#cat $bash_dir/set_crontab > /etc/crontab

#make folder for mount point in /mnt
if [ 1 == 1 ]; then
	for dir_tmp in 1 2 3 4 usb1 usb2 usb3 usb4 nfs1 nfs2 nfs3 nfs4
	do
		if [ ! -d "/mnt/$dir_tmp" ]; then
			mkdir /mnt/$dir_tmp
		fi
	done
fi


# 基础开发环境
# GCC系列
if [ 1 == 1 ]; then
	yum -y install gcc                     # C编译器
	yum -y install gcc-c++                 # C++编译器
	yum -y install gcc-gfortran            # Fortran编译器
fi
# 软件开发辅助工具
if [ 1 == 1 ]; then
	yum -y install make
	yum -y install gdb     # 代码调试器
	yum -y install cmake   # Cmake
	yum -y install git     # 版本控制
	yum -y install git-svn # git的svn插件
	yum -y install python-devel
	yum -y install java
fi


#setting network
#set inner network

if [ 1 == 0 ]; then
	nmcli con add \
	type ethernet \
	ifname p8p1\
	con-name office_inner \
	connection.autoconnect yes\
	ipv4.method manual\
	ipv4.address 192.168.100.1/24\
	ipv4.gateway 192.168.100.3\
	ipv4.dns 202.103.24.68\
	+ipv4.dns 202.103.0.117\
	ipv6.method auto
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

#set network environment trusted
if [ 1 == 0 ]; then
	firewall-cmd --set-default-zone=public
#	firewall-cmd --set-default-zone=trusted
fi

#copy software shutcuts to /usr/local/bin
if [ 1 == 1 ]; then
	cp -rf $bash_dir/usr_local_bin/*  /usr/local/bin
fi


#copy software shutcuts to /usr/local/sbin
if [ 1 == 1 ]; then
	cp -rf $bash_dir/usr_local_sbin/*  /usr/local/sbin
fi


# install software package using rpm or compile
if [ 1 == 0 ]; then
	cd /tmp
	# install nasm-2.14
	rpm -ivh http://software.yzeng1995.top/nasm-2.14.02.92-0.fc27.x86_64.rpm

	wget http://software.yzeng1995.top/last_x264.tar.bz2
	wget http://software.yzeng1995.top/ffmpeg-4.2.1.tar.gz
	# install x264
	tar -jxvf last_x264.tar.bz2
	cd x264-snapshot-20191001-2245
	./configure --enable-shared && make && make install
	
	# install ffmpeg
	cd ..
	tar -zxvf ffmpeg-4.2.1.tar.gz
	cd ffmpeg-4.2.1
	./configure && make && make install
fi

# install decoder, only enables with using GUI
# maybe add source from https://rpmfusion.org/ first
if [ 1 == 0 ]; then
	yum -y install vlc
	yum -y install gstreamer1-plugins-ugly
	yum -y install gstreamer1-plugins-base-devel
fi
