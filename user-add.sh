#!/bin/bash

if [[ $USER != 'root' ]]; then
	echo "Maaf, Anda harus menjalankan ini sebagai root"
	exit
fi

MYIP=$(wget -qO- ipv4.icanhazip.com)

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

echo "--------------------------- MEMBUAT AKAUN SSH/OPENVPN ---------------------------"

if [[ $vps = "zvur" ]]; then
	echo "                     ALL SUPPORTED BY ZONA VPS UNTUK RAKYAT                     "
	echo "             https://www.facebook.com/groups/Zona.VPS.Untuk.Rakyat/             "
else
	echo "                           ALL SUPPORTED BY ANEKA VPS                           "
	echo "                     https://www.facebook.com/aneka.vps.us                      "
fi

	echo "            DEVELOPED BY YURI BHUANA (fb.com/youree82, 085815002021)            "
echo ""

read -p "Isikan username: " username

egrep "^$username" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
	echo "Username [$username] sudah ada!"
	exit 1
else
	read -p "Isikan password akaun [$username]: " password
	read -p "Berapa hari akaun [$username] aktif: " AKTIF

	today="$(date +"%Y-%m-%d")"
	expire=$(date -d "$AKTIF days" +"%Y-%m-%d")
	useradd -M -N -s /bin/false -e $expire $username
	echo $username:$password | chpasswd

	echo ""
	echo "-----------------------------------"
	echo "Data Login:"
	echo "-----------------------------------"
	echo "Host/IP: $MYIP"
	echo "Dropbear Port: 443, 110, 109"
	echo "OpenSSH Port: 22, 143"
	echo "Squid Proxy: 80, 8080, 3128"
	echo "OpenVPN Config: http://$MYIP:81/client.ovpn"
	echo "Username: $username"
	echo "Password: $password"
	echo "Valid s/d: $(date -d "$AKTIF days" +"%d-%m-%Y")"
	echo "-----------------------------------"
fi

cd ~/
rm -f /root/IP
