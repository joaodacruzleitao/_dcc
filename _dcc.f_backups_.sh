#Copyright (c) 2008-2012 http://datasource.pt/ 

#  *********************************************************************************************
#  | SECTION:BACKUPS -> BEGIN
#  .................................................................

function BACKUP {
#---------------------------------------
# Copia um Backup de um USER para o 
# directorio dele
#---------------------------------------
    DIA=$(date +%d)
    MES=$(date +%m)
    ANO=$(date +%Y)
    DATACORRENTE="${ANO}-${MES}-${DIA}"

    clear
    echo
    cecho "Copiar Backup do user $2 ..." $boldyellow
    echo
    if [ "$1" == "backup_user" ]
    then
        if [ -z "$2" ]
        then
            echo "é preciso especificar o USERNAME para o backup, assim:"
            echo "Exemplo: `basename $0` -3 USERNAME"
            echo
            exit 0
        fi
        USERN=$2
        TIPOdeBACKUP="0"
        if [ -f "/backups/${DATACORRENTE}/${USERN}.tar.gz" ]; then
            TIPOdeBACKUP="1"
        fi
        if [ -f "/home/_backups/${DATACORRENTE}/${USERN}.tar.gz" ]; then
            TIPOdeBACKUP="2"
        fi
        if [ -f "/backups/cpbackup/daily/${USERN}.tar" ]; then
            TIPOdeBACKUP="3"
        fi
        if [ "${TIPOdeBACKUP}"=="1" ];
        then
            #---
            echo "1) Copiando backup para /home/$USERN/public_html/$USERN.tar"
            cd /backups/${DATACORRENTE}/accounts
            yes|cp -f ${USERN}.tar.gz /home/${USERN}/public_html/ >> /dev/null 2>&1
            #---
            echo "2) Corrigindo permissoes do backup copiado"
            chown ${USERN}:${USERN} /home/${USERN}/public_html/${USERN}.tar.gz
            chmod 644 /home/${USERN}/public_html/${USERN}.tar.gz
            #---
            echo "3) backup copiado!"
        fi
        if [ "${TIPOdeBACKUP}"=="2" ];
        then
            #---
            echo "1) Copiando backup para /home/$USERN/public_html/$USERN.tar"
            cd /home/_backups/${DATACORRENTE}/accounts
            yes|cp -f ${USERN}.tar.gz /home/${USERN}/public_html/ >> /dev/null 2>&1
            #---
            echo "2) Corrigindo permissoes do backup copiado"
            chown ${USERN}:${USERN} /home/${USERN}/public_html/${USERN}.tar.gz
            chmod 644 /home/${USERN}/public_html/${USERN}.tar
            #---
            echo "3) backup copiado!"
        fi
        if [ "${TIPOdeBACKUP}"=="3" ];
        then
            #---
            echo "1) Copiando backup para /home/$USERN/public_html/$USERN.tar"
            cd /backups/cpbackup/daily
            yes|cp -f ${USERN}.tar /home/${USERN}/public_html/ >> /dev/null 2>&1
            #---
            echo "2) Corrigindo permissoes do backup copiado"
            chown ${USERN}:${USERN} /home/${USERN}/public_html/${USERN}.tar
            chmod 644 /home/${USERN}/public_html/${USERN}.tar
            #---
            echo "3) backup copiado!"
        fi
        if [ "${TIPOdeBACKUP}"=="0" ];
        then
            cecho "Esse backups não existe!!!!!!" $red
        fi
		
        echo
        echo -e "... $GREEN[ DONE ]$RESET"
        echo
        echo "---------------------------"
        pause "Pressione [Enter] para Continuar..."
        echo
    else
        #--
        for RUSERS in `ls -A /var/cpanel/users`; do 
            DOMAIN=$( grep main_domain /var/cpanel/userdata/$RUSERS/main | awk '{print $2}' )
            MENUDATA+="'${RUSERS}' '${DOMAIN}' "
	     #CONTA=$((CONTA+1))
        done
        USERN=$( echo $MENUDATA|xargs dialog --clear --stdout --begin 2 2 --backtitle "$NOMEFINAL" --title ' COPIA BACKUP de Alojamento ' --menu "Escolha um Utilizador:" 0 0 0 )
		
        # CANCEL Pressionado
        if [ -z "$USERN" ]; 
        then
            MENUprincipal
        fi
	    # VERIFICAR SE USER JA EXISTE NO SISTEMA
        verifica=`cat /etc/passwd | cut -d : -f 1 | grep -i ^$USERN$`
        if [ -z "$verifica" ]; then
            dialog --backtitle "$NOMEFINAL" --title "ATENCAO" --msgbox "Utilizador nao existe!!!" 6 60
            MENUprincipal
	    fi
        #--
        TIPOdeBACKUP="0"
        if [ -f "/backups/${DATACORRENTE}/${USERN}.tar.gz" ]; then
            TIPOdeBACKUP="1"
        fi
        if [ -f "/home/_backups/${DATACORRENTE}/${USERN}.tar.gz" ]; then
            TIPOdeBACKUP="2"
        fi
        if [ -f "/backups/cpbackup/daily/${USERN}.tar" ]; then
            TIPOdeBACKUP="3"
        fi
        if [ "${TIPOdeBACKUP}"=="1" ];
        then
            #---
            echo "1) Copiando backup para /home/$USERN/public_html/$USERN.tar"
            dialog --backtitle "$NOMEFINAL" --title "FASE #1" --infobox "Copiando backup para /home/$USERN/public_html/$USERN.tar" 3 60
            cd /backups/${DATACORRENTE}/accounts
            yes|cp -f ${USERN}.tar.gz /home/${USERN}/public_html/ >> /dev/null 2>&1
            sleep 2
            #---
            dialog --backtitle "$NOMEFINAL" --title "FASE #2" --infobox "Corrigindo permissoes do backup copiado" 3 60
            chown ${USERN}:${USERN} /home/${USERN}/public_html/${USERN}.tar.gz
            chmod 644 /home/${USERN}/public_html/${USERN}.tar.gz
            sleep 2
            #---
            dialog --backtitle "$NOMEFINAL" --title "FIM" --msgbox "Backup copiado!!" 6 60
        fi
        if [ "${TIPOdeBACKUP}"=="2" ];
        then
            #---
            dialog --backtitle "$NOMEFINAL" --title "FASE #1" --infobox "Copiando backup para /home/$USERN/public_html/$USERN.tar" 3 60
            cd /home/_backups/${DATACORRENTE}/accounts
            yes|cp -f ${USERN}.tar.gz /home/${USERN}/public_html/ >> /dev/null 2>&1
            sleep 2
            #---
            dialog --backtitle "$NOMEFINAL" --title "FASE #2" --infobox "Corrigindo permissoes do backup copiado" 3 60
            chown ${USERN}:${USERN} /home/${USERN}/public_html/${USERN}.tar.gz
            chmod 644 /home/${USERN}/public_html/${USERN}.tar
            sleep 2
            #---
            dialog --backtitle "$NOMEFINAL" --title "FIM" --msgbox "Backup copiado!!" 6 60
        fi
        if [ "${TIPOdeBACKUP}"=="3" ];
        then
            #---
            dialog --backtitle "$NOMEFINAL" --title "FASE #1" --infobox "Copiando backup para /home/$USERN/public_html/$USERN.tar" 3 60
            cd /backups/cpbackup/daily
            yes|cp -f ${USERN}.tar /home/${USERN}/public_html/ >> /dev/null 2>&1
            sleep 2
            #---
            dialog --backtitle "$NOMEFINAL" --title "FASE #2" --infobox "Corrigindo permissoes do backup copiado" 3 60
            chown ${USERN}:${USERN} /home/${USERN}/public_html/${USERN}.tar
            chmod 644 /home/${USERN}/public_html/${USERN}.tar
            sleep 2
            #---
            dialog --backtitle "$NOMEFINAL" --title "FIM" --msgbox "Backup copiado!!" 6 60
        fi
        if [ "${TIPOdeBACKUP}"=="0" ];
        then
            dialog --backtitle "$NOMEFINAL" --title "ATENCAO" --msgbox "Esse backup nao existe!!!" 6 60
        fi
        MENUprincipal
        #--
    fi
}


