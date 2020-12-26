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

read -p "Masukkan Port Dropbear yang dipisahkan dengan 'spasi': " port

#Dropbear
rm -f /root/dropbearport
dropbearport="$(netstat -nlpt | grep -i dropbear | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
echo ""
echo -e "\e[34;1mPort Dropbear sebelum diedit:\e[0m"

cat > /root/dropbearport <<-END
$dropbearport
END

exec</root/dropbearport
while read line
do
	echo "Port $line"
	#sed "s/Port $line//g" -i /etc/default/dropbear
done
rm -f /root/dropbearport

sed '/DROPBEAR_PORT/d' -i /etc/default/dropbear
sed '/DROPBEAR_EXTRA_ARGS/d' -i /etc/default/dropbear

echo ""

for i in ${port[@]}
do
	netstat -nlpt | grep -w "$i" > /dev/null
	if [ $? -eq 0 ]; then
		netstat -nlpt | grep -i dropbear | grep -w "$i" > /dev/null
		if [ $? -eq 0 ]; then
			echo -n "-p $i " >> /root/dropbearport
			echo -e "\e[032;1mPort $i sudah ditambahkan\e[0m"
		fi
		
		netstat -nlpt | grep -i sshd | grep -w "$i" > /dev/null
		if [ $? -eq 0 ]; then
			echo -e "\e[031;1mMaaf, Port $i sudah digunakan untuk OpenSSH\e[0m"
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
		echo -n "-p $i " >> /root/dropbearport
		echo -e "\e[032;1mPort $i sudah ditambahkan\e[0m"
	fi
done

DROPBEAR_PORT="$(cat /root/dropbearport | awk '{print $2}')"
sed -i "5 a\DROPBEAR_PORT=$DROPBEAR_PORT" /etc/default/dropbear

while read line
do
	echo "Port $line"
done < "/root/dropbearport"
sed -i "8 a\DROPBEAR_EXTRA_ARGS=\"$line\"" /etc/default/dropbear

echo ""
service dropbear restart

dropbearport="$(netstat -nlpt | grep -i dropbear | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
echo ""
echo -e "\e[34;1mPort Dropbear sesudah diedit:\e[0m"

cat > /root/dropbearport <<-END
$dropbearport
END

exec</root/dropbearport
while read line
do
	echo "Port $line"
done
rm -f /root/dropbearport

cd ~/
rm -f /root/IP
