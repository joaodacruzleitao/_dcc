#Copyright (c) 2008-2012 http://datasource.pt/ 

#  *********************************************************************************************
#  | SECTION:SEGURANCA -> BEGIN
#  .................................................................

function antivirusUPDATE {
#---------------------------------------
# Update das BDs do ClamAV para armazenar em
# https://dcc.hocnet.pt/_dcc/_virus
#---------------------------------------
    nomeServo=`hostname`
    if [ "$nomeServo" != 'b83.hocnet.org' ]
    then
        exit 0;
    fi

    FTPmirror1="http://ftp.telfort.nl/pub/mirrors/sanesecurity/"
    FTPmirror2="http://ftp.swin.edu.au/sanesecurity"
    FTPmirror3="http://ftp.tiscali.nl/pub/mirror/sanesecurity/"

    MIRRORnumber=$(echo $RANDOM % 3 + 1 | bc)
    case $MIRRORnumber in
    1)
        FTPmirror=$FTPmirror1
        ;;
    2)
        FTPmirror=$FTPmirror2
        ;;
    3)
        FTPmirror=$FTPmirror3
        ;;
    *)
        FTPmirror=$FTPmirror1
        ;;
    esac

    minimumsize=2
    clear
    echo
    echo "Update Antivirus Definitions..."
    echo
    mkdir -p /home/dcchocne/public_html/_dcc/_virus/_tmp

    ## sanesecurity.ftm ##
    wget -O /home/dcchocne/public_html/_dcc/_virus/_tmp/sanesecurity.ftm ${FTPmirror}/sanesecurity.ftm
    tamanho=$(du -b "/home/dcchocne/public_html/_dcc/_virus/_tmp/sanesecurity.ftm" | cut -f 1)
    if [ $tamanho -gt $minimumsize ]; then
        cd /home/dcchocne/public_html/_dcc/_virus/_tmp
        yes|mv sanesecurity.ftm /home/dcchocne/public_html/_dcc/_virus/
    else
        rm -f /home/dcchocne/public_html/_dcc/_virus/_tmp/sanesecurity.ftm
    fi

    ## sigwhitelist.ign2 ##
    wget -O /home/dcchocne/public_html/_dcc/_virus/_tmp/sigwhitelist.ign2 ${FTPmirror}/sigwhitelist.ign2
    tamanho=$(du -b "/home/dcchocne/public_html/_dcc/_virus/_tmp/sigwhitelist.ign2" | cut -f 1)
    if [ $tamanho -gt $minimumsize ]; then
        cd /home/dcchocne/public_html/_dcc/_virus/_tmp
        yes|mv sigwhitelist.ign2 /home/dcchocne/public_html/_dcc/_virus/
    else
        rm -f /home/dcchocne/public_html/_dcc/_virus/_tmp/sigwhitelist.ign2
    fi

    ## rogue.hdb ##
    wget -O /home/dcchocne/public_html/_dcc/_virus/_tmp/rogue.hdb ${FTPmirror}/rogue.hdb
    tamanho=$(du -b "/home/dcchocne/public_html/_dcc/_virus/_tmp/rogue.hdb" | cut -f 1)
    if [ $tamanho -gt $minimumsize ]; then
        cd /home/dcchocne/public_html/_dcc/_virus/_tmp
        yes|mv rogue.hdb /home/dcchocne/public_html/_dcc/_virus/
    else
        rm -f /home/dcchocne/public_html/_dcc/_virus/_tmp/rogue.hdb
    fi

    ## spamattach.hdb ##
    wget -O /home/dcchocne/public_html/_dcc/_virus/_tmp/spamattach.hdb ${FTPmirror}/spamattach.hdb
    tamanho=$(du -b "/home/dcchocne/public_html/_dcc/_virus/_tmp/spamattach.hdb" | cut -f 1)
    if [ $tamanho -gt $minimumsize ]; then
        cd /home/dcchocne/public_html/_dcc/_virus/_tmp
        yes|mv spamattach.hdb /home/dcchocne/public_html/_dcc/_virus/
    else
        rm -f /home/dcchocne/public_html/_dcc/_virus/_tmp/spamattach.hdb
    fi

    ## blurl.ndb ##
    wget -O /home/dcchocne/public_html/_dcc/_virus/_tmp/blurl.ndb ${FTPmirror}/blurl.ndb
    tamanho=$(du -b "/home/dcchocne/public_html/_dcc/_virus/_tmp/blurl.ndb" | cut -f 1)
    if [ $tamanho -gt $minimumsize ]; then
        cd /home/dcchocne/public_html/_dcc/_virus/_tmp
        yes|mv blurl.ndb /home/dcchocne/public_html/_dcc/_virus/
    else
        rm -f /home/dcchocne/public_html/_dcc/_virus/_tmp/blurl.ndb
    fi

    ## winnow_malware.hdb ##
    wget -O /home/dcchocne/public_html/_dcc/_virus/_tmp/winnow_malware.hdb ${FTPmirror}/winnow_malware.hdb
    tamanho=$(du -b "/home/dcchocne/public_html/_dcc/_virus/_tmp/winnow_malware.hdb" | cut -f 1)
    if [ $tamanho -gt $minimumsize ]; then
        cd /home/dcchocne/public_html/_dcc/_virus/_tmp
        yes|mv winnow_malware.hdb /home/dcchocne/public_html/_dcc/_virus/
    else
        rm -f /home/dcchocne/public_html/_dcc/_virus/_tmp/winnow_malware.hdb
    fi

    ## phishtank.ndb ##
    wget -O /home/dcchocne/public_html/_dcc/_virus/_tmp/phishtank.ndb ${FTPmirror}/phishtank.ndb
    tamanho=$(du -b "/home/dcchocne/public_html/_dcc/_virus/_tmp/phishtank.ndb" | cut -f 1)
    if [ $tamanho -gt $minimumsize ]; then
        cd /home/dcchocne/public_html/_dcc/_virus/_tmp
        yes|mv phishtank.ndb /home/dcchocne/public_html/_dcc/_virus/
    else
        rm -f /home/dcchocne/public_html/_dcc/_virus/_tmp/phishtank.ndb
    fi

    ## bofhland_malware_URL.ndb ##
    wget -O /home/dcchocne/public_html/_dcc/_virus/_tmp/bofhland_malware_URL.ndb ${FTPmirror}/bofhland_malware_URL.ndb
    tamanho=$(du -b "/home/dcchocne/public_html/_dcc/_virus/_tmp/bofhland_malware_URL.ndb" | cut -f 1)
    if [ $tamanho -gt $minimumsize ]; then
        cd /home/dcchocne/public_html/_dcc/_virus/_tmp
        yes|mv bofhland_malware_URL.ndb /home/dcchocne/public_html/_dcc/_virus/
    else
        rm -f /home/dcchocne/public_html/_dcc/_virus/_tmp/bofhland_malware_URL.ndb
    fi

    chown -R dcchocne:dcchocne /home/dcchocne/public_html/_dcc/_virus

    #chown -R clamav:clamav /usr/share/clamav
    #/usr/bin/clamdscan --reload
    echo
    echo "... [ DONE ]"
    echo
    echo "---------------------"
    pause "Press [Enter] to Continue..."
}