function BACKUPnas1 {
#---------------------------------------
# Copia os Backups para o NAS
#---------------------------------------
    clear
    echo
    cecho "Copiar Backups para o NAS ..." $boldyellow
    echo
    if [ "$1" == "-4" ]
    then
        if [ -z "$2" ]
        then
            echo "é preciso especificar a CHAVE e o DESTINO, assim:"
            echo "Exemplo: `basename $0` -4 CHAVE DESTINO"
            echo "Exemplo: `basename $0` -4 p25 p25-s14"
            echo
            exit 0
        fi
        if [ -z "$3" ]
        then
            echo "é preciso especificar a CHAVE e o DESTINO, assim:"
            echo "Exemplo: `basename $0` -4 CHAVE DESTINO"
            echo "Exemplo: `basename $0` -4 p25 p25-s14"
            echo
            exit 0
        fi
        CHAVE=$2
        DESTINO=$3
    else
        read -p "Digite a CHAVE por favor: " CHAVE
        read -p "Digite o DESTINO por favor: " DESTINO
    fi
    #---
    echo "1) Configurando CPU para 10% na copia"
    pkill -9 cpulimit
    /usr/sbin/cpulimit -e rsync -l 10 &
    echo "2) A copiar Backups"
    rsync --progress -rav -e "ssh -o Compression=no -l root -i /root/.ssh/$CHAVE" "/backups/cpbackup/daily" "${SERVIDORBACKUP}::$DESTINO/"
    echo "3) Retirando limite de CPU nos backups"
    pkill -9 cpulimit
    echo "4) Backups copiados!"
    echo
    echo -e "... $GREEN[ DONE ]$RESET"
    echo
    echo "---------------------------"
    pause "Pressione [Enter] para Continuar..."
    echo
}


