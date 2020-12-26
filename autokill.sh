#!/bin/bash

if [[ $USER != "root" ]]; then
	echo "Maaf, Anda harus menjalankan ini sebagai root"
	exit
fi

# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";
ether=`ifconfig | cut -c 1-8 | sort | uniq -u | grep venet0 | grep -v venet0:`
if [[ $ether = "" ]]; then
        ether=eth0
fi

#vps="zvur";
vps="aneka";

if [[ $vps = "zvur" ]]; then
	source="http://scripts.gapaiasa.com"
else
	source="https://raw.githubusercontent.com/r38865/VPS/master/Update"
fi

# go to root
cd

# check registered ip
wget -q -O IP $source/IP.txt
if ! grep -w -q $MYIP IP; then
	echo "Maaf, hanya IP yang terdaftar yang bisa menggunakan script ini!"
	if [[ $vps = "zvur" ]]; then
		echo "Hubungi: Yuri Bhuana (fb.com/youree82 atau 0858 1500 2021)"
	else
		echo "Hubungi: Turut Dwi Hariyanto (fb.com/turut.dwi.hariyanto atau 085735313729)"
	fi
	rm -f /root/IP
	exit
fi

x=$1

case $x in
0)
	#dropbear
	rm -f /root/dropbearport
	dropbearport="$(netstat -nlpt | grep -i dropbear | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
	echo "Dropbear Port:"

	cat > /root/dropbearport <<-END
	$dropbearport
	END

	exec</root/dropbearport
	while read line
	do
		sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 2 -j REJECT//g" -i /etc/rc.local
		sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 3 -j REJECT//g" -i /etc/rc.local
		sed "s/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 2 -j REJECT//g" -i /etc/rc.local
		sed "s/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 3 -j REJECT//g" -i /etc/rc.local
		echo "$line ==> Limit $x login"
		#grep "iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT" /etc/rc.local > /dev/null
		#if [[ $? != 0 ]];then
			#sed -i "1 a\iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT" /etc/rc.local
		#fi
		#sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT/g" -i /etc/rc.local
	done
	
	echo ""
	rm -f /root/dropbearport
	
	#openssh
	rm -f /root/opensshport
	opensshport="$(netstat -nlpt | grep -i sshd | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
	echo "OpenSSH Port:"
	
	cat > /root/opensshport <<-END
	$opensshport
	END
	
	exec</root/opensshport
	while read line
	do
		sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 2 -j REJECT//g" -i /etc/rc.local
		sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 3 -j REJECT//g" -i /etc/rc.local
		sed "s/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 2 -j REJECT//g" -i /etc/rc.local
		sed "s/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 3 -j REJECT//g" -i /etc/rc.local
		echo "$line ==> Limit $x login"
		#grep "iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT" /etc/rc.local > /dev/null
		#if [[ $? != 0 ]];then
			#sed -i "1 a\iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT" /etc/rc.local
		#fi
		#sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT/g" -i /etc/rc.local
	done
	
	echo ""
	rm -f /root/opensshport
	
	sed '/^$/d' /etc/rc.local > /tmp/rc.local
	cat /tmp/rc.local > /etc/rc.local
	/etc/rc.local start
;;
2)
	#dropbear
	rm -f /root/dropbearport
	dropbearport="$(netstat -nlpt | grep -i dropbear | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
	echo "Dropbear Port:"

	cat > /root/dropbearport <<-END
	$dropbearport
	END

	exec</root/dropbearport
	while read line
	do
		sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 2 -j REJECT//g" -i /etc/rc.local
		sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 3 -j REJECT//g" -i /etc/rc.local
		sed "s/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 2 -j REJECT//g" -i /etc/rc.local
		sed "s/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 3 -j REJECT//g" -i /etc/rc.local
		echo "$line ==> Limit $x login"
		grep "iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT" /etc/rc.local > /dev/null
		if [[ $? != 0 ]];then
			sed -i "1 a\iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT" /etc/rc.local
		fi
		#sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT/g" -i /etc/rc.local
	done
	
	echo ""
	rm -f /root/dropbearport
	
	#openssh
	rm -f /root/opensshport
	opensshport="$(netstat -nlpt | grep -i sshd | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
	echo "OpenSSH Port:"
	
	cat > /root/opensshport <<-END
	$opensshport
	END
	
	exec</root/opensshport
	while read line
	do
		sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 2 -j REJECT//g" -i /etc/rc.local
		sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 3 -j REJECT//g" -i /etc/rc.local
		sed "s/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 2 -j REJECT//g" -i /etc/rc.local
		sed "s/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 3 -j REJECT//g" -i /etc/rc.local
		echo "$line ==> Limit $x login"
		grep "iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT" /etc/rc.local > /dev/null
		if [[ $? != 0 ]];then
			sed -i "1 a\iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT" /etc/rc.local
		fi
		#sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT/g" -i /etc/rc.local
	done
	
	echo ""
	rm -f /root/opensshport
	
	sed '/^$/d' /etc/rc.local > /tmp/rc.local
	cat /tmp/rc.local > /etc/rc.local
	/etc/rc.local start
;;
3)
	#dropbear
	rm -f /root/dropbearport
	dropbearport="$(netstat -nlpt | grep -i dropbear | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
	echo "Dropbear Port:"

	cat > /root/dropbearport <<-END
	$dropbearport
	END

	exec</root/dropbearport
	while read line
	do
		sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 2 -j REJECT//g" -i /etc/rc.local
		sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 3 -j REJECT//g" -i /etc/rc.local
		sed "s/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 2 -j REJECT//g" -i /etc/rc.local
		sed "s/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 3 -j REJECT//g" -i /etc/rc.local
		echo "$line ==> Limit $x login"
		grep "iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT" /etc/rc.local > /dev/null
		if [[ $? != 0 ]];then
			sed -i "1 a\iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT" /etc/rc.local
		fi
		#sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT/g" -i /etc/rc.local
	done
	
	echo ""
	rm -f /root/dropbearport
	
	#openssh
	rm -f /root/opensshport
	opensshport="$(netstat -nlpt | grep -i sshd | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
	echo "OpenSSH Port:"
	
	cat > /root/opensshport <<-END
	$opensshport
	END
	
	exec</root/opensshport
	while read line
	do
		sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 2 -j REJECT//g" -i /etc/rc.local
		sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 3 -j REJECT//g" -i /etc/rc.local
		sed "s/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 2 -j REJECT//g" -i /etc/rc.local
		sed "s/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 3 -j REJECT//g" -i /etc/rc.local
		echo "$line ==> Limit $x login"
		grep "iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT" /etc/rc.local > /dev/null
		if [[ $? != 0 ]];then
			sed -i "1 a\iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT" /etc/rc.local
		fi
		#sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT/g" -i /etc/rc.local
	done
	
	echo ""
	rm -f /root/opensshport
	
	sed '/^$/d' /etc/rc.local > /tmp/rc.local
	cat /tmp/rc.local > /etc/rc.local
	/etc/rc.local start
;;
*)
	echo "Gunakan perintah autokill 2, untuk limit 2 login saja"
	echo "atau autokill 3, untuk melimit max 3 login"
	echo "atau autokill 0, untuk no limit login"
	echo ""
;;
esac

cd ~/
rm -f /root/IP