function antivirusUPDATEclientes {
#---------------------------------------
# Update das BDs do ClamAV em qualquer
# servidor cliente
#---------------------------------------
    FTPmirror="https://dcc.hocnet.pt/_dcc/_virus"
    minimumsize=2
    clear
    echo
    echo "Update Antivirus Definitions..."
    echo
    mkdir -p /home/_src
    chown -R clamav:clamav /var/lib/clamav

    #if [ -f "/usr/local/cpanel/3rdparty/share/clamav/mirrors.dat" ]; then
    if [ -d "/var/lib/clamav" ]; then
        ## sanesecurity.ftm ##
        wget --no-check-certificate -O /home/_src/sanesecurity.ftm ${FTPmirror}/sanesecurity.ftm
        tamanho=$(du -b "/home/_src/sanesecurity.ftm" | cut -f 1)
        if [ $tamanho -gt $minimumsize ]; then
            cd /home/_src
            yes|mv sanesecurity.ftm /var/lib/clamav/
        else
            rm -f /home/_src/sanesecurity.ftm
        fi

        ## sigwhitelist.ign2 ##
        wget --no-check-certificate -O /home/_src/sigwhitelist.ign2 ${FTPmirror}/sigwhitelist.ign2
        tamanho=$(du -b "/home/_src/sigwhitelist.ign2" | cut -f 1)
        if [ $tamanho -gt $minimumsize ]; then
            cd /home/_src
            yes|mv sigwhitelist.ign2 /var/lib/clamav/
        else
            rm -f /home/_src/sigwhitelist.ign2
        fi

        ## rogue.hdb ##
        wget --no-check-certificate -O /home/_src/rogue.hdb ${FTPmirror}/rogue.hdb
        tamanho=$(du -b "/home/_src/rogue.hdb" | cut -f 1)
        if [ $tamanho -gt $minimumsize ]; then
            cd /home/_src
            yes|mv rogue.hdb /var/lib/clamav/
        else
            rm -f /home/_src/rogue.hdb
        fi

        ## spamattach.hdb ##
        wget --no-check-certificate -O /home/_src/spamattach.hdb ${FTPmirror}/spamattach.hdb
        tamanho=$(du -b "/home/_src/spamattach.hdb" | cut -f 1)
        if [ $tamanho -gt $minimumsize ]; then
            cd /home/_src
            yes|mv spamattach.hdb /var/lib/clamav/
        else
            rm -f /home/_src/spamattach.hdb
        fi

        ## blurl.ndb ##
        wget --no-check-certificate -O /home/_src/blurl.ndb ${FTPmirror}/blurl.ndb
        tamanho=$(du -b "/home/_src/blurl.ndb" | cut -f 1)
        if [ $tamanho -gt $minimumsize ]; then
            cd /home/_src
            yes|mv blurl.ndb /var/lib/clamav/
        else
            rm -f /home/_src/blurl.ndb
        fi

        ## winnow_malware.hdb ##
        wget --no-check-certificate -O /home/_src/winnow_malware.hdb ${FTPmirror}/winnow_malware.hdb
        tamanho=$(du -b "/home/_src/winnow_malware.hdb" | cut -f 1)
        if [ $tamanho -gt $minimumsize ]; then
            cd /home/_src
            yes|mv winnow_malware.hdb /var/lib/clamav/
        else
            rm -f /home/_src/winnow_malware.hdb
        fi

        ## phishtank.ndb ##
        wget --no-check-certificate -O /home/_src/phishtank.ndb ${FTPmirror}/phishtank.ndb
        tamanho=$(du -b "/home/_src/phishtank.ndb" | cut -f 1)
        if [ $tamanho -gt $minimumsize ]; then
            cd /home/_src
            yes|mv phishtank.ndb /var/lib/clamav/
        else
            rm -f /home/_src/phishtank.ndb
        fi

        ## bofhland_malware_URL.ndb ##
        wget --no-check-certificate -O /home/_src/bofhland_malware_URL.ndb ${FTPmirror}/bofhland_malware_URL.ndb
        tamanho=$(du -b "/home/_src/bofhland_malware_URL.ndb" | cut -f 1)
        if [ $tamanho -gt $minimumsize ]; then
            cd /home/_src
            yes|mv bofhland_malware_URL.ndb /var/lib/clamav/
        else
            rm -f /home/_src/bofhland_malware_URL.ndb
        fi

        ## hocnet.ndb ##
        wget --no-check-certificate -O /home/_src/hocnet.ndb ${FTPmirror}/_hocnet.db/hocnet.ndb
        tamanho=$(du -b "/home/_src/hocnet.ndb" | cut -f 1)
        if [ $tamanho -gt $minimumsize ]; then
            cd /home/_src
            yes|mv hocnet.ndb /var/lib/clamav/
        else
            rm -f /home/_src/hocnet.ndb
        fi

        ## hocnet.hdb ##
        wget --no-check-certificate -O /home/_src/hocnet.hdb ${FTPmirror}/_hocnet.db/hocnet.hdb
        tamanho=$(du -b "/home/_src/hocnet.hdb" | cut -f 1)
        if [ $tamanho -gt $minimumsize ]; then
            cd /home/_src
            yes|mv hocnet.hdb /var/lib/clamav/
        else
            rm -f /home/_src/hocnet.hdb
        fi

        ## /usr/local/maldetect/sigs/rfxn.hdb ##
        if [ -f "/usr/local/maldetect/sigs/rfxn.hdb" ]; then
            if [ ! -h "/usr/local/cpanel/3rdparty/share/clamav/rfxn.hdb" ]; then
                rm -f /usr/local/cpanel/3rdparty/share/clamav/rfxn.hdb >/dev/null 2>&1
                cd /usr/local/cpanel/3rdparty/share/clamav
                ln -s /usr/local/maldetect/sigs/rfxn.hdb rfxn.hdb
                cd /root
            fi
        fi

        ## /usr/local/maldetect/sigs/rfxn.ndb ##
        if [ -f "/usr/local/maldetect/sigs/rfxn.ndb" ]; then
            if [ ! -h "/usr/local/cpanel/3rdparty/share/clamav/rfxn.ndb" ]; then
                rm -f /usr/local/cpanel/3rdparty/share/clamav/rfxn.ndb >/dev/null 2>&1
                cd /usr/local/cpanel/3rdparty/share/clamav
                ln -s /usr/local/maldetect/sigs/rfxn.ndb rfxn.ndb
                cd /root
            fi
        fi

        ## /usr/local/maldetect/sigs/md5v2.dat ##
        if [ -f "/usr/local/maldetect/sigs/md5v2.dat" ]; then
		    if [ -f "/usr/local/cpanel/3rdparty/share/clamav/md5.dat" ]; then
                rm -f /usr/local/cpanel/3rdparty/share/clamav/md5.dat
            fi
            if [ ! -h "/usr/local/cpanel/3rdparty/share/clamav/md5v2.dat" ]; then
                rm -f /usr/local/cpanel/3rdparty/share/clamav/md5v2.dat >/dev/null 2>&1
                cd /usr/local/cpanel/3rdparty/share/clamav
                ln -s /usr/local/maldetect/sigs/md5v2.dat md5v2.dat
                cd /root
            fi
        else
            if [ -f "/usr/local/maldetect/sigs/md5.dat" ]; then
                if [ ! -h "/usr/local/cpanel/3rdparty/share/clamav/md5.dat" ]; then
                    rm -f /usr/local/cpanel/3rdparty/share/clamav/md5.dat >/dev/null 2>&1
                    cd /usr/local/cpanel/3rdparty/share/clamav
                    ln -s /usr/local/maldetect/sigs/md5.dat md5.dat
                    cd /root
                fi
            fi
        fi

        ## /usr/local/maldetect/sigs/hex.dat ##
        if [ -f "/usr/local/maldetect/sigs/hex.dat" ]; then
            if [ ! -h "/usr/local/cpanel/3rdparty/share/clamav/hex.dat" ]; then
                rm -f /usr/local/cpanel/3rdparty/share/clamav/hex.dat >/dev/null 2>&1
                cd /usr/local/cpanel/3rdparty/share/clamav
                ln -s /usr/local/maldetect/sigs/hex.dat hex.dat
                cd /root
            fi
        fi
		
        chown -R clamav:clamav /var/lib/clamav
    fi
	
    /etc/init.d/exim restart

    echo
    echo "... [ DONE ]"
    echo
    echo "---------------------"
    pause "Press [Enter] to Continue..."
}