function BACKUPnas2 {
#---------------------------------------
# Copia os Backups para o NAS
#---------------------------------------
    clear
    echo
    cecho "Copiar Backups para o NAS ..." $boldyellow
    echo
    if [ "$1" == "-19" ]
    then
        echo "1) A copiar Backups"
# 72485760 = 70Mb/s (600 mbps de rede)
# 62914560 = 60Mb/s (480 mbps de rede)
# 41943040 = 40Mb/s (350 mbps de rede)
# 31457280 = 30Mb/s (240 mbps de rede)
# 20971520 = 20Mb/s (180 mbps de rede)
# 10485760 = 10Mb/s (90 mbps de rede)
# 131072 = 1Mb/s
# set net:limit-rate 72485760
lftp -u ${UZER},${FTPPASS} ${SERVIDORBACKUP} << EOF
set net:limit-rate 20971520
mirror -Rcev --use-cache ${BACKUPGERAL1} ${DESTINO1}
quit 0
EOF
        echo "2) Backups copiados!"
    else
        echo "é preciso especificar os campos todos, assim:"
        echo "Exemplo: `basename $0` -19 USER PASSWORD DESTINO1 DESTINO2"
        echo "Exemplo: `basename $0` -19 user pass_user linux b41_a9"
        echo
        exit 0
    fi
    echo
    echo -e "... $GREEN[ DONE ]$RESET"
    echo
    echo "---------------------------"
    pause "Pressione [Enter] para Continuar..."
    echo
}


function BACKUPnas2GET1 {
#---------------------------------------
# Retira do NAS um backup
#---------------------------------------
    clear
    echo
    cecho "A Descarregar Backup do NAS ..." $boldyellow
    echo
    if [ "$1" == "-20" ]
    then
        if [ -z "$2" ]
        then
            echo "é preciso especificar os campos todos, assim:"
            echo "Exemplo: `basename $0` -20 USER PASSWORD DESTINO1 DESTINO2"
            echo "Exemplo: `basename $0` -20 user pass_user /vol_raid10/volraid10/linux/b41_a9/ficheiro.tar /backups/cpbackup/_geral/ficheiro.tar"
            echo
            exit 0
        fi
        DIRFILE=$2
        #---
        echo "1) A copiar Backups"
# 72485760 = 70Mb/s (600 mbps de rede)
# 62914560 = 60Mb/s (480 mbps de rede)
# 41943040 = 40Mb/s (350 mbps de rede)
# 31457280 = 30Mb/s (240 mbps de rede)
# 20971520 = 20Mb/s (180 mbps de rede)
# 10485760 = 10Mb/s (90 mbps de rede)
# 131072 = 1Mb/s
lftp -u ${UZER},${FTPPASS} ${SERVIDORBACKUP} << EOF
set xfer:clobber on
set net:limit-rate 20971520
get -c ${DESTINO1}${DIRFILE} -o ${DESTINO2}_geral
quit 0
EOF
        echo "2) Backups copiados!"
    else
        echo "é preciso especificar os campos todos, assim:"
        echo "Exemplo: `basename $0` -20 directorio/ficheiro (do NAS)"
        echo "Exemplo: `basename $0` -20 daily/ficheiro.tar"
        echo
        exit 0
    fi
    echo
    echo -e "... $GREEN[ DONE ]$RESET"
    echo
    echo "---------------------------"
    pause "Pressione [Enter] para Continuar..."
    echo
}


