#!/usr/bin/env bash
#Copyright (c) 2008-2012 http://datasource.pt/

#  *********************************************************************************************
#  | SECTION:SISTEMA -> BEGIN
#  .................................................................

function CORRIGE {
        #---------------------------------------
        # Corrige Permissoes de um Utilizador
        #---------------------------------------
        local VerificA
        local USERN
        local DOMAIN
        local MENUDATA
        local RUSERS

        clear
        echo
        cecho "Corrigindo Permissoes para o Utilizador ..." "$boldyellow"
        echo
        if [ "$1" == "sis_puser" ]
        then
                if [ -z "$2" ]
                then
                        echo "E preciso especificar o USERNAME, assim:"
                        echo "Exemplo: ${ScriptTnamE} corrige USERNAME"
                        echo "Exemplo: ${ScriptTnamE} corrige jonix "
                        echo
                        exit 0
                fi
                USERN="$2"
                #--
                echo "1) Corrigindo permissoes no public_html"
                chown -R "${USERN}":"${USERN}" /home/"${USERN}"/public_html/
                chown "${USERN}":nobody /home/"${USERN}"/public_html/
                echo
                #--
                echo "2) Corrigindo permissoes nos ficheiros e directorias"
                find /home/"$USERN"/public_html/ -type d -exec chmod 755 {} \;
                find /home/"$USERN"/public_html/ -type f -exec chmod 644 {} \;
                #--
                echo "3) Corrigindo permissoes Finais"
                chmod 750 /home/"${USERN}"/public_html/
                echo "4) permissoes corrigidas!"
                #--
                echo
                echo -e "... ${GREEN}[ DONE ]${RESET}"
                echo
                echo "---------------------------"
                pause "Pressione [Enter] para Continuar..."
                echo
        else
                for RUSERS in ls -A /var/cpanel/users; do
                        DOMAIN=$( grep main_domain /var/cpanel/userdata/$RUSERS/main | awk '{print $2}' )
                        MENUDATA+=("$(basename $RUSERS)" "${DOMAIN}")
                done
                USERN=$( echo "${MENUDATA[@]}"|xargs dialog --clear --stdout --begin 2 2 --backtitle "$NOMEFINAL" --title ' CORRIGE Permissoes de Alojamento ' --menu "Escolha um Utilizador:" 0 0 0 )

                # CANCEL Pressionado
                if [ -z "${USERN}" ];
                then
                        MENUprincipal
                fi
                ###- VERIFICAR SE USER JA EXISTE NO SISTEMA
                VerificA=$( (cut -d : -f 1 | grep -i "^$USERN$") < /etc/passwd)
                if [ -z "$VerificA" ];
                then
                        dialog --backtitle "$NOMEFINAL" --title "ATENCAO" --msgbox "Utilizador nao existe!!!" 3 60
                        MENUprincipal
                fi
                #--
                dialog --backtitle "$NOMEFINAL" --title "FASE #1" --infobox "Corrigindo permissoes no public_html" 3 60
                chown -R "$USERN":"$USERN" /home/"$USERN"/public_html/
                chown "$USERN":nobody /home/"$USERN"/public_html/
                sleep 2
                #--
                dialog --backtitle "$NOMEFINAL" --title "FASE #2" --infobox "Corrigindo permissoes nos ficheiros e directorias" 3 60
                find /home/"$USERN"/public_html/ -type d -exec chmod 755 {} \;
                find /home/"$USERN"/public_html/ -type f -exec chmod 644 {} \;
                sleep 2
                #--
                dialog --backtitle "$NOMEFINAL" --title "FASE #3" --infobox "Corrigindo permissoes Finais" 3 60
                chmod 750 /home/"$USERN"/public_html/
                sleep 2
                #--
                dialog --backtitle "$NOMEFINAL" --title "FIM" --msgbox "Permissoes Corrigidas!!" 6 60
        fi
}