function antivirusCHECKfull {
#---------------------------------------
# Verifica virus em todos os alojamento
# do servidor
#---------------------------------------
    clear
    echo
    echo "Check FULL Virus..."
    echo
    mkdir -p /home/_src
    mkdir -p /root/.virus/fullscan
    echo "">/root/.virus/fullscan/__clamdscan_fullscan2.log

    /usr/local/maldetect/maldet -b -a /home/?/public_html

    echo
    echo "... [ DONE ]"
    echo
    echo "---------------------"
    pause "Press [Enter] to Continue..."
}


function antivirusCHECKfullDiario {
#---------------------------------------
# Verifica virus em todos os alojamento
# do servidor em ficheiros com idade
# maxima de 2 dias
#---------------------------------------
    clear
    echo
    echo "Check FULL Daily Virus..."
    echo
	
    /usr/local/maldetect/maldet -b -r /home/?/public_html 2

    echo
    echo "... [ DONE ]"
    echo
    echo "---------------------"
    pause "Press [Enter] to Continue..."
}


function antivirusCHECKsingle {
#---------------------------------------
# Verifica virus num directorio a escolha
# do utilizador
#---------------------------------------
    clear
    echo
    echo "Check Virus..."
    echo

    DIRECTORIO=$2
	if [ "$1" == "virus_check" ]; then
	    if [ -d ${DIRECTORIO} ]; then
                /usr/local/maldetect/maldet -b -a $2
        fi
    fi

    echo
    echo "... [ DONE ]"
    echo
    echo "---------------------"
    pause "Press [Enter] to Continue..."
}