function BACKUPnas2GETAll {
#---------------------------------------
# Retira do NAS um backup
#---------------------------------------
    clear
    echo
    echo "A Descarregar Backup do NAS ..."
    echo
    if [ "$1" == "-21" ]
    then
        #---
        echo "1) A copiar Backups"
# 72485760 = 70Mb/s (600 mbps de rede)
# 62914560 = 60Mb/s (480 mbps de rede)
# 41943040 = 40Mb/s (350 mbps de rede)
# 31457280 = 30Mb/s (240 mbps de rede)
# 20971520 = 20Mb/s (180 mbps de rede)
# 10485760 = 10Mb/s (90 mbps de rede)
# 131072 = 1Mb/s
lftp -u ${UZER},${FTPPASS} ${SERVIDORBACKUP} << EOF
set xfer:clobber on
set net:limit-rate 20971520
mirror -cv --use-cache ${DESTINO1}daily/ ${DESTINO2}_geral
quit 0
EOF
        echo "2) Backups copiados!"
    else
        echo "é preciso especificar os campos todos, assim:"
        echo "Exemplo: `basename $0` -21"
        echo
        exit 0
    fi
    echo
    echo -e "... [ DONE ]"
    echo
    echo "---------------------------"
    pause "Pressione [Enter] para Continuar..."
    echo
}


function BACKUPd {
#---------------------------------------
# Cria os Backups Diarios
#---------------------------------------
    DATA=`date +%u`
    clear
    echo
    cecho "A Criar Backups Diarios ..." $boldyellow
    echo
    case "$DATA" in
        1)
        DIA="2feira"
        ;;
        2)
        DIA="3feira"
        ;;
        3)
        DIA="4feira"
        ;;
        4)
        DIA="5feira"
        ;;
        5)
        DIA="6feira"
        ;;
        6)
        DIA="sabado"
        ;;
        7)
        DIA="domingo"
        ;;
    esac
    #--
    echo "1) Configurando CPU para 10% na copia"
    pkill -9 cpulimit
    /usr/sbin/cpulimit -P /usr/local/bin/python -l 10 &
    /usr/sbin/cpulimit -e ssh -l 30 &
    echo "2) A criar backups cpanel"
    echo
    for RUSERS in `ls -A /var/cpanel/users`; do 
        /scripts/pkgacct --allow-override --skiphomedir --nocompress --backup $RUSERS /backups/cpbackup/$DIA
    done
    echo
    echo "3) A copiar o directorio /home"
    echo
    /usr/local/bin/rdiff-backup --exclude /home/.cpan --exclude /home/.cpanm --exclude /home/.cpcpan --exclude /home/.nginx --exclude /home/_src --exclude /home/cpeasyapache --exclude /home/cprestore --exclude /home/installd -v5 --print-statistics /home /backups/cpbackup/_home_backup
    echo
    echo "4) Retirando limite de CPU nos backups"
    pkill -9 cpulimit
    echo "5) Backups copiados!"
    echo
    echo -e "... $GREEN[ DONE ]$RESET"
    echo
    echo "---------------------------"
    pause "Pressione [Enter] para Continuar..."
    echo
}