function CORRIGE2 {
        #---------------------------------------
        # Corrige Permissoes de um directorio
        # de um Utilizador
        #---------------------------------------
        local USERN
        local DIRECTORIO
        local VerificA
        clear
        echo
        cecho "Corrigindo Permissoes Utilizado em Directorio ..." "$boldyellow"
        echo
        if [ "$1" == "sis_puser_dir" ]
        then
                if [ -z "$2" ]
                then
                        echo "E preciso especificar o USERNAME e o DIRECTORIO, assim:"
                        echo "Exemplo: ${ScriptTnamE} corrige USERNAME DIRECTORIO"
                        echo "Exemplo: ${ScriptTnamE} corrige jonix public_html/cache"
                        echo
                        exit 0
                fi
                if [ -z "$3" ]
                then
                        echo "E preciso especificar o USERNAME e o DIRECTORIO, assim:"
                        echo "Exemplo: ${ScriptTnamE} corrige USERNAME DIRECTORIO"
                        echo "Exemplo: ${ScriptTnamE} corrige jonix public_html/cache"
                        echo
                        exit 0
                fi
                USERN=$2
                DIRECTORIO=$3
                #--
                echo "1) Corrigindo permissoes no /home/$USERN/$DIRECTORIO/"
                chown -R "$USERN":"$USERN" /home/"$USERN"/"$DIRECTORIO"/
                #--
                echo "2) Corrigindo permissoes nos ficheiros e directorias"
                find /home/"$USERN"/"$DIRECTORIO"/ -type d -exec chmod 755 {} \;
                find /home/"$USERN"/"$DIRECTORIO"/ -type f -exec chmod 644 {} \;
                #--
                echo "3) Corrigindo permissoes Finais"
                chmod 750 /home/"$USERN"/public_html/
                echo "4) permissoes corrigidas!"
                #--
                echo
                echo -e "... ${GREEN}[ DONE ]${RESET}"
                echo
                echo "---------------------------"
                pause "Pressione [Enter] para Continuar..."
                echo
        else
                USERN=$( dialog \
                                --clear \
                                --stdout \
                                --no-cancel \
                                --begin 2 2 \
                                --backtitle "$NOMEFINAL" \
                                --title "UTILITIES" \
                                --form "Corrigir Permissoes Utilizador Directorio" 8 50 0 \
                                "Username:" 1 1	"" 	1 10 15 0 \
                        )

                # VERIFICAR SE USER J� EXISTE NO SISTEMA
                VerificA=$( (cut -d : -f 1 | grep -i "^$USERN$") < /etc/passwd)
                if [ -z "$verifica" ];
                then
                        dialog --backtitle "$NOMEFINAL" --title "ATENCAO" --msgbox "Utilizador nao existe!!!" 6 60
                        MENUprincipal
                fi
                #--
                DIRECTORIO=$( dialog \
                                --clear \
                                --stdout \
                                --no-cancel \
                                --begin 2 2 \
                                --backtitle "$NOMEFINAL" \
                                --title "UTILITIES" \
                                --form "Corrigir Permissoes Utilizador Directorio" 8 70 0 \
                                "Directorio:" 1 1	"public_html/cache" 	1 15 50 0 \
                        )

                # VERIFICAR SE DIRECTORIO EXISTE NO SISTEMA
                if [ ! -d "/home/$USERN/$DIRECTORIO" ]; then
                        dialog --backtitle "$NOMEFINAL" --title "ATENCAO" --msgbox "/home/$USERN/$DIRECTORIO NAO EXISTE!!!" 6 60
                        MENUprincipal
                fi
                #--
                dialog --backtitle "$NOMEFINAL" --title "FASE #1" --infobox "Corrigindo permissoes no /home/${USERN}/${DIRECTORIO}" 5 60
                chown -R "${USERN}":"${USERN}" /home/"$USERN"/"$DIRECTORIO"/
                sleep 2
                #--
                dialog --backtitle "$NOMEFINAL" --title "FASE #2" --infobox "Corrigindo permissoes nos ficheiros e directorias" 5 60
                find /home/"${USERN}"/"$DIRECTORIO"/ -type d -exec chmod 755 {} \;
                find /home/"$USERN"/"$DIRECTORIO"/ -type f -exec chmod 644 {} \;
                sleep 2
                #--
                dialog --backtitle "$NOMEFINAL" --title "FASE #3" --infobox "Corrigindo permissoes Finais" 5 60
                chmod 750 /home/"$USERN"/public_html/
                sleep 2
                #--
                dialog --backtitle "$NOMEFINAL" --title "FIM" --msgbox "Permissoes Corrigidas!!" 6 60
        fi
}


