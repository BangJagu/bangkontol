#!/bin/bash

read -d "~" -p "Silahkan Paste Banner anda disini (\"~\" jika sudah selesai):
" line

cat > /etc/issue.net <<-END
$line

################################################################################
##                                                                            ##
##                         ALL SUPPORTED BY ANEKA VPS                         ##
##                    https://www.facebook.com/aneka.vps.us                   ##
##          DEVELOPED BY YURI BHUANA (fb.com/youree82, 085815002021)          ##
##                                                                            ##
################################################################################
##################  CLOSE BANNER INI AGAR ANDA BISA BROWSING  ##################
END

service dropbear restart
service ssh restart