function antivirusRECUPERAsingle {
#---------------------------------------
# Recupera FALSO POSITIVOS do
# verifica virus todos alojamentos
#---------------------------------------
    clear
    echo
    echo "Recuperar Ficheiros Falso Positivos..."
    echo
    mkdir -p /home/_src
    mkdir -p /root/.virus/single

    FICHEIRO=/root/.virus/single/__clamdscan_single.log
    while read line;do
        temporario=`echo "$line"  | grep -i "/root/.virus"`
        if [ "$temporario" != "" ]; then
            HOMEUSER=$( echo "$line" | cut -d' ' -f1 | cut -d':' -f1 )
            ROOTVIRUS=$( echo "$line" | cut -d' ' -f4 | cut -d"'" -f2 )
			USERUSER=$( echo "${HOMEUSER}"  | cut -d'/' -f3 );
            mv -f ${ROOTVIRUS} ${HOMEUSER}
            chown -R ${USERUSER}.${USERUSER} ${HOMEUSER}
            chmod 644 ${HOMEUSER}
            echo "--> A mover $ROOTVIRUS para $HOMEUSER"
            echo
        fi
    done < $FICHEIRO

    echo
    echo "... [ DONE ]"
    echo
    echo "---------------------"
    pause "Press [Enter] to Continue..."
}


function antivirusRECUPERAfull {
#---------------------------------------
# Recupera FALSO POSITIVOS do
# verifica virus todos alojamentos
#---------------------------------------
    clear
    echo
    echo "Recuperar Ficheiros Falso Positivos..."
    echo
    mkdir -p /home/_src
    mkdir -p /root/.virus/fullscan

    FICHEIRO=/root/.virus/fullscan/__clamdscan_fullscan.log
    while read line;do
        temporario=`echo "$line"  | grep -i "/root/.virus"`
        if [ "$temporario" != "" ]; then
            HOMEUSER=$( echo "$line" | cut -d' ' -f1 | cut -d':' -f1 )
            ROOTVIRUS=$( echo "$line" | cut -d' ' -f4 | cut -d"'" -f2 )
			USERUSER=$( echo "${HOMEUSER}"  | cut -d'/' -f3 );
            mv -f ${ROOTVIRUS} ${HOMEUSER}
            chown -R ${USERUSER}.${USERUSER} ${HOMEUSER}
            chmod 644 ${HOMEUSER}
            echo "--> A mover $ROOTVIRUS para $HOMEUSER"
            echo
        fi
    done < $FICHEIRO

    echo
    echo "... [ DONE ]"
    echo
    echo "---------------------"
    pause "Press [Enter] to Continue..."
}


function antivirusRECUPERAfullDAILY {
#---------------------------------------
# Recupera FALSO POSITIVOS do
# verifica virus todos alojamentos
#---------------------------------------
    clear
    echo
    echo "Recuperar Ficheiros Falso Positivos..."
    echo
    mkdir -p /home/_src
    mkdir -p /root/.virus/fullscan

    FICHEIRO=/root/.virus/.dailyScan/.__clamdscan_DailySCAN.log
    while read line;do
        temporario=`echo "$line"  | grep -i "/root/.virus"`
        if [ "$temporario" != "" ]; then
            HOMEUSER=$( echo "$line" | cut -d' ' -f1 | cut -d':' -f1 )
            ROOTVIRUS=$( echo "$line" | cut -d' ' -f4 | cut -d"'" -f2 )
			USERUSER=$( echo "${HOMEUSER}"  | cut -d'/' -f3 );
            mv -f ${ROOTVIRUS} ${HOMEUSER}
            chown -R ${USERUSER}.${USERUSER} ${HOMEUSER}
            chmod 644 ${HOMEUSER}
            echo "--> A mover $ROOTVIRUS para $HOMEUSER"
            echo
        fi
    done < $FICHEIRO

    echo
    echo "... [ DONE ]"
    echo
    echo "---------------------"
    pause "Press [Enter] to Continue..."
}