function CorrigeTodos {
        #---------------------------------------
        # Corrige Permissoes de todos
        # os utilizadores
        #---------------------------------------
        local user

        clear
        echo
        cecho "Corrigindo Permissoes TODOS Utilizadores ..." "$boldyellow"
        echo

        cd /var/cpanel/users || { LIB::cd_error_message "/var/cpanel/users"; return; }
        for user in *
        do
                ###- Correct the owner of the files and directories
                chown -R "$user":"$user" /home/"$user"/public_html/
                chown "$user":nobody /home/"$user"/public_html/

                ###- Correct the permissions of the files and directories
                find /home/"$user"/public_html/ -type d -exec chmod 755 {} \;
                find /home/"$user"/public_html/ -type f -exec chmod 644 {} \;
                find /home/"$user"/public_html/ -name 'configuration.php' -type f -exec chmod 444 {} \;
                find /home/"$user"/public_html/ -name 'wp-config.php' -type f -exec chmod 444 {} \;
                find /home/"$user"/public_html/ -name 'index.php' -type f -exec chmod 444 {} \;
                find /home/"$user"/public_html/ -name '.htaccess' -type f -exec chmod 444 {} \;

                # Correct the owner of the public_html directory
                ################
                chmod 750 /home/"$user"/public_html/
        done

        echo
        echo "---------------------"
        pause "Press [Enter] to Continue..."
}


function PHPfcgiKillOrphan {
        #---------------------------------------
        # Mata os processod de PHP FastCGI que
        # ficaram orfaos e so oupam memoria
        #---------------------------------------
        /bin/ps -Ao"command,pid,ppid"|/bin/grep ' 1$'|/bin/grep /php|/bin/awk '{ print $3; }'|/usr/bin/xargs kill -9 > /dev/null 2>&1
        /bin/ps auxwwwf | /bin/grep '[0-9] /usr/bin/php' | /bin/awk '{ print $2 }' | xargs kill -9 > /dev/null 2>&1
        if [ "$1" == "sis_php_del" ]; then
                exit 0
        else
                dialog --backtitle "$NOMEFINAL" --title "PHP Process Kill" --msgbox "Processos PHP Eliminados!!!" 6 60
                MENUprincipal
        fi
}


function TarGZ {
        #---------------------------------------
        # Compacta ficheiros criando ficheiro
        # do tipo .tar ou  .tar.gz
        #---------------------------------------
        clear
        if [ -z "$2" ]; then
                echo "You need to specify the name of FILE:"
                echo "Example .tar: ${ScriptTnamE} sis_t ficheiro.tar /directory/complete"
                echo "Example .tar.gz: ${ScriptTnamE}} sis_tgz ficheiro.tar.gz /directory/complete"
                echo
                exit 0
        fi
        echo
        cecho "Retrieving files..." "$boldyellow"
        echo

        cd "$3" ||  { LIB::cd_error_message "$3" "2"; exit 1; }
        case "$1" in
                sis_t)
                        /bin/tar cvf "$2" ./*
                        ;;
                sis_tgz)
                        /bin/tar czvf "$2" ./*
                        ;;
        esac

        echo
        echo "---------------------"
        pause "Press [Enter] to Continue..."
}


function UnTarGZ {
        #---------------------------------------
        # Desempacota ficheiros do tipo
        # .tar ou do tipo .tar.gz
        #---------------------------------------
        clear
        if [ -z "$2" ]; then
                echo "� preciso especificar o nome do FICHEIRO, assim:"
                echo "Example .tar: ${ScriptTnamE} sis_ut ficheiro.tar /directory/complete"
                echo "Example .tar.gz: ${ScriptTnamE} sis_utgz ficheiro.tar.gz /directory/complete"
                echo
                exit 0
        fi
        echo
        echo "Descompactando ficheiros..."
        echo

        cd "$3" ||  { LIB::cd_error_message "$3" "2"; exit 1; }
        case "$1" in
                sis_ut)
                        /bin/tar xvf "$2" ./*
                        ;;
                sis_utgz)
                        /bin/tar xzvf "$2" ./*
                        ;;
        esac

        echo
        echo "---------------------"
        pause "Press [Enter] to Continue..."
}


function FtpVerActividade {
        #---------------------------------------
        # Verifica no /var/log/messages
        # a actividade do FTP
        #---------------------------------------
        local nomeServo
        local varz
        local vart
        local VARX
        local CONTROLAisto
        local IP
        local IP2
        local TEMPFTP


        clear
        echo
        echo "FTP Ver Actividade..."
        echo

        nomeServo=`hostname`
        varz=`date -d'now-1 hours' +'%b %_d %H'`
        vart=`date -d'now-1 hours' +"%Hh,%_d %b"`
        VARX=$( grep -i "${varz}" /var/log/messages | grep -i "pure-ftpd" | grep -Piv "service__auth__ftpd" | grep -Piv "127.0.0.1"  > /home/_src/temp.1.ftp_activity.log )
        CONTROLAisto="0"
        echo "" > /home/_src/temp.2.ftp_activity.log
        while read line; do
                IP=`echo $line | awk -F")" '{print $1}' | awk -F"@" '{print $NF}'`
                IP2=`/usr/bin/geoiplookup -f /usr/local/apache/conf/modsec_rules/GeoLiteCity.dat ${IP} | cut -f2 -d ',' | cut -f2 -d ':' | sed -e 's/^[ \t]*//' | tr -d '[[:space:]]'`
                if [[ "$IP2" != "PT" && "$IP2" != "MZ" && "$IP2" != "AO" && "$IP2" != "CV" ]]; then
                        CONTROLAisto="1"
                else
                        CONTROLAisto="0"
                fi
                if [ "$CONTROLAisto" == "1" ]; then
                        echo "- (*$IP2*) $line" >> /home/_src/temp.2.ftp_activity.log
                fi
        done < "/home/_src/temp.1.ftp_activity.log"
        TEMPFTP=`cat /home/_src/temp.2.ftp_activity.log`
        if [[ $TEMPFTP != "" ]]; then
                /bin/mailx -s "FTP Activity on ${nomeServo} at ${vart}" ${EMAIL_de_ENVIO} < /home/_src/temp.2.ftp_activity.log
        fi
        rm -f /home/_src/temp.1.ftp_activity.log
        rm -f /home/_src/temp.2.ftp_activity.log

        echo
        echo -e "... [ DONE ]"
        echo
        echo "---------------------"
        pause "Press [Enter] to Continue..."
}


