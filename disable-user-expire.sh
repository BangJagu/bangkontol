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

echo "" > /root/infouser.txt
echo "" > /root/expireduser.txt
echo "" > /root/activeuser.txt
echo "" > /root/alluser.txt

cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > /tmp/expirelist.txt
totalaccounts=`cat /tmp/expirelist.txt | wc -l`
for((i=1; i<=$totalaccounts; i++ ))
do
	tuserval=`head -n $i /tmp/expirelist.txt | tail -n 1`
	username=`echo $tuserval | cut -f1 -d:`
	userexp=`echo $tuserval | cut -f2 -d:`
	userexpireinseconds=$(( $userexp * 86400 ))
	tglexp=`date -d @$userexpireinseconds`
	tgl=`echo $tglexp |awk -F" " '{print $3}'`
	while [ ${#tgl} -lt 2 ]
	do
		tgl="0"$tgl
	done
	while [ ${#username} -lt 15 ]
	do
		username=$username" "
	done
	bulantahun=`echo $tglexp |awk -F" " '{print $2,$6}'`
	echo " User : $username Expire tanggal : $tgl $bulantahun" >> /root/alluser.txt
	todaystime=`date +%s`
	if [ $userexpireinseconds -ge $todaystime ]; then
		echo " User : $username Expire tanggal : $tgl $bulantahun" >> /root/activeuser.txt
		timeto7days=$(( $todaystime + 604800 ))
		if [ $userexpireinseconds -le $timeto7days ]; then
			echo " User : $username Expire tanggal : $tgl $bulantahun" >> /root/infouser.txt
		fi
	else
		echo " User : $username Expire tanggal : $tgl $bulantahun" >> /root/expireduser.txt
		passwd -l $username
	fi
done

cd ~/
rm -f /root/IP