function MaldetInstall {
#---------------------------------------
# Desempacota ficheiros do tipo 
# .tar ou do tipo .tar.gz
#---------------------------------------
    clear
    echo
    cecho "Maldet Anti-Malware Install..." $boldyellow
    echo

    mkdir -p /home/_src
    cd /home/_src/
	echo "-- Install /usr/local/maldetect"
    wget  --no-check-certificate https://github.com/rfxn/linux-malware-detect/archive/master.zip
    unzip master.zip
	rm -f master.zip
    cd linux-malware-detect-*
    sh install.sh
    cd /home/_src
    rm -rf *

	# Install antivirus.pl
	##########
	echo "-- Install antivirus.pl"
    wget --no-check-certificate -O /home/_src/antivirus.pl https://dcc.hocnet.pt/_dcc/_virus/antivirus_pl/antiviruspl.txt
    cd /home/_src
    chattr -i /usr/local/maldetect/antivirus.pl > /dev/null 2>&1
    yes|mv /home/_src/antivirus.pl /usr/local/maldetect/antivirus.pl  > /dev/null 2>&1
    chmod 755 /usr/local/maldetect/antivirus.pl
    chattr +i /usr/local/maldetect/antivirus.pl

	# Install conf.maldet
	##########
	echo "-- Install conf.maldet"
    wget --no-check-certificate -O /home/_src/conf.maldet https://dcc.hocnet.pt/_dcc/_virus/_maldet/conf.maldet.txt
    cd /home/_src
    chattr -i /usr/local/maldetect/conf.maldet
    yes|mv /home/_src/conf.maldet /usr/local/maldetect/conf.maldet  > /dev/null 2>&1
    chmod 755 /usr/local/maldetect/conf.maldet
    chattr +i /usr/local/maldetect/conf.maldet

	# Install modsec.sh
	##########
	echo "-- Install modsec.sh"
    wget --no-check-certificate -O /home/_src/modsec.sh https://dcc.hocnet.pt/_dcc/_virus/_maldet/modsec.sh.txt
    cd /home/_src
    chattr -i /usr/local/maldetect/modsec.sh
    yes|mv /home/_src/modsec.sh /usr/local/maldetect/modsec.sh  > /dev/null 2>&1
    chmod 755 /usr/local/maldetect/modsec.sh
	
	# Install modsec.lua
	##########
	echo "-- Install modsec.sh"
    wget --no-check-certificate -O /home/_src/modsec.lua https://dcc.hocnet.pt/_dcc/_virus/_maldet/modsec.lua.txt
    cd /home/_src
    chattr -i /usr/local/maldetect/modsec.lua  > /dev/null 2>&1
    yes|mv /home/_src/modsec.lua /usr/local/maldetect/modsec.lua  > /dev/null 2>&1
    chmod 755 /usr/local/maldetect/modsec.lua
	chattr +i /usr/local/maldetect/conf.maldet

    echo
    echo "---------------------"
    pause "Press [Enter] to Continue..."
}


function maldetUpdateINOTIFY {
#---------------------------------------
# Update diario do INOTIFY do MALDET
#---------------------------------------
    clear
    echo
    echo "Update diario do INOTIFY do MALDET..."
    echo

    /usr/local/sbin/maldet -k >> /dev/null 2>&1
    /bin/sleep 6
    /usr/local/maldetect/maldet -m /usr/local/maldetect/_maldetfilelist >> /dev/null 2>&1
  
    echo
    echo "... [ DONE ]"
    echo
    echo "---------------------"
    pause "Press [Enter] to Continue..."
}


function maldetUPDATE {
#---------------------------------------
# Update do antivirus/antimalware MALDET
#---------------------------------------
    minimumsize=2
    nomeServo=`hostname`
    RESTARTCRON="1"
	/usr/bin/wget --no-check-certificate https://dcc.hocnet.pt/_dcc/__V.maldet__.txt -q -O /home/_src/__V.maldet__.txt >/dev/null 2>&1
    if [ "$?" -ne "0" ]; then
        exit 0
    fi
    VERSIONM=$(cat /home/_src/__V.maldet__.txt)

    clear
    echo
    echo "Update MALDET Configuration..."
    echo

    if [ ! -f /scripts/_maldet.v.sh ]
    then
        VERSIONMC="0.0"
    else
        VERSIONMC=$(cat /scripts/_maldet.v.sh)
    fi

    #-BEGIN----------------
    if [ "$VERSIONM" == "$VERSIONMC" ]
    then
        exit 0
    else
        echo ${VERSIONM} > /scripts/_maldet.v.sh
        chmod 400 /scripts/_dcc.functions.sh
        chmod 400 /scripts/_dcc.config.sh
        chmod 400 /scripts/_dcc.v.sh
        chmod 400 /scripts/_dccM.v.sh
        chmod 400 /scripts/_maldet.v.sh
        chmod 700 /scripts/_dccU.sh
        chmod 700 /scripts/_dcc.sh
        chmod 700 /scripts/_dccAPI.pl
        chmod 700 /scripts/_crond_spamExperts

        wget -O /scripts/_maldet_30m.tmp --no-check-certificate https://dcc.hocnet.pt/_dcc/maldet_30m >> /dev/null 2>&1
        tamanho=$(du -b "/scripts/_maldet_30m.tmp" | cut -f 1)
        if [ $tamanho -gt $minimumsize ]; then
            chattr -i /usr/local/maldetect/maldet_30m
            mv /scripts/_maldet_30m.tmp /usr/local/maldetect/maldet_30m
            chmod 755 /usr/local/maldetect/maldet_30m
            chattr +i /usr/local/maldetect/maldet_30m
        else
            RESTARTCRON="0"
            rm -f /scripts/_maldet_30m.tmp
        fi

        wget -O /scripts/_ignore_inotify.tmp --no-check-certificate https://dcc.hocnet.pt/_dcc/ignore_inotify >> /dev/null 2>&1
        tamanho=$(du -b "/scripts/_ignore_inotify.tmp" | cut -f 1)
        if [ $tamanho -gt $minimumsize ]; then
            mv /scripts/_ignore_inotify.tmp /usr/local/maldetect/ignore_inotify
            chmod 644 /usr/local/maldetect/ignore_inotify
        else
            RESTARTCRON="0"
            rm -f /scripts/_ignore_inotify.tmp
        fi

        wget -O /scripts/_maldetfilelist.tmp --no-check-certificate https://dcc.hocnet.pt/_dcc/_maldetfilelist >> /dev/null 2>&1
        tamanho=$(du -b "/scripts/_maldetfilelist.tmp" | cut -f 1)
        if [ $tamanho -gt $minimumsize ]; then
            mv /scripts/_maldetfilelist.tmp /usr/local/maldetect/_maldetfilelist
            chmod 644 /usr/local/maldetect/_maldetfilelist
        else
            RESTARTCRON="0"
            rm -f /scripts/_maldetfilelist.tmp
        fi

        if [ "$RESTARTCRON" == "1" ]; then
            /usr/local/sbin/maldet -k >> /dev/null 2>&1
            /bin/sleep 5
           /usr/local/maldetect/maldet -m /usr/local/maldetect/_maldetfilelist >> /dev/null 2>&1
        fi
  
    fi
    #-END----------------
    echo
    echo "... [ DONE ]"
    echo
    echo "---------------------"
    pause "Press [Enter] to Continue..."
}


