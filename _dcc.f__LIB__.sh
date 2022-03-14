#!/usr/bin/env bash
#Copyright (c) 2008-2012 http://datasource.pt/

#  *********************************************************************************************
#  | SECTION:INICIAL 2 -> BEGIN
#  .................................................................

function LIB::cd_error_message() {
        #---------------------------------------
        # Mensagem de erro quando fazemos um
        # cd /directoria e ele da erro, se
        # 1 ele cria a directoria
        # 2 ele diz que tem erro
        #---------------------------------------
        if [ "$2" == "2" ]; then
                echo >&2 "Can't read $1. Make sure the directory exists, and try again."
        else
                mkdir $1 /home/_src; cd $1;
        fi
}

function pause(){
        #---------------------------------------
        # Wait for the keyboard ENTER
        #---------------------------------------
        read -r -p "$*"
}


function ASK () {
        #---------------------------------------
        # Waiting in the screen for
        # a word or phrase
        #---------------------------------------
        local keystroke=''
        local key

        while [[ "$keystroke" != [yYnN] ]]
        do
                $ASKCMD "$1" keystroke
                echo "$keystroke";
        done

        key=$(echo "$keystroke")
}


function cecho () {
        #---------------------------------------
        # Coloured-echo.
        # Argument $1 = message
        # Argument $2 = color
        #---------------------------------------
        local message
        local color

        message=$1
        color=$2
        echo -e "$color$message" ; "$Reset"
        return
}


function CPULIMIT {
        #---------------------------------------
        # Instalar cpulimit
        #---------------------------------------

        if [ ! -e "/usr/sbin/cpulimit" ] ; then
                if [ ! -e "/usr/bin/cpulimit" ] ; then
                        clear
                        echo
                        echo "Installing cpulimit..."
                        yum --enablerepo=epel -y install cpulimit
                        echo
                        echo "... [ INSTALLED ]"
                fi
        fi
}


function RSYNC {
        #---------------------------------------
        # Instalar rsync 3.0
        #---------------------------------------
        if [ ! -e  "/usr/bin/rsync" ]; then
                clear
                echo
                echo "Installing Rsync 3.0...."
                echo
                mkdir /home/_src
                cd /home/_src || { LIB::cd_error_message "/home/_src"; return; }
                wget -c  http://www.samba.org/ftp/rsync/src/rsync-3.0.9.tar.gz
                tar -xzf  rsync-3.0.9.tar.gz
                cd rsync-3.0.0/ || { LIB::cd_error_message "rsync-3.0.0/"; return; }
                ./configure
                #--prefix=/opt/rsync
                make
                make install
                cd /home/_src || { LIB::cd_error_message "/home/_src"; return; }
                rm -rf rsync*
                echo
                echo ".... [ INSTALLED ]"
        fi
}


function DIALOGx {
        #---------------------------------------
        # Instalar o dialog
        #---------------------------------------
        if [ ! -e  "/usr/bin/dialog" ]; then
                clear
                echo
                echo "Installing Dialog...."
                echo
                yum -y install dialog
                echo
                echo ".... [ INSTALLED ]"
                echo
        fi

        if [ ! -e  "/usr/bin/bc" ]; then
                clear
                echo
                echo "Installing BC...."
                echo
                yum -y install bc
                echo
                echo ".... [ INSTALLED ]"
                echo
        fi

        if [ ! -e  "/usr/bin/lftp" ]; then
                clear
                echo
                echo "Installing lFTP...."
                echo
                yum -y install lftp
                echo
                echo ".... [ INSTALLED ]"
                echo
        fi

        if [ ! -e  "/usr/bin/mysql-defragger" ]; then
                clear
                echo
                echo "Installing MySQL Defragger...."
                echo
                wget https://raw.github.com/biapy/howto.biapy.com/master/mysql/mysql-defragger --quiet --no-check-certificate --output-document='/usr/bin/mysql-defragger'
                chmod 0700 /usr/bin/mysql-defragger
                chmod +x /usr/bin/mysql-defragger
                echo
                echo ".... [ INSTALLED ]"
                echo
        fi
}


