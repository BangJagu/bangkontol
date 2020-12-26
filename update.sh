#!/bin/bash

grep "iptables -A INPUT -m string --algo kmp --string sonyentertainmentnetwork -j REJECT" /etc/rc.local > /dev/null
if [[ $? != 0 ]];then
	sed -i "1 a\iptables -A INPUT -m string --algo kmp --string sonyentertainmentnetwork -j REJECT" /etc/rc.local
fi

grep "iptables -A FORWARD -m string --algo kmp --string sonyentertainmentnetwork -j REJECT" /etc/rc.local > /dev/null
if [[ $? != 0 ]];then
	sed -i "1 a\iptables -A FORWARD -m string --algo kmp --string sonyentertainmentnetwork -j REJECT" /etc/rc.local
fi

grep "iptables -A INPUT -m string --algo kmp --string playstation -j REJECT" /etc/rc.local > /dev/null
if [[ $? != 0 ]];then
	sed -i "1 a\iptables -A INPUT -m string --algo kmp --string playstation -j REJECT" /etc/rc.local
fi

grep "iptables -A FORWARD -m string --algo kmp --string playstation -j REJECT" /etc/rc.local > /dev/null
if [[ $? != 0 ]];then
	sed -i "1 a\iptables -A FORWARD -m string --algo kmp --string playstation -j REJECT" /etc/rc.local
fi

wget -O /usr/bin/autokill https://raw.githubusercontent.com/r38865/VPS/master/Update/autokill.sh
wget -O /usr/bin/banned-user https://raw.githubusercontent.com/r38865/VPS/master/Update/banned-user.sh
wget -O /usr/bin/banner https://raw.githubusercontent.com/r38865/VPS/master/Update/banner.sh
wget -O /usr/bin/delete-user-expire https://raw.githubusercontent.com/r38865/VPS/master/Update/delete-user-expire.sh
wget -O /usr/bin/disable-user-expire https://raw.githubusercontent.com/r38865/VPS/master/Update/disable-user-expire.sh
wget -O /usr/bin/dropmon https://raw.githubusercontent.com/r38865/VPS/master/Update/dropmon.sh
wget -O /usr/bin/menu https://raw.githubusercontent.com/r38865/VPS/master/Update/menu.sh
wget -O /usr/bin/unbanned-user https://raw.githubusercontent.com/r38865/VPS/master/Update/unbanned-user.sh
wget -O /usr/bin/user-active-list https://raw.githubusercontent.com/r38865/VPS/master/Update/user-active-list.sh
wget -O /usr/bin/user-add https://raw.githubusercontent.com/r38865/VPS/master/Update/user-add.sh
wget -O /usr/bin/user-add-pptp https://raw.githubusercontent.com/r38865/VPS/master/Update/user-add-pptp.sh
wget -O /usr/bin/user-del https://raw.githubusercontent.com/r38865/VPS/master/Update/user-del.sh
wget -O /usr/bin/user-expire-list https://raw.githubusercontent.com/r38865/VPS/master/Update/user-expire-list.sh
wget -O /usr/bin/user-gen https://raw.githubusercontent.com/r38865/VPS/master/Update/user-gen.sh
wget -O /usr/bin/user-limit https://raw.githubusercontent.com/r38865/VPS/master/Update/user-limit.sh
wget -O /usr/bin/user-list https://raw.githubusercontent.com/r38865/VPS/master/Update/user-list.sh
wget -O /usr/bin/user-login https://raw.githubusercontent.com/r38865/VPS/master/Update/user-login.sh
wget -O /usr/bin/user-pass https://raw.githubusercontent.com/r38865/VPS/master/Update/user-pass.sh
wget -O /usr/bin/user-renew https://raw.githubusercontent.com/r38865/VPS/master/Update/user-renew.sh
wget -O /usr/bin/edit-port https://raw.githubusercontent.com/r38865/VPS/master/Update/edit-port.sh
wget -O /usr/bin/edit-port-dropbear https://raw.githubusercontent.com/r38865/VPS/master/Update/edit-port-dropbear.sh
wget -O /usr/bin/edit-port-openssh https://raw.githubusercontent.com/r38865/VPS/master/Update/edit-port-openssh.sh
wget -O /usr/bin/edit-port-squid https://raw.githubusercontent.com/r38865/VPS/master/Update/edit-port-squid.sh
wget -O /usr/bin/edit-port-openvpn https://raw.githubusercontent.com/r38865/VPS/master/Update/edit-port-openvpn.sh
wget -O /usr/bin/benchmark https://raw.githubusercontent.com/r38865/VPS/master/Update/benchmark.sh
wget -O /usr/bin/root-pass https://raw.githubusercontent.com/r38865/VPS/master/Update/root-pass.sh
wget -O /usr/bin/update https://raw.githubusercontent.com/r38865/VPS/master/Update/update.sh

chmod +x /usr/bin/autokill
chmod +x /usr/bin/banned-user
chmod +x /usr/bin/banner
chmod +x /usr/bin/delete-user-expire
chmod +x /usr/bin/disable-user-expire
chmod +x /usr/bin/dropmon
chmod +x /usr/bin/menu
chmod +x /usr/bin/unbanned-user
chmod +x /usr/bin/user-active-list
chmod +x /usr/bin/user-add
chmod +x /usr/bin/user-add-pptp
chmod +x /usr/bin/user-del
chmod +x /usr/bin/user-expire-list
chmod +x /usr/bin/user-gen
chmod +x /usr/bin/user-limit
chmod +x /usr/bin/user-list
chmod +x /usr/bin/user-login
chmod +x /usr/bin/user-pass
chmod +x /usr/bin/user-renew
chmod +x /usr/bin/edit-port
chmod +x /usr/bin/edit-port-dropbear
chmod +x /usr/bin/edit-port-openssh
chmod +x /usr/bin/edit-port-squid
chmod +x /usr/bin/edit-port-openvpn
chmod +x /usr/bin/benchmark
chmod +x /usr/bin/root-pass
chmod +x /usr/bin/update