function BACKUPnas2C {
#---------------------------------------
# Cria os Backups VPS para o NAS
#---------------------------------------
    clear
    echo
    cecho "A Criar Backups Semanais no NAS ..." $boldyellow
    echo
    #---
    if [ ! -d "/backups/cpbackup/diario" ]; then
        mkdir /backups/cpbackup/diario
    fi
    #---
    if [ ! -d "/backups/cpbackup/diario/home" ]; then
        mkdir /backups/cpbackup/diario/home
    fi
    #---
    if [ "$1" == "backupss" ]
    then
        if [ -z "$2" ]
        then
            echo "é preciso especificar o host e o DESTINO, assim:"
            echo "Exemplo: `basename $0` backupss HOST DESTINO DIA"
            echo "Exemplo: `basename $0` backupss ${SERVIDORBACKUP} rufus1 1"
            echo
            exit 0
        fi
        if [ -z "$3" ]
        then
            echo "é preciso especificar o host e o DESTINO, assim:"
            echo "Exemplo: `basename $0` backupss HOST DESTINO"
            echo "Exemplo: `basename $0` backupss ${SERVIDORBACKUP} rufus1"
            echo
            exit 0
        fi
        if [ -z "$4" ]
        then
            echo "é preciso especificar o host e o DESTINO, assim:"
            echo "Exemplo: `basename $0` backupss HOST DESTINO"
            echo "Exemplo: `basename $0` backupss ${SERVIDORBACKUP} rufus1"
            echo
            exit 0
        fi
        HOST=$2
        DESTINO=$3
        DIA=$4
    else
        read -p "Digite a HOST por favor: " HOST
        read -p "Digite o DESTINO por favor: " DESTINO
        read -p "Digite o DIA (1-7 = Seg. - Domingo), por favor: " DIA
    fi
    #---
    echo "1) Configurando CPU slowness para copia"
    /usr/sbin/cpulimit -P /usr/local/bin/python -l 10 &
    /usr/sbin/cpulimit -e ssh -l 30 &
    echo "2) A copiar Backups"
    /usr/local/bin/rdiff-backup --exclude /home/.cpan --exclude /home/.cpanm --exclude /home/.cpcpan --exclude /home/.nginx --exclude /home/_src --exclude /home/cpeasyapache --exclude /home/cprestore --exclude /home/csf --exclude /home/installd -v5 --print-statistics /home root@$HOST::/mnt/vol_raid10/volraid10/linux/$DESTINO/home
    /usr/local/bin/rdiff-backup --exclude /backups/cpbackup/diario/home -v5 --print-statistics /backups/cpbackup/diario root@$HOST::/mnt/vol_raid10/volraid10/linux/$DESTINO/tar
    echo "3) Retirando limite de CPU nos backups"
    pkill -9 cpulimit
    echo "4) Backups copiados!"
    echo
    echo -e "... $GREEN[ DONE ]$RESET"
    echo
    echo "---------------------------"
    pause "Pressione [Enter] para Continuar..."
    echo
}


function BACKUPrTOTAL {
#---------------------------------------
# Restaura backups totais a escolha
#---------------------------------------
    clear
    echo
    cecho "A Criar Backups Semanais no NAS ..." $boldyellow
    echo
    #---
    if [ "$1" == "backupss" ]
    then
        if [ -z "$2" ]
        then
            echo "é preciso especificar o host e o DESTINO, assim:"
            echo "Exemplo: `basename $0` backupss HOST DESTINO DIA"
            echo "Exemplo: `basename $0` backupss ${SERVIDORBACKUP} rufus1 1"
            echo
            exit 0
        fi
        if [ -z "$3" ]
        then
            echo "é preciso especificar o host e o DESTINO, assim:"
            echo "Exemplo: `basename $0` backupss HOST DESTINO"
            echo "Exemplo: `basename $0` backupss ${SERVIDORBACKUP} rufus1"
            echo
            exit 0
        fi
        if [ -z "$4" ]
        then
            echo "é preciso especificar o host e o DESTINO, assim:"
            echo "Exemplo: `basename $0` backupss HOST DESTINO"
            echo "Exemplo: `basename $0` backupss ${SERVIDORBACKUP} rufus1"
            echo
            exit 0
        fi
        HOST=$2
        DESTINO=$3
        DIA=$4
    else
	    echo "Backups Disponiveis á escolha"
		echo "------------------------------------------"
        ls -la --full-time /backups/cpbackup/ | grep "2feira" | awk '{ print $6,"-",$9}'
        ls -la --full-time /backups/cpbackup/ | grep "3feira" | awk '{ print $6,"-",$9}'
        ls -la --full-time /backups/cpbackup/ | grep "4feira" | awk '{ print $6,"-",$9}'
        ls -la --full-time /backups/cpbackup/ | grep "5feira" | awk '{ print $6,"-",$9}'
        ls -la --full-time /backups/cpbackup/ | grep "6feira" | awk '{ print $6,"-",$9}'
        ls -la --full-time /backups/cpbackup/ | grep "sabado" | awk '{ print $6,"-",$9}'
        ls -la --full-time /backups/cpbackup/ | grep "domingo" | awk '{ print $6,"-",$9}'
		echo "------------------------------------------"
	    read -p "Escolha o dia favor (2feira, etc.): " DIA
        read -p "Digite a USER a restaurar: " USER
    fi
    #---
	echo
    echo "1) Restaurando Backup"
	cd /backups/cpbackup/$DIA && /scripts/restorepkg --force /backups/cpbackup/$DIA/$USER.tar > /root/_dcc_bkp_restore.log 2>&1
    echo "2) Restore terminado!"
	#---
    echo
    echo -e "... $GREEN[ DONE ]$RESET"
    echo
    echo "---------------------------"
    pause "Pressione [Enter] para Continuar..."
    echo
}


