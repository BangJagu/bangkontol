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

clear

echo "------------------------------ UNBANNED AKUN SSH -------------------------------"

if [[ $vps = "zvur" ]]; then
	echo "                     ALL SUPPORTED BY ZONA VPS UNTUK RAKYAT                     "
	echo "             https://www.facebook.com/groups/Zona.VPS.Untuk.Rakyat/             "
else
	echo "                           ALL SUPPORTED BY ANEKA VPS                           "
	echo "                     https://www.facebook.com/aneka.vps.us                      "
fi

	echo "            DEVELOPED BY YURI BHUANA (fb.com/youree82, 085815002021)            "
echo ""

cat /root/banneduser.txt
echo "--------------------------------------------------------------------------------"
echo ""

read -p "Isikan username: " username

egrep "^$username" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
	echo ""
	read -p "Apakah Anda benar-benar ingin mem-unbanned akun [$username] [y/n]: " -e -i y UNBANNED
	if [[ "$UNBANNED" = 'y' ]]; then
		sed -i "s/ User : $username//g" /root/banneduser.txt
		sed -i /^$/d /root/banneduser.txt
		passwd -u $username
		echo ""
		echo "Akun [$username] berhasil diunbanned!"
	else
		echo ""
		echo "Unbanned akun [$username] dibatalkan!"
	fi
else
	echo "Username [$username] belum terdaftar!"
	exit 1
fi

cd ~/
rm -f /root/IP