function PMODULES {
        #---------------------------------------
        # Instalar PERL MODULES para o NGINX
        #---------------------------------------
        clear
        echo
        echo "Check & Installing PERL MODULES for Nginx...."
        local REQUIREDMODULES=( "IPC::Open3" "JSON::Syck" "Data::Dumper" "XML::DOM" "Getopt::Long" "XML::Simple" "XML::DOM" )
        local NEEDSCHECK=()
        local NOTINSTALLED=()
        local ALLINSTALLED=1
        local PERLRESULT
        local i
        local SIZEOFNEEDS
        local ismodulethere
        local foundmodule

        PERLRESULT=$( perl -MCGI -e "1" 2>&1)
        if [[ $PERLRESULT != "" ]]; then
                for i in "${REQUIREDMODULES[@]}"
                do
                        echo "installing $i"
                        echo "....."
                        /scripts/perlinstaller "$i" >/dev/null 2>&1
                done
        else
                #Otherwise, test each module before install
                for i in "${REQUIREDMODULES[@]}"
                do
                        foundmodule=$(perl -M"$i" -e "1" 2>&1)
                        if [[ "$foundmodule" != "" ]]; then
                                echo "$i is NOT installed"
                                echo "installing $i"
                                echo "....."
                                /scripts/perlinstaller "$i" >/dev/null 2>&1
                                echo "....."
                                NEEDSCHECK=( "${NEEDSCHECK[@]}" "$i" ) #prevent unset issues with array -1
                        fi
                done
        fi

        SIZEOFNEEDS=${#NEEDSCHECK[@]}
        if [[ "$SIZEOFNEEDS" -ge "1" ]]; then
                echo "$GREEN Testing the perl modules we just installed $RESET"
                echo "....."
                for i in "${NEEDSCHECK[@]}"
                do
                        ismodulethere=$(perl -M"$i" -e "1" 2>&1)
                        if [[ "$ismodulethere" == "" ]]; then
                                echo "$i is installed properly"
                                echo "....."
                        else
                                echo "$i is NOT installed"
                                echo "....."
                                ALLINSTALLED=0
                                NOTINSTALLED=( "${NOTINSTALLED[@]}" "$i" )
                        fi
                done
        fi

        if [[ "$ALLINSTALLED" != 1 ]]; then
                error
                echo "There was an error verifying that all required perl modules are installed."
                echo "The following perl modules could not be installed: "
                for i in "${NOTINSTALLED[@]}"
                do
                        echo "$i"
                done
                echo "You can try installing these modules by running"
                echo "/scripts/perlinstaller <module_name>"
                echo "for each module name listed above."
                echo
                echo "---------------------"
                pause "Press [Enter] to Continue..."
        else
                echo ".....done"
        fi
}


function CHECK_DIRECTORIAS {
        #---------------------------------------
        # Verifica directorias em falta e
        # cria as necessarias
        #---------------------------------------
        clear
        echo
        #---
        if [ ! -d "/home/_src" ]; then
                mkdir -p /home/_src
        fi
        #---
        if [ ! -d "/etc/nginx/certs" ]; then
                mkdir -p /etc/nginx/certs
        fi
        #---
        if [ -d "/backups" ]; then
                if [ ! -d "/backups/cpbackup/_geral" ]; then
                        mkdir -p /backups/cpbackup/_geral
                fi
                #---
                if [ ! -d "/backups/cpbackup/.daily" ]; then
                        mkdir -p /backups/cpbackup/.daily
                fi
        fi
        #---
        if [ ! -d "/home/.backups" ]; then
                mkdir /home/.backups
        fi
        #---
        if [ ! -d "/home/.backups/.logs" ]; then
                mkdir /home/.backups/.logs
        fi
        #---
        if [ ! -d "/home/_backups" ]; then
                mkdir /home/_backups
        fi
        #---
        if [ ! -d "/home/_backups/cpbackup" ]; then
                mkdir -p /home/_backups/cpbackup
        fi
        #---
        if [ ! -d "/home/_backups/cpbackup/_geral" ]; then
                mkdir -p /home/_backups/cpbackup/_geral
        fi
        #---
        if [ ! -d "/home/_backups/cpbackup/daily" ]; then
                mkdir -p /home/_backups/cpbackup/daily
        fi
        #---
        if [ ! -d "/usr/local/apache/conf/userdata" ]; then
                mkdir -p /usr/local/apache/conf/userdata
        fi
        #---
        if [ ! -d "/usr/local/apache/conf/userdata/std" ]; then
                mkdir /usr/local/apache/conf/userdata/std
        fi
        #---
        if [ ! -d "/usr/local/apache/conf/userdata/std/2" ]; then
                mkdir /usr/local/apache/conf/userdata/std/2
        fi
        #---
        if [ ! -d "/usr/local/apache/conf/modsec_rules" ]; then
                mkdir /usr/local/apache/conf/modsec_rules
        fi
        #---
        if [ ! -d "/var/asl/data" ]; then
                mkdir /var/asl
                mkdir /var/asl/data/
                mkdir /var/asl/data/msa
                mkdir /var/asl/data/audit
                mkdir /var/asl/data/suspicious
                mkdir /var/asl/data/tmp
                chown nobody.nobody /var/asl/data/msa
                chown nobody.nobody /var/asl/data/audit
                chown nobody.nobody /var/asl/data/suspicious
                chown nobody.nobody /var/asl/data/tmp
                chmod -R 777 /var/asl/data/msa
                chmod -R 777 /var/asl/data/audit
                chmod -R 777 /var/asl/data/suspicious
                chmod -R 1777 /var/asl/data/tmp
        fi
        #---
        if [ ! -d "/var/asl/data/tmp" ]; then
                mkdir /var/asl
                mkdir /var/asl/data/
                mkdir /var/asl/data/msa
                mkdir /var/asl/data/audit
                mkdir /var/asl/data/suspicious
                mkdir /var/asl/data/tmp
                chown nobody.nobody /var/asl/data/msa
                chown nobody.nobody /var/asl/data/audit
                chown nobody.nobody /var/asl/data/suspicious
                chown nobody.nobody /var/asl/data/tmp
                chmod -R 777 /var/asl/data/msa
                chmod -R 777 /var/asl/data/audit
                chmod -R 777 /var/asl/data/suspicious
                chmod -R 1777 /var/asl/data/tmp
        else
                permsa=$(stat /var/asl/data/tmp | sed -n '/^Access: (/{s/Access: (\([0-9]\+\).*$/\1/;p}')
                if [[ $permsa != 1777 ]]; then
                        chmod -R 777 /var/asl/data/msa
                        chmod -R 777 /var/asl/data/audit
                        chmod -R 777 /var/asl/data/suspicious
                        chmod -R 1777 /var/asl/data/tmp
                fi
                permsb=$(stat /var/asl/data/audit | sed -n '/^Access: (/{s/Access: (\([0-9]\+\).*$/\1/;p}')
                if [[ $permsb != 0777 ]]; then
                        chmod -R 777 /var/asl/data/msa
                        chmod -R 777 /var/asl/data/audit
                        chmod -R 777 /var/asl/data/suspicious
                        chmod -R 1777 /var/asl/data/tmp
                fi
        fi
        #---
        permsc=$( stat -c %U /var/asl/data )
        if [[ "$permsc" != "nobody" ]]; then
                chmod -R 777 /var/asl/data/msa
                chmod -R 777 /var/asl/data/audit
                chmod -R 777 /var/asl/data/suspicious
                chmod -R 1777 /var/asl/data/tmp
                chown -R nobody.nobody /var/asl/data
                chmod o-rx -R /var/asl/data/*
                chmod ug+rwx -R /var/asl/data/*
        fi
        #---
        ##############
        if [ -f "/var/asl/data/msa/ip.pag" ]; then
                permsc=$( stat -c %a /var/asl/data/msa/ip.pag )
                if [[ "$permsc" != "777" ]]; then
                        chmod -R 777 /var/asl/data/msa
                fi
        fi
        if [ -f "/var/asl/data/msa/default_SESSION.pag" ]; then
                permsc=$( stat -c %a /var/asl/data/msa/default_SESSION.pag )
                if [[ "$permsc" != "777" ]]; then
                        chmod -R 777 /var/asl/data/msa
                fi
        fi
        if [ -f "/var/asl/data/msa/default_USER.pag" ]; then
                permsc=$( stat -c %a /var/asl/data/msa/default_USER.pag )
                if [[ "$permsc" != "777" ]]; then
                        chmod -R 777 /var/asl/data/msa
                fi
        fi
        if [ -f "/var/asl/data/msa/global.pag" ]; then
                permsc=$( stat -c %a /var/asl/data/msa/global.pag )
                if [[ "$permsc" != "777" ]]; then
                        chmod -R 777 /var/asl/data/msa
                fi
        fi
        ##############
        #---
        if [ ! -d "/tmp/SecTmpDir" ]; then
                mkdir /tmp/SecTmpDir
                chmod -R 777 /tmp/SecTmpDir
        fi
        #---
        if [ ! -d "/tmp/SecUploadDir" ]; then
                mkdir /tmp/SecUploadDir
                chmod -R 777 /tmp/SecUploadDir
        fi
        #---
        if [ ! -d "/var/cache/mysql" ]; then
                mkdir -p /var/cache/mysql
                chown -R mysql.mysql /var/cache/mysql
                chmod 755 /var/cache/mysql
        fi
        #---
        if [ ! -d "/root/.virus" ]; then
                mkdir /root/.virus
                chmod -R 700 /root/.virus
        fi
        #---
        VERSAOCPANEL0=$( /usr/local/cpanel/cpanel -V | cut -d. -f2 )
        if [[ $VERSAOCPANEL0 == *"build"* ]]; then
                VERSAOCPANEL0=$( /usr/local/cpanel/cpanel -V | cut -d. -f1 )
        fi
        VERSAOCPANEL1=$VERSAOCPANEL0
        VERSAOCPANEL=$VERSAOCPANEL1
        VCONTROLE=40
        if [ $VCONTROLE -le "$VERSAOCPANEL" ]; then
                if [ ! -f "/usr/bin/clamscan" ]; then
                        if [ ! -h "/usr/bin/clamscan" ]; then
                                cd /usr/bin || return;
                                ln -s /usr/local/cpanel/3rdparty/bin/clamscan clamscan
                                cd /root || return;
                        fi
                fi
        fi
        #---
        if [ $VCONTROLE -le $VERSAOCPANEL ]; then
                if [[ ! -d $(readlink /var/lib/clamav) ]]; then
                        rm -rf /var/lib/clamav
                        ln -s /usr/local/cpanel/3rdparty/share/clamav /var/lib/clamav
                        cd /home/_src || { mkdir -p /home/_src; cd /home/_src; }
                fi
        else
                if [[ ! -d `readlink /var/lib/clamav` ]]; then
                        rm -rf /var/lib/clamav
                        ln -s /usr/share/clamav /var/lib/clamav
                        cd /home/_src
                fi
        fi
        #---
        if [ $VCONTROLE -le $VERSAOCPANEL ]; then
                if [[ ! -f `readlink /etc/clamd.conf` ]]; then
                        rm -f /etc/clamd.conf
                        ln -s /usr/local/cpanel/3rdparty/etc/clamd.conf /etc/clamd.conf
                        cd /home/_src
                fi
        fi
        #---
        if [ $VCONTROLE -le $VERSAOCPANEL ]; then
                if [[ ! -f `readlink /usr/bin/clamdscan` ]]; then
                        cd /usr/bin
                        yes| rm -i /usr/bin/clamdscan
                        ln -s /usr/local/cpanel/3rdparty/bin/clamdscan clamdscan
                        cd /root
                fi
        fi
        #---
        if [ $VCONTROLE -le $VERSAOCPANEL ]; then
                if [ -f "/usr/local/cpanel/3rdparty/etc/clamd.conf" ]; then
                        CClamDconf=$( grep -lir "PhishingSignatures yes" /usr/local/cpanel/3rdparty/etc/clamd.conf )
                        minimumsize=2
                        if [ "${CClamDconf}" == "" ]; then
                                wget --no-check-certificate -O /home/_src/clamd.conf https://dcc.hocnet.pt/_dcc/_virus/_clamdconf/clamd.conf
                                tamanho=$(du -b "/home/_src/clamd.conf" | cut -f 1)
                                if [ $tamanho -gt $minimumsize ]; then
                                        cd /home/_src
                                        yes|mv /home/_src/clamd.conf /usr/local/cpanel/3rdparty/etc/clamd.conf  > /dev/null 2>&1
                                        /etc/init.d/exim restart  > /dev/null 2>&1
                                fi
                        fi
                fi
        fi
        #---
        if [ -f "/usr/local/maldetect/antivirus.pl" ]; then
                aavirus=$( grep -lir "JonixKonios_V5" /usr/local/maldetect/antivirus.pl )
                minimumsize=2
                if [ "${aavirus}" == "" ]; then
                        wget --no-check-certificate -O /home/_src/antivirus.pl https://dcc.hocnet.pt/_dcc/_virus/antivirus_pl/antiviruspl.txt
                        tamanho=$(du -b "/home/_src/antivirus.pl" | cut -f 1)
                        if [ $tamanho -gt $minimumsize ]; then
                                cd /home/_src
                                chattr -i /usr/local/maldetect/antivirus.pl
                                yes|mv /home/_src/antivirus.pl /usr/local/maldetect/antivirus.pl  > /dev/null 2>&1
                                chmod 755 /usr/local/maldetect/antivirus.pl
                                chattr +i /usr/local/maldetect/antivirus.pl
                                /etc/init.d/httpd restart
                        fi
                fi
                if [ ! -w /usr/local/maldetect/antivirus.pl ]; then
                        chattr -i /usr/local/maldetect/antivirus.pl
                        chmod 755 /usr/local/maldetect/antivirus.pl
                        chattr +i /usr/local/maldetect/antivirus.pl
                fi
        else
                minimumsize=2
                wget --no-check-certificate -O /home/_src/antivirus.pl https://dcc.hocnet.pt/_dcc/_virus/antivirus_pl/antiviruspl.txt
                tamanho=$(du -b "/home/_src/antivirus.pl" | cut -f 1)
                if [ $tamanho -gt $minimumsize ]; then
                        cd /home/_src
                        chattr -i /usr/local/maldetect/antivirus.pl
                        yes|mv /home/_src/antivirus.pl /usr/local/maldetect/antivirus.pl  > /dev/null 2>&1
                        chmod 755 /usr/local/maldetect/antivirus.pl
                        chattr +i /usr/local/maldetect/antivirus.pl
                        /etc/init.d/httpd restart
                fi
        fi
        #---
        if [ -f "/usr/local/maldetect/modsec.sh" ]; then
                aavirus=$( grep -lir "JonixKonios_V5" /usr/local/maldetect/modsec.sh )
                minimumsize=2
                if [ "${aavirus}" == "" ]; then
                        wget --no-check-certificate -O /home/_src/modsec.sh https://dcc.hocnet.pt/_dcc/_virus/_maldet/modsec.sh.txt
                        tamanho=$(du -b "/home/_src/modsec.sh" | cut -f 1)
                        if [ $tamanho -gt $minimumsize ]; then
                                cd /home/_src
                                chattr -i /usr/local/maldetect/modsec.sh
                                yes|mv /home/_src/modsec.sh /usr/local/maldetect/modsec.sh  > /dev/null 2>&1
                                chmod 755 /usr/local/maldetect/modsec.sh
                                chattr +i /usr/local/maldetect/modsec.sh
                                /etc/init.d/httpd restart
                        fi
                fi
                if [ ! -w /usr/local/maldetect/modsec.sh ]; then
                        chattr -i /usr/local/maldetect/modsec.sh
                        chmod 755 /usr/local/maldetect/modsec.sh
                        chattr +i /usr/local/maldetect/modsec.sh
                fi
        else
                minimumsize=2
                wget --no-check-certificate -O /home/_src/modsec.sh https://dcc.hocnet.pt/_dcc/_virus/_maldet/modsec.sh.txt
                tamanho=$(du -b "/home/_src/modsec.sh" | cut -f 1)
                if [ $tamanho -gt $minimumsize ]; then
                        cd /home/_src
                        chattr -i /usr/local/maldetect/modsec.sh
                        yes|mv /home/_src/modsec.sh /usr/local/maldetect/modsec.sh  > /dev/null 2>&1
                        chmod 755 /usr/local/maldetect/modsec.sh
                        chattr +i /usr/local/maldetect/modsec.sh
                        /etc/init.d/httpd restart
                fi
        fi
        #---
        if [ -f "/usr/local/maldetect/modsec.lua" ]; then
                aavirus=$( grep -lir "JonixKonios_V5" /usr/local/maldetect/modsec.lua )
                minimumsize=2
                if [ "${aavirus}" == "" ]; then
                        wget --no-check-certificate -O /home/_src/modsec.lua https://dcc.hocnet.pt/_dcc/_virus/_maldet/modsec.lua.txt
                        tamanho=$(du -b "/home/_src/modsec.lua" | cut -f 1)
                        if [ $tamanho -gt $minimumsize ]; then
                                cd /home/_src
                                chattr -i /usr/local/maldetect/modsec.lua
                                yes|mv /home/_src/modsec.lua /usr/local/maldetect/modsec.lua  > /dev/null 2>&1
                                chown root.root /usr/local/maldetect/modsec.lua
                                chmod 755 /usr/local/maldetect/modsec.lua
                                chattr +i /usr/local/maldetect/modsec.lua
                                /etc/init.d/httpd restart
                        fi
                fi
                if [ ! -w /usr/local/maldetect/modsec.lua ]; then
                        chattr -i /usr/local/maldetect/modsec.lua
                        chmod 755 /usr/local/maldetect/modsec.lua
                        chattr +i /usr/local/maldetect/modsec.lua
                fi
        else
                minimumsize=2
                wget --no-check-certificate -O /home/_src/modsec.lua https://dcc.hocnet.pt/_dcc/_virus/_maldet/modsec.lua.txt
                tamanho=$(du -b "/home/_src/modsec.lua" | cut -f 1)
                if [ $tamanho -gt $minimumsize ]; then
                        cd /home/_src
                        chattr -i /usr/local/maldetect/modsec.lua
                        yes|mv /home/_src/modsec.lua /usr/local/maldetect/modsec.lua  > /dev/null 2>&1
                        chmod 755 /usr/local/maldetect/modsec.lua
                        chattr +i /usr/local/maldetect/modsec.lua
                        /etc/init.d/httpd restart
                fi
        fi
        #---
        if [ $VCONTROLE -le $VERSAOCPANEL ]; then
                minimumsize=2
                if [ -f "/var/run/pure-ftpd/clamscan.sh" ]; then
                        ClamscanSH=$( grep -lir "JonixKonios3" /var/run/pure-ftpd/clamscan.sh )
                        if [ "${ClamscanSH}" == "" ]; then
                                wget --no-check-certificate -O /home/_src/clamscan.sh https://dcc.hocnet.pt/_dcc/_virus/_var_run_pure-ftpd/clamscan.sh
                                tamanho=$(du -b "/home/_src/clamscan.sh" | cut -f 1)
                                if [ $tamanho -gt $minimumsize ]; then
                                        cd /home/_src
                                        chattr -i /var/run/pure-ftpd/clamscan.sh > /dev/null 2>&1
                                        yes|mv /home/_src/clamscan.sh /var/run/pure-ftpd/clamscan.sh  > /dev/null 2>&1
                                        chmod 755 /var/run/pure-ftpd/clamscan.sh
                                        chattr +i /var/run/pure-ftpd/clamscan.sh > /dev/null 2>&1
                                fi
                        fi
                else
                        wget --no-check-certificate -O /home/_src/clamscan.sh https://dcc.hocnet.pt/_dcc/_virus/_var_run_pure-ftpd/clamscan.sh
                        tamanho=$(du -b "/home/_src/clamscan.sh" | cut -f 1)
                        if [ $tamanho -gt $minimumsize ]; then
                                cd /home/_src
                                chattr -i /var/run/pure-ftpd/clamscan.sh > /dev/null 2>&1
                                yes|mv /home/_src/clamscan.sh /var/run/pure-ftpd/clamscan.sh  > /dev/null 2>&1
                                chmod 755 /var/run/pure-ftpd/clamscan.sh
                                chattr +i /var/run/pure-ftpd/clamscan.sh > /dev/null 2>&1
                        fi
                fi
                if [ ! -f "/var/cpanel/conf/pureftpd/main" ]; then
                        wget --no-check-certificate -O /home/_src/main https://dcc.hocnet.pt/_dcc/_virus/_var_run_pure-ftpd/main
                        tamanho=$(du -b "/home/_src/main" | cut -f 1)
                        if [ $tamanho -gt $minimumsize ]; then
                                cd /home/_src
                                yes|mv /home/_src/main /var/cpanel/conf/pureftpd/main  > /dev/null 2>&1
                                rm -f /var/cpanel/conf/pureftpd/main.cache > /dev/null 2>&1
                                rm -f /var/cpanel/noanonftp > /dev/null 2>&1
                                /scripts/setupftpserver --force pure-ftpd > /dev/null 2>&1
                                /usr/bin/killall -9 /usr/sbin/pure-uploadscript > /dev/null 2>&1
                                /usr/sbin/pure-uploadscript -B -r /var/run/pure-ftpd/clamscan.sh
                                /etc/init.d/pure-ftpd restart > /dev/null 2>&1
                        fi
                else
                        PureFTPmain=$( grep -lir "CallUploadScript: 'yes'" /var/cpanel/conf/pureftpd/main )
                        if [ "${PureFTPmain}" == "" ]; then
                                wget --no-check-certificate -O /home/_src/main https://dcc.hocnet.pt/_dcc/_virus/_var_run_pure-ftpd/main
                                tamanho=$(du -b "/home/_src/main" | cut -f 1)
                                if [ $tamanho -gt $minimumsize ]; then
                                        cd /home/_src
                                        yes|mv /home/_src/main /var/cpanel/conf/pureftpd/main  > /dev/null 2>&1
                                        rm -f /var/cpanel/conf/pureftpd/main.cache > /dev/null 2>&1
                                        rm -f /var/cpanel/noanonftp > /dev/null 2>&1
                                        /scripts/setupftpserver --force pure-ftpd > /dev/null 2>&1
                                        /usr/bin/killall -9 /usr/sbin/pure-uploadscript > /dev/null 2>&1
                                        /usr/sbin/pure-uploadscript -B -r /var/run/pure-ftpd/clamscan.sh
                                        /etc/init.d/pure-ftpd restart  > /dev/null 2>&1
                                fi
                        fi
                fi
        fi
        #---
}


function GEOIP1st {
        #---------------------------------------
        # Instalar GeoIP Pela Primeira Vez
        # e faz a seguir o download e update da
        # bd de paises.
        #---------------------------------------
        local ARQUITETURA
        local VERSAOOS

        ARQUITETURA=$( uname -m )
        VERSAOOS=$( uname -r | grep -i el5 )
        mkdir /home/_src  > /dev/null 2>&1
        cd /home/_src || { LIB::cd_error_message "/home/_src"; return; }

        #_________________________
        # Install RPMFORGE Repository
        if [ ! -f "/etc/yum.repos.d/rpmforge.repo" ] ; then
                if [ "${ARQUITETURA}" == "x86_64" ] ; then
                        if [ "${VERSAOOS}" == "" ] ; then
                                wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
                                rpm -ivh rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
                        else
                                wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el5.rf.x86_64.rpm
                                rpm -ivh rpmforge-release-0.5.3-1.el5.rf.x86_64.rpm
                        fi
                else
                        if [ "${VERSAOOS}" == "" ] ; then
                                wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.i686.rpm
                                rpm -ivh rpmforge-release-0.5.3-1.el6.rf.i686.rpm
                        else
                                wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el5.rf.i386.rpm
                                rpm -ivh rpmforge-release-0.5.3-1.el5.rf.i386.rpm
                        fi
                fi
                replace "enabled = 1" "enabled = 0" -- /etc/yum.repos.d/rpmforge.repo
                sleep 10
        fi

        #_________________________
        # CRIA USERS NO /etc/nignx/userdata/*
        if [ ! -d /etc/nginx/userdata ]; then
                mkdir -p /etc/nginx/userdata

                cd /var/cpanel/users
                for GAIJO in *; do
                        #REMOVE OS HASH()
                        if [[ $GAIJO != *"HASH("* ]]
                        then
                                if [ ! -f /etc/nginx/userdata/${GAIJO} ]; then
                                        cat > "/etc/nginx/userdata/${GAIJO}" << EOF
---
Strict_Transport_Security: 1
Caching: 1
X_Frame_Options: 0
EOF
                                fi
                        fi
                done
        fi

        #_________________________
        # instalar o INCRON e o
        # instalar o EPEL Repository
        if [ ! -f "/usr/sbin/incrond" ] ; then
                if [ ! -f /etc/yum.repos.d/epel.repo ];then
                        OS_RELEASE=`cat /etc/redhat-release  | sed -ne 's/\(^.*release \)\(.*\)\(\..*$\)/\2/p'`
                        if [ $OS_RELEASE -eq 6 ];then
                                OSARCH=`uname -i`
                                if [ $OSARCH = x86_64 ];then
                                        rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
                                else
                                        rpm -ivh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
                                fi
                        else
                                OSARCH=`uname -i`
                                if [ $OSARCH = x86_64 ];then
                                        rpm -ivh http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm
                                else
                                        rpm -ivh http://dl.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm
                                fi
                        fi
                        replace "enabled = 1" "enabled = 0" -- /etc/yum.repos.d/epel.repo
                        replace "enabled=1" "enabled=0" -- /etc/yum.repos.d/epel.repo
                fi

                yum --disablerepo=\* --enablerepo=epel install incron -y
                chkconfig incrond on
                /etc/init.d/incrond start
        fi

        #_________________________
        # instalar o GeoIP
        if [ ! -f "/etc/GeoIP.conf" ] ; then
                clear
                echo "Installing GeoIP and RPMForge..."
                if [ ! -f "/usr/local/apache/conf/modsec_rules/GeoLiteCity.dat" ] ; then
                        mkdir /usr/local/apache/conf/modsec_rules > /dev/null 2>&1
                        cd /usr/local/apache/conf/modsec_rules
                        wget -N -q http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
                        rm -f /usr/local/apache/conf/modsec_rules/*.dat > /dev/null 2>&1
                        /usr/bin/gunzip /usr/local/apache/conf/modsec_rules/GeoLiteCity.dat.gz
                fi
                yum --disablerepo=\* --enablerepo=rpmforge install geoip-devel geoip -y
                echo
                echo "... [ INSTALLED ]"
        else
                clear

                if [ ! -f "/usr/local/apache/conf/modsec_rules/GeoLiteCity.dat" ] ; then
                        mkdir /usr/local/apache/conf/modsec_rules > /dev/null 2>&1
                        cd /usr/local/apache/conf/modsec_rules
                        wget -N -q http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
                        rm -f /usr/local/apache/conf/modsec_rules/*.dat > /dev/null 2>&1
                        /usr/bin/gunzip /usr/local/apache/conf/modsec_rules/GeoLiteCity.dat.gz
                fi

                if [ ! -f "/usr/include/GeoIPCity.h" ] ; then
                        echo "Installing GeoIP and RPMForge..."
                        yum install geoip-devel geoip -y
                        echo
                        echo "... [ INSTALLED ]"
                fi
        fi
}


function GEOIP {
        #----------------------------------------------------
        # Instalar/Update do GeoCityLite para o ModSecurity
        #----------------------------------------------------
        clear
        echo
        echo "GEOIP UPdate..."
        echo
        echo "1) Check/Create /usr/local/apache/conf/modsec_rules"
        mkdir /usr/local/apache/conf/modsec_rules  >/dev/null 2>&1
        echo "2) Calling /usr/local/apache/conf/modsec_rules"
        cd /usr/local/apache/conf/modsec_rules || { LIB::cd_error_message "/usr/local/apache/conf/modsec_rules"; return; }
        echo "3) Getting GeLiteCity.dat.gz"
        wget -N -q http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
        echo "4) Unzipping GeLiteCity.dat.gz"
        rm -f ./*.dat > /dev/null 2>&1
        gunzip ./*.gz
        cd /root || { LIB::cd_error_message "/root"; return; }
        echo
        echo -e "... [ DONE ]"
        echo
        echo "---------------------"
        pause "Press [Enter] to Continue..."
}

#    *********************************************************************************************
#    | SECTION:INICIAL 2 -> END
#    .................................................................