function modsecurityAPAGAR {
#---------------------------------------
# Apagar o /var/asl/data/audit/dia_anterior
#---------------------------------------
    clear
    echo
    cecho "Apagar Logs ModSecurity Antigos..."
    echo
    TEMPO=`date +%d`
    TEMPO1=`date +%Y%m`
    TEMPO2=`expr ${TEMPO} - 1`
    TEMPO3=${TEMPO2}

    find /var/asl/data/tmp -name '*' -print -exec rm -f {} \; > /dev/null 2>&1
    for dir in /var/asl/data/audit/*; do
        if [ -d "${dir}" ]; then
            rm -rf "${dir}"
        fi
    done

    echo "1) Apagando os logs"

    echo
    echo -e "... [ DONE ]"
    echo
    echo "---------------------"
    pause "Press [Enter] to Continue..."
}


function maldetUpdateINOTIFY {
#---------------------------------------
# Update diario do INOTIFY do MALDET
#---------------------------------------
    clear
    echo
    echo "Update diario do INOTIFY do MALDET..."
    echo

    /usr/local/sbin/maldet -k >> /dev/null 2>&1
    /bin/sleep 6
    /usr/local/maldetect/maldet -m /usr/local/maldetect/_maldetfilelist >> /dev/null 2>&1
  
    echo
    echo "... [ DONE ]"
    echo
    echo "---------------------"
    pause "Press [Enter] to Continue..."
}


function modsecurityUPDATE {
#---------------------------------------
# Update das regras ModSecurity do gotroot.com
#---------------------------------------
    minimumsize=2
    nomeServo=`hostname`
    ENVIAEMAIL="0"
    SENDEMAIL="1"
	/usr/bin/wget --no-check-certificate https://dcc.hocnet.pt/_dcc/__V.modsec__.txt -q -O /home/_src/__V.modsec__.txt
    if [ "$?" -ne "0" ]; then
        exit 0
    fi
    VERSIONM=$(cat /home/_src/__V.modsec__.txt)

    clear
    echo
    echo "Update ModSecurity Rules..."
    echo
    echo "1) Apagando os logs"
    echo

    if [ ! -f /scripts/_dccM.v.sh ]
    then
        VERSIONMC="0.0"
    else
        VERSIONMC=$(cat /scripts/_dccM.v.sh)
    fi

    #-BEGIN----------------
    if [ "$VERSIONM" == "$VERSIONMC" ]
    then
        exit 0
    else
        echo ${VERSIONM} > /scripts/_dccM.v.sh
        chmod 400 /scripts/_dcc.functions.sh
        chmod 400 /scripts/_dcc.config.sh
        chmod 400 /scripts/_dcc.v.sh
        chmod 400 /scripts/_dccM.v.sh
        chmod 700 /scripts/_dccU.sh
        chmod 700 /scripts/_dcc.sh
        chmod 700 /scripts/_dccAPI.pl
        chmod 700 /scripts/_crond_spamExperts
        mkdir -p /usr/local/apache/conf/modsec_rules
    
        cd /usr/local/apache/conf/modsec_rules
        wget -O /usr/local/apache/conf/modsec_rules/_modsec_.tar.gz --no-check-certificate https://dcc.hocnet.pt/_dcc/_modsec/modsec_rules/_modsec_.tar.gz
        wget -O /usr/local/apache/conf/_modsec0_.tar.gz --no-check-certificate https://dcc.hocnet.pt/_dcc/_modsec/_modsec0_.tar.gz
        tamanho=$(du -b "/usr/local/apache/conf/modsec_rules/_modsec_.tar.gz" | cut -f 1)
        tamanhos=$(du -b "/usr/local/apache/conf/_modsec0_.tar.gz" | cut -f 1)
        if [ $tamanho -gt $minimumsize ]; then
            rm -f /usr/local/apache/conf/modsec_rules/*.conf
            rm -f /usr/local/apache/conf/modsec_rules/*.data
            rm -f /usr/local/apache/conf/modsec_rules/*.txt
            tar -xzvf _modsec_.tar.gz
            chmod 644 /usr/local/apache/conf/modsec_rules/*
            chown root.root /usr/local/apache/conf/modsec_rules/*
            if [ $tamanhos -gt $minimumsize ]; then
                cd /usr/local/apache/conf
                tar -xzvf _modsec0_.tar.gz
                chmod 600 /usr/local/apache/conf/modsec2.*
                chown root.root /usr/local/apache/conf/modsec_rules/*
            else
                TEXTOEMAIL="ERROR: Nao foi possivel actualizar as regras MODSECURITY em /usr/local/apache/conf/modsec2.conf"
                ENVIAEMAIL="1"
                rm -f /usr/local/apache/conf/_modsec0_.tar.gz
            fi
        else
            TEXTOEMAIL="ERROR: Nao foi possivel actualizar as regras MODSECURITY em /usr/local/apache/conf/modsec_rules/"
            ENVIAEMAIL="1"
            rm -f /usr/local/apache/conf/modsec_rules/_modsec_.tar.gz
        fi

        if [ "$ENVIAEMAIL" == "$SENDEMAIL" ]; then
            printf "$TEXTOEMAIL" | /bin/mail -s "${nomeServo}: ModSecurity Rules UPDATE FAILED!" servidores@datasource.pt
        else
            /etc/init.d/httpd restart
        fi

        rm -f /usr/local/apache/conf/_modsec0_.tar.gz
        rm -f /usr/local/apache/conf/modsec_rules/_modsec_.tar.gz

    fi
    #-END----------------
    echo
    echo "... [ DONE ]"
    echo
    echo "---------------------"
    pause "Press [Enter] to Continue..."
}


function modsecurityTAR {
#---------------------------------------
# Empacota a Source do Nginx 
# em /home/dcchocne/public_html/_dcc/_modsec/modsec_rules
#---------------------------------------
    clear
    echo
    echo "Empacotando ModSecurity ..."
    echo

    #---

    # Faz o check se esta no servidor certo
    #
    if [ ! -d "/home/dcchocne/public_html/_dcc/_modsec/modsec_rules" ]; then
	    echo "ISTO SO PODE SER FEITO NO Servidor dcc.hocnet.pt, o B83!!!!!!"
        echo
        echo "Exited!"
        echo
        exit 0;
    fi

    # Chamar directorio
    #
    echo "1) a Chamar /home/dcchocne/public_html/_dcc/_modsec/modsec_rules"
    cd /home/dcchocne/public_html/_dcc/_modsec/modsec_rules

    # Copiar _modsec_.tar.gz
    #
    echo "2) A criar o _modsec_.tar.gz"
	cd /home/dcchocne/public_html/_dcc/_modsec/modsec_rules
    rm -f _modsec_.tar.gz
    tar -czvf _modsec_.tar.gz *.conf *.data *.txt
    chown dcchocne.dcchocne _modsec_.tar.gz

    # Copiar _modsec0_.tar.gz
    #
    echo "2) A criar o _modsec_.tar.gz"
	cd /home/dcchocne/public_html/_dcc/_modsec
    rm -f _modsec0_.tar.gz
    tar -czvf _modsec0_.tar.gz modsec2.*
    chown dcchocne.dcchocne _modsec0_.tar.gz


    echo
    echo
    
    #---
    echo
    echo -e "... [ DONE ]"
    echo
    echo "---------------------------"
    pause "Pressione [Enter] para Continuar..."
    echo
}


function modsecurity::comodo_install {
#---------------------------------------
# Instala o COMODO WAF
#---------------------------------------
    clear
    echo
    echo "Comodo Firewall Install..."
    echo

    mkdir /home/_src
    cd /home/_src
    wget https://waf.comodo.com/cpanel/cwaf_client_install.sh
    chmod 700 cwaf_client_install.sh
	./cwaf_client_install.sh
    cd /home/_src
	rm -f cwaf_client_install.sh

    #---
    echo
    echo -e "... [ DONE ]"
    echo
    echo "---------------------------"
    pause "Pressione [Enter] para Continuar..."
    echo
}


function modsecurity::comodo_activate_LUA {
#---------------------------------------
# Remove o cardinal do modlua, isto:
# # LoadFile /opt/lua/lib/liblua.so
# --> Deve ser corrido apos update do
# --> plugin do COMODO WAF
#---------------------------------------
    clear
    echo
    echo "Activate ModLua on COMODO WAF..."
    echo

    replace "# LoadFile /opt/lua/lib/liblua.so" "LoadFile /opt/lua/lib/liblua.so" -- /opt/cpanel/perl5/514/site_lib/Comodo/CWAF/ModSecurity.pm
    #cd /home/_src
    #wget https://waf.comodo.com/cpanel/cwaf_client_install.sh
    #chmod 700 cwaf_client_install.sh
	#./cwaf_client_install.sh
    #cd /home/_src
	#rm -f cwaf_client_install.sh

    #---
    echo
    echo -e "... [ DONE ]"
    echo
    echo "---------------------------"
    pause "Pressione [Enter] para Continuar..."
    echo
}


function INODEAbuse {
#---------------------------------------
# Detecta os Utilizadores com mais de
# 250.000 ficheiros/directorias e envia
# email a avisar para o root
#---------------------------------------
    nomeServo=$(hostname)
	
    cd /home
    echo "Lista de Utilizadores com INODE ABUSE" > /tmp/inode.log
    printf "******************************************************************\n" >> /tmp/inode.log
    for d in `find -maxdepth 1 -type d |cut -d\/ -f2 |grep -xv . |sort`; do 
        if [ "${d}" != "1backups" ]
        then
            C=$(find ${d} |wc -l);
        fi

        if [ "${C}" -gt "100000" ] ; then
	     if [ "$2" == "1" ]
            then
                echo "$d = ${C} <br>"
            else
                printf "$d = ${C}\n" >> /tmp/inode.log
                #sed -i 's/^BACKUP=1/BACKUP=0/' /var/cpanel/users/$d
            fi
        fi
    done
	if [ "$2" == "1" ]
    then
        echo "" >> /tmp/inode.log
    else
        cat /tmp/inode.log | /bin/mail -s "( INODE ABUSE ) on ${nomeServo}" servidores@datasource.pt
    fi
}


function configserver::csf_install {
#---------------------------------------
# Instala o Configserver CSF Firewall
#---------------------------------------
    clear
    echo
    cecho "Configserver CSF Firewall..." $boldyellow
    echo

    mkdir /home/_src
    cd /home/_src/
    wget http://www.configserver.com/free/csf.tgz
    tar -xzf csf.tgz
    cd /home/_src/csf
    sh install.sh
    cd /home/_src/
    rm -rf csf*
    cd /etc/csf
    #--
    rm -f csf.conf
    /usr/bin/wget --no-check-certificate https://dcc.hocnet.pt/_dcc/_CSF/csf.conf
    chmod 755 csf.conf
    #--
    rm -f csf.allow
    /usr/bin/wget --no-check-certificate https://dcc.hocnet.pt/_dcc/_CSF/csf.allow
    chmod 755 csf.allow
    #--
    rm -f csf.pignore
    /usr/bin/wget --no-check-certificate https://dcc.hocnet.pt/_dcc/_CSF/csf.pignore
    chmod 755 csf.pignore
    #--
    rm -f csf.blocklists
    /usr/bin/wget --no-check-certificate https://dcc.hocnet.pt/_dcc/_CSF/csf.blocklists
    chmod 755 csf.blocklists
    #--
    cd /etc/csf/messenger
    rm -rf *
    wget http://hocnet:oveFZuX25In4lzSN5W@dev.hocnet.info/cpanel/csf/messenger/hocnet.pt.png
    wget http://hocnet:oveFZuX25In4lzSN5W@dev.hocnet.info/cpanel/csf/messenger/index.html
    wget http://hocnet:oveFZuX25In4lzSN5W@dev.hocnet.info/cpanel/csf/messenger/index.text
    chmod 0600 *
    useradd csf -s /bin/false
    cd /home/_src

    replace "#Port 22" "Port 2726" -- /etc/ssh/sshd_config
    replace "#UseDNS yes" "UseDNS no" -- /etc/ssh/sshd_config

    /usr/sbin/csf -r >/dev/null 2>&1
    /etc/init.d/lfd restart
    /etc/init.d/sshd restart

    echo
    echo "---------------------"
    pause "Press [Enter] to Continue..."
}


function configserver::mail_queues_install {
#---------------------------------------
# Instala o Configserver Mail Queues
#---------------------------------------
    clear
    echo
    cecho "Configserver Mail Queues..." $boldyellow
    echo

    mkdir /home/_src
    cd /home/_src
    wget http://www.configserver.com/free/cmq.tgz
    tar -xzf cmq.tgz
    cd cmq
    sh install.sh
    cd /home/_src
    rm -rf cmq*
    cd /home/_src

    echo
    echo "---------------------"
    pause "Press [Enter] to Continue..."
}


function configserver::mail_manager_install {
#---------------------------------------
# Instala o Configserver Mail Manager
#---------------------------------------
    clear
    echo
    cecho "Configserver Mail Manager..." $boldyellow
    echo

    mkdir /home/_src
    cd /home/_src
    wget http://www.configserver.com/free/cmm.tgz
    tar -xzf cmm.tgz
    cd cmm
    sh install.sh
    cd /home/_src
    rm -rf cmm*
    cd /home/_src

    echo
    echo "---------------------"
    pause "Press [Enter] to Continue..."
}


function configserver::modsec_manager_install {
#---------------------------------------
# Instala o Configserver Modsec Manager
#---------------------------------------
    clear
    echo
    cecho "Configserver Modsec Manager..." $boldyellow
    echo

    mkdir /home/_src
    cd /home/_src
    wget http://www.configserver.com/free/cmc.tgz
    tar -xzf cmc.tgz
    cd cmc
    sh install.sh
    cd /home/_src
    rm -rf cmc*
    cd /home/_src

    echo
    echo "---------------------"
    pause "Press [Enter] to Continue..."
}

#    *********************************************************************************************
#    | SECTION:SEGURANCA -> END
#    .................................................................