function sistema:limpa_tmp {
        #---------------------------------------
        # Limpa tempor�rios do /tmp
        #---------------------------------------
        clear
        echo
        echo "Limpa tempor�rios do /tmp ..."
        echo

        find /tmp -name "cache_*" -type f -delete
        # Limpa ficheiros com mais de 2 dias
        find /tmp -name "sess_*" -type f -mtime +2 -delete
        find /tmp -name ".spamassassin*" -type f -delete
        find /tmp -name "horde_cache_gc" -type f -delete
        find /tmp -name "2*" -type f -delete
        find /tmp -name "fcgid.tmp*" -type f -delete
        find /tmp -name "impatt*" -type f -delete
        # Limpa ficheiros com 1 hora ( 60 segundos x 60 minutos = 360 = +360 )
        find /tmp/SecUploadDir -name "2*" -type f -mmin +360 -delete

        echo
        echo "... [ DONE ]"
        echo
        echo "---------------------"
        pause "Press [Enter] to Continue..."
}


function sistema:HDSentinel {
        #---------------------------------------
        # Instala o HDSentinel
        #---------------------------------------
        clear
        echo
        echo "Installing HD Sentinel Linux ..."
        echo

        cd /home/_src ||  { LIB::cd_error_message "/home/_src"; return; }
        wget http://www.hdsentinel.com/hdslin/hdsentinel_008_x64.zip
        unzip hdsentinel*_x64.zip
        mv HDSentinel hdsentinel
        chmod 700 hdsentinel
        mv hdsentinel /usr/sbin/
        cd /home/_src || { LIB::cd_error_message "/home/_src"; return; }
        rm -f hdsentinel*.zip
        echo
        echo "... [ DONE ]"
        echo
        echo "---------------------"
        pause "Press [Enter] to Continue..."
}


function apache:limpa_logs_todos {
        #---------------------------------------
        # Limpa /usr/local/apache/logs/error_log
        # Limpa /usr/local/apache/logs/modsec_audit.log
        #---------------------------------------
        clear
        echo
        echo "Limpando logs do apache ..."
        echo
        echo "">/usr/local/apache/logs/error_log
        echo "">/usr/local/apache/logs/modsec_audit.log

        echo "... [ DONE ]"
        echo
        echo "---------------------"
        pause "Press [Enter] to Continue..."
}


