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

if [ $1 ]; then
	port_dropbear=$1
	log=/var/log/auth.log
	loginsukses='Password auth succeeded'
	echo ' '
	echo ' '
	echo "               Dropbear Users Login Monitor                    "
	echo "---------------------------------------------------------------"
	echo "    Date-time    |  PID      |  User Name      |  From Host    "
	echo "---------------------------------------------------------------" 
	pids=`ps ax |grep dropbear |grep  " $port_dropbear" |awk -F" " '{print $1}'`
	for pid in $pids
	do
		pidlogs=`grep $pid $log |grep "$loginsukses" |awk -F" " '{print $3}'`
		i=0
		for pidend in $pidlogs
		do
			let i=i+1
		done
		
		if [ $pidend ]; then
			login=`grep $pid $log |grep "$pidend" |grep "$loginsukses"`
			PID=$pid
			user=`echo $login |awk -F" " '{print $10}' | sed -r "s/'/ /g"`
			waktu=`echo $login |awk -F" " '{print $2,$3}'`
			while [ ${#waktu} -lt 13 ]
			do
				waktu=$waktu" "
			done
			
			while [ ${#user} -lt 16 ]
			do
				user=$user" "
			done
			
			while [ ${#PID} -lt 8 ]
			do
				PID=$PID" "
			done

			fromip=`echo $login |awk -F" " '{print $12}' |awk -F":" '{print $1}'`
			echo "  $waktu|  $PID | $user|  $fromip "
		fi
	done
	
	echo "----------------------------------------------------------------"
	echo " Ingin tendang user? Ketik kill -9 (angka PID)"
	echo " Misal: kill -9 1234 [enter]"
	echo "----------------------------------------------------------------"
	
	if [[ $vps = "zvur" ]]; then
		echo " ALL SUPPORTED BY ZONA VPS UNTUK RAKYAT"
		echo " https://www.facebook.com/groups/Zona.VPS.Untuk.Rakyat/"
	else
		echo " ALL SUPPORTED BY ANEKA VPS"
		echo " https://www.facebook.com/aneka.vps.us"
	fi
	
	echo "    DEVELOPED BY YURI BHUANA (fb.com/youree82, 085815002021)    "
	echo "----------------------------------------------------------------"
	echo ""
else
	echo "  Gunakan perintah ./dropmon [port]"
	echo "  Contoh : ./dropmon 443"
	echo ""
fi

exit 0

cd ~/
rm -f /root/IP