function BACKUPdiario {
#----------------------------------------------------
# Cria os Backups Diarios = 2ª a 6ª feira
#----------------------------------------------------
    if [ "$1" == "-5" ]
    then
	    #--
        DATA=`date +%u`
        DATAC=`date`
        repDate=`date +%Y-%B-%d`
        nomeServo=`hostname`
        DIAStotal=$((${DIAS} + ${DIAS} - 1))
        #--
    else
        echo
        cecho "Backups Diarios ..." $boldyellow
        echo
        echo "E preciso especificar a opção, assim:"
        echo "Exemplo: `basename $0` -5"
        echo
        exit 0
    fi
    #--
    echo "INICIO: ${DATAC}" >> /home/.backups/.logs/backup_${repDate}.log
    echo "" >> /home/.backups/.logs/backup_${repDate}.log
    #--
	echo "" >> /home/.backups/.logs/backup_${repDate}.log
    echo "1) A criar backups cpanel" >> /home/.backups/.logs/backup_${repDate}.log
    echo "=================================" >> /home/.backups/.logs/backup_${repDate}.log
    for RUSERS in `ls -A /var/cpanel/users`; do 
       /usr/local/cpanel/bin/cpuwatch 8 /scripts/pkgacct --split --skiphomedir --nocompress --backup ${RUSERS} ${DIRBTMP} >> /home/.backups/.logs/backup_${repDate}.log
       echo "=================================" >> /home/.backups/.logs/backup_${repDate}.log
    done
    #--
    export FTP_PASSWORD=${FTPPASS}
    export PASSPHRASE=
    #--
	echo "" >> /home/.backups/.logs/backup_${repDate}.log
    echo "2) A copiar os tar cpanel" >> /home/.backups/.logs/backup_${repDate}.log
    echo "=================================" >> /home/.backups/.logs/backup_${repDate}.log
    /usr/local/cpanel/bin/cpuwatch 4 /usr/local/bin/duplicity incremental --full-if-older-than ${DIAS}D --volsize 50 --archive-dir=/home/.backups/.cache --no-encryption --asynchronous-upload --ftp-passive --tempdir=/home/.backups -v4 ${DIRBTMP} ftp://${UZER}@${SERVIDORBACKUP}${DUPLICITY1} >> /home/.backups/.logs/backup_${repDate}.log
    echo "=================================" >> /home/.backups/.logs/backup_${repDate}.log
    #--
	echo "" >> /home/.backups/.logs/backup_${repDate}.log
    echo "3) A copiar o /home" >> /home/.backups/.logs/backup_${repDate}.log
    echo "=================================" >> /home/.backups/.logs/backup_${repDate}.log
    /usr/local/cpanel/bin/cpuwatch 4 /usr/local/bin/duplicity incremental --full-if-older-than ${DIAS}D --volsize 50 --exclude /home/aquota.user --exclude /home/quota.user --exclude /home/munin --exclude /home/virtfs --exclude /home/cpbackuptmp --exclude /home/mysql --exclude /home/_backups --exclude /home/cprubybuild --exclude /home/cprubygemsbuild --exclude /home/domlogs --exclude /home/.cpan --exclude /home/.cpanm --exclude /home/.cpcpan --exclude /home/.cpcpan --exclude /home/nginx --exclude /home/no --exclude /home/.nginx --exclude /home/_src --exclude /home/cpeasyapache --exclude /home/cprestore --exclude /home/installd --exclude /home/.backups --exclude /home/csf --archive-dir=/home/.backups/.cache --no-encryption --asynchronous-upload --ftp-passive --tempdir=/home/.backups -v4 /home ftp://${UZER}@${SERVIDORBACKUP}${DUPLICITY2} >> /home/.backups/.logs/backup_${repDate}.log
    echo "=================================" >> /home/.backups/.logs/backup_${repDate}.log
    #--
	echo "" >> /home/.backups/.logs/backup_${repDate}.log
    echo "4) A remover backups antigos" >> /home/.backups/.logs/backup_${repDate}.log
    echo "=================================" >> /home/.backups/.logs/backup_${repDate}.log
    echo "CPANEL:" >> /home/.backups/.logs/backup_${repDate}.log
    #/usr/local/cpanel/bin/cpuwatch 4 /usr/local/bin/duplicity remove-older-than ${DIAStotal}D --force --archive-dir=/home/.backups/.cache --tempdir=/home/.backups -v5 ftp://${UZER}@${SERVIDORBACKUP}${DUPLICITY1}  >> /home/.backups/.logs/backup_${repDate}.log
    /usr/local/cpanel/bin/cpuwatch 4 /usr/local/bin/duplicity remove-all-but-n-full 2 --force --archive-dir=/home/.backups/.cache --tempdir=/home/.backups -v5 ftp://${UZER}@${SERVIDORBACKUP}${DUPLICITY1}  >> /home/.backups/.logs/backup_${repDate}.log
	echo "" >> /home/.backups/.logs/backup_${repDate}.log
    echo "HOME:" >> /home/.backups/.logs/backup_${repDate}.log
    #/usr/local/cpanel/bin/cpuwatch 4 /usr/local/bin/duplicity remove-older-than ${DIAStotal}D --force --archive-dir=/home/.backups/.cache --tempdir=/home/.backups -v5 ftp://${UZER}@${SERVIDORBACKUP}${DUPLICITY2}  >> /home/.backups/.logs/backup_${repDate}.log
    /usr/local/cpanel/bin/cpuwatch 4 /usr/local/bin/duplicity remove-all-but-n-full 2 --force --archive-dir=/home/.backups/.cache --tempdir=/home/.backups -v5 ftp://${UZER}@${SERVIDORBACKUP}${DUPLICITY2}  >> /home/.backups/.logs/backup_${repDate}.log
    echo "=================================" >> /home/.backups/.logs/backup_${repDate}.log
	echo "" >> /home/.backups/.logs/backup_${repDate}.log
    #--
    echo "5) ESPAÇO TOTAL OCUPADO" >> /home/.backups/.logs/backup_${repDate}.log
    echo "=================================" >> /home/.backups/.logs/backup_${repDate}.log
    #--
    echo "du -hs" . | lftp -u ${UZER},${FTPPASS} ${SERVIDORBACKUP}${DESTINO1}  >> /home/.backups/.logs/backup_${repDate}.log
    echo "=================================" >> /home/.backups/.logs/backup_${repDate}.log
	echo "" >> /home/.backups/.logs/backup_${repDate}.log
    #--
    unset FTP_PASSWORD
    unset PASSPHRASE
    #--
    echo "6) Backups copiados, TERMINADO." >> /home/.backups/.logs/backup_${repDate}.log
    #--
    echo "" >> /home/.backups/.logs/backup_${repDate}.log
    echo "FIM: ${DATAC}" >> /home/.backups/.logs/backup_${repDate}.log
    #--
    # Mail me the results
    DATAC=`date`
    cat /home/.backups/.logs/backup_${repDate}.log | /bin/mail -s "(BACKUP TERMINADO) on ${nomeServo}" servidores@datasource.pt
    rm -f /home/.backups/.logs/backup_${repDate}.log
    rm -f ${DIRBTMP}/*.tar
    #--
    # FIM
    #--
}


function BACKUPCPanelCheck {
#---------------------------------------
# Verifica backups cpanel e se estiverem
# em HANG envia email a avisar e apaga 
# o processo
#---------------------------------------
    clear
    echo
    echo "Check CPanel Backup Processes..."
    echo

    nomeServo=`hostname`

    DETETA2=$( ps aux | grep -i /usr/local/cpanel/bin/backup | grep -v "grep " )
    #--
    if [ "$DETETA2" != "" ]; then
		BODY="ERRO BACKUP\n\nTime: `date`\nBackups ainda estao activos.\n\nLiga-te ao servidor e verifica o que se passa, pois parecem encravados.\n"
		MAIL="Subject: (BACKUP ERRO) on ${nomeServo}\nFrom: root@`hostname`\nTo: root@`hostname`\n\n$BODY"  
		echo -e $MAIL | sendmail -t
    else
        if [ -f "/var/cpanel/backuprunning" ]; then
            rm -f /var/cpanel/backuprunning
        fi
        if [ -f "/var/cpanel/new_backuprunning" ]; then
            rm -f /var/cpanel/new_backuprunning
        fi
    fi

    echo
    echo "... [ DONE ]"
    echo
    echo "---------------------"
    pause "Press [Enter] to Continue..."
}


function BACKUPCPanelNFSCopy {
#---------------------------------------
# Copia o Backup Diário para a share
# NFS depois de terminado.
#---------------------------------------
    clear
    echo
    echo "Copiando Backups para NFS Share..."
    echo

    #_________________________
	# declaracao de variaveis necessarias
    DIA=$(date +%d)
    MES=$(date +%m)
    ANO=$(date +%Y)
    DATACORRENTE="${ANO}-${MES}-${DIA}"
    nomeServo=`hostname`
    DETETA=$( mount | grep -i /home/1backups )

    #_________________________
    # Determina se a directoria e o /home/_backups ou o /backups
    if [ -z "$2" ]; then
        if [ -d "/home/_backups/${DATACORRENTE}/accounts" ]; then
            DIRCP1='/home/_backups/${DATACORRENTE}/'
        fi
        #--
        if [ -d "/backups/${DATACORRENTE}/accounts" ]; then
            DIRCP1='/backups/${DATACORRENTE}/'
        fi
    else
        if [ -d "/home/_backups/$2/accounts" ]; then
            DIRCP1='/home/_backups/$2/'
        fi
        #--
        if [ -d "/backups/$2/accounts" ]; then
            DIRCP1='/backups/$2/'
        fi
    fi

    #_________________________
    # Copia os backups para o directorio correcto, o /home/1backups
    if [ "$1" == "backup_cp_nfs" ]; then
        if [ -z "$2" ]; then
            if [ "$DETETA" == "" ]; then
                mount /home/1backups
                /usr/local/cpanel/bin/cpuwatch 5.0 /usr/bin/rsync -avh --progress --bwlimit=11520 ${DIRCP1} /home/1backups/${DATACORRENTE}/ >/dev/null 2>&1
                umount /home/1backups
            else
                /usr/local/cpanel/bin/cpuwatch 5.0 /usr/bin/rsync -avh --progress --bwlimit=11520 ${DIRCP1} /home/1backups/${DATACORRENTE}/ >/dev/null 2>&1
                umount /home/1backups
            fi
        else
            if [ "$DETETA" == "" ]; then
                mount /home/1backups
                /usr/local/cpanel/bin/cpuwatch 5.0 /usr/bin/rsync -avh --progress --bwlimit=11520 ${DIRCP1} /home/1backups/$2/ >/dev/null 2>&1
                umount /home/1backups
            else
                /usr/local/cpanel/bin/cpuwatch 5.0 /usr/bin/rsync -avh --progress --bwlimit=11520 ${DIRCP1} /home/1backups/$2/ >/dev/null 2>&1
                umount /home/1backups
            fi
        fi
    fi

    #_________________________
    echo
    echo "... [ DONE ]"
    echo
    echo "---------------------"
    pause "Press [Enter] to Continue..."
}

#    *********************************************************************************************
#    | SECTION:BACKUPS -> END
#    .................................................................
