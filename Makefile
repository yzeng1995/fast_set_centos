main.sh:apdl.vim set_vim
main.sh:set_other_ps1 set_root_ps1
main.sh:set_sshd
main.sh:set_iptables.sh
	echo "1" > running_time
	echo ""  > message.log
	echo "this is error message"  > error.log
	echo "change 1 to 0 in running_time if you first use this"

configration:running_time  message.log error.log

install:
	bash -x main.sh
	cat error.log
	echo "please check the error.log"
clean:
	rm running_time message.log error.log
