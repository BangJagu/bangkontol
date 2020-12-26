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

read -p "Masukkan port Squid yang dipisahkan dengan 'spasi': " port

#squid
rm -f /root/squidport
squidport="$(cat /etc/squid3/squid.conf | grep -i http_port | awk '{print $2}')"
echo ""
echo -e "\e[34;1mPort Squid sebelum diedit:\e[0m"

cat > /root/squidport <<-END
$squidport
END

exec</root/squidport
while read line
do
	echo "Port $line"
	sed "/http_port $line/d" -i /etc/squid3/squid.conf
	#sed "s/Port $line//g" -i /etc/squid3/squid.conf
done
rm -f /root/squidport

echo ""

for i in ${port[@]}
do
	netstat -nlpt | grep -w "$i" > /dev/null
	if [ $? -eq 0 ]; then
		netstat -nlpt | grep -i squid | grep -w "$i" > /dev/null
		if [ $? -eq 0 ]; then
			sed -i "21 a\http_port $i" /etc/squid3/squid.conf
			echo -e "\e[032;1mPort $i sudah ditambahkan\e[0m"
		fi
		
		netstat -nlpt | grep -i sshd | grep -w "$i" > /dev/null
		if [ $? -eq 0 ]; then
			echo -e "\e[031;1mMaaf, Port $i sudah digunakan untuk OpenSSH\e[0m"
		fi
		
		netstat -nlpt | grep -i dropbear | grep -w "$i" > /dev/null
		if [ $? -eq 0 ]; then
			echo -e "\e[031;1mMaaf, Port $i sudah digunakan untuk Dropbear\e[0m"
		fi
		
		netstat -nlpt | grep -i openvpn | grep -w "$i" > /dev/null
		if [ $? -eq 0 ]; then
			echo -e "\e[031;1mMaaf, Port $i sudah digunakan untuk OpenVPN\e[0m"
		fi
	else
		sed -i "21 a\http_port $i" /etc/squid3/squid.conf
		echo -e "\e[032;1mPort $i sudah ditambahkan\e[0m"
	fi
done

echo ""
service squid3 restart

rm -f /root/squidport
squidport="$(cat /etc/squid3/squid.conf | grep -i http_port | awk '{print $2}')"
echo ""
echo -e "\e[34;1mPort Squid sesudah diedit:\e[0m"

cat > /root/squidport <<-END
$squidport
END

exec</root/squidport
while read line
do
	echo "Port $line"
done
rm -f /root/squidport

cd ~/
rm -f /root/IP