function apache:limpa_logs_error_log {
        #---------------------------------------
        # Limpa /usr/local/apache/logs/error_log
        #---------------------------------------
        clear
        echo
        echo "Limpando error_log do apache ..."
        echo
        echo "">/usr/local/apache/logs/error_log

        echo "... [ DONE ]"
        echo
        echo "---------------------"
        pause "Press [Enter] to Continue..."
}


function apache:limpa_logs_modsec_audit {
        #---------------------------------------
        # Limpa /usr/local/apache/logs/modsec_audit.log
        #---------------------------------------
        clear
        echo
        echo "Limpando modsec_audit.log do apache ..."
        echo
        echo "">/usr/local/apache/logs/modsec_audit.log

        echo "... [ DONE ]"
        echo
        echo "---------------------"
        pause "Press [Enter] to Continue..."
}


function cloudlinux:mysql-governor {
        #---------------------------------------
        # Instala o MYSQL Governor do CloudLinux
        #---------------------------------------
        clear
        echo
        echo "Installing CloudLinux MySQL Governor ..."
        echo

        yum install governor-mysql --enablerepo=cloudlinux-updates-testing -y
        /usr/share/lve/dbgovernor/db-select-mysql --mysql-version=mariadb100
        /usr/share/lve/dbgovernor/mysqlgovernor.py --install-beta
        replace '<lve use="abusers"/>' '<lve use="off"/>' -- /etc/container/mysql-governor.xml
        replace '<statistic mode="on"/>' '<statistic mode="off"/>' -- /etc/container/mysql-governor.xml
        /etc/init.d/db_governor restart
        mysql_upgrade --force
        echo
        echo "... [ DONE ]"
        echo
        echo "---------------------"
        pause "Press [Enter] to Continue..."
}


function CRON:actividade_files_HOUR {
        #---------------------------------------
        # Ve a Actividade de ficheiros
        # no /public_html
        #---------------------------------------
        local nomeServo
        local VARX
        local TEMPFTP

        clear
        echo
        echo "Files Ver Actividade..."
        echo

        nomeServo=$(hostname)
        vart=$(date -d'now-1 hours' +"%Hh,%_d %b")
        #-o -mmin -70 -type f
        VARX=$( find -L /home/*/public_html -cmin -70 -type f | grep -Piv "/(?:[0-9a-f]{5})" | grep -Piv "/error_log" | grep -Piv "sess_" | grep -Piv "/mage---*" | grep -Piv "/cache(-|_)(?:[0-9a-f]{5})" | grep -Piv "/(css|js)(-|_)(?:[0-9a-f]{5})" | grep -Piv "(?:[0-9a-f]{5}).*.(php|tpl|txt|cache|html)" | grep -Piv "/%%.*.(php|tpl)" | grep -Piv ".(ftpquota|boost|md|db|xpa|txt|old|gzip|html_gzip|touch|xml|css|log|meta|ini|gz|cache|expire|json|lock|info|pdf|doc|dox|xls|xlsx|woff2|svg|ttf|eot|csv|DS_Store|mo|po|config|autoclean)$" | grep -Piv "/jwsig_cache_(?:[0-9a-f]{5})" | grep -Piv "/cache/k2.items.cache." | grep -Piv "~~~~_" | grep -Piv "cache.product.total." | grep -Piv "/jwsigpro_cache_.*.(jpg|png)" | grep -Piv "/logs/error.php" | grep -Piv "/(cache|wfcache)/.*.html" | grep -Piv "/configCache.php"  > /home/_src/temp.1.files_activity.log )
        TEMPFTP=$(cat /home/_src/temp.1.files_activity.log)
        if [[ $TEMPFTP != "" ]]; then
                /bin/mailx -s "FILES Activity on ${nomeServo} at ${vart}" "${EMAIL_de_ENVIO}" < /home/_src/temp.1.files_activity.log
        fi
        rm -f /home/_src/temp.1.files_activity.log

        echo
        echo -e "... [ DONE ]"
        echo
        echo "---------------------"
        pause "Press [Enter] to Continue..."
}

#    *********************************************************************************************
#    | SECTION:SISTEMA -> END
#    .................................................................
