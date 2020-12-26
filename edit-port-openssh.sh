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

read -p "Masukkan port OpenSSH yang dipisahkan dengan 'spasi': " port

#openssh
rm -f /root/opensshport
opensshport="$(netstat -nlpt | grep -i sshd | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
echo ""
echo -e "\e[34;1mPort OpenSSH sebelum diedit:\e[0m"

cat > /root/opensshport <<-END
$opensshport
END

exec</root/opensshport
while read line
do
	echo "Port $line"
	sed "/Port $line/d" -i /etc/ssh/sshd_config
	#sed "s/Port $line//g" -i /etc/ssh/sshd_config
done
rm -f /root/opensshport

echo ""

for i in ${port[@]}
do
	netstat -nlpt | grep -w "$i" > /dev/null
	if [ $? -eq 0 ]; then
		netstat -nlpt | grep -i sshd | grep -w "$i" > /dev/null
		if [ $? -eq 0 ]; then
			sed -i "4 a\Port $i" /etc/ssh/sshd_config
			echo -e "\e[032;1mPort $i sudah ditambahkan\e[0m"
		fi
		
		netstat -nlpt | grep -i dropbear | grep -w "$i" > /dev/null
		if [ $? -eq 0 ]; then
			echo -e "\e[031;1mMaaf, Port $i sudah digunakan untuk Dropbear\e[0m"
		fi
		
		netstat -nlpt | grep -i squid | grep -w "$i" > /dev/null
		if [ $? -eq 0 ]; then
			echo -e "\e[031;1mMaaf, Port $i sudah digunakan untuk Squid\e[0m"
		fi
		
		netstat -nlpt | grep -i openvpn | grep -w "$i" > /dev/null
		if [ $? -eq 0 ]; then
			echo -e "\e[031;1mMaaf, Port $i sudah digunakan untuk OpenVPN\e[0m"
		fi
	else
		sed -i "4 a\Port $i" /etc/ssh/sshd_config
		echo -e "\e[032;1mPort $i sudah ditambahkan\e[0m"
	fi
done

echo ""
service ssh restart

rm -f /root/opensshport
opensshport="$(netstat -nlpt | grep -i sshd | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
echo ""
echo -e "\e[34;1mPort OpenSSH sesudah diedit:\e[0m"

cat > /root/opensshport <<-END
$opensshport
END

exec</root/opensshport
while read line
do
	echo "Port $line"
done
rm -f /root/opensshport

cd ~/
rm -f /root/IP
