#!/usr/bin/env bash
#Copyright (c) 2022 https://dcc.airjoni.xyz

#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option)
# any later version. See the included license.txt for futher details.
#***-------------------------------------------------------------------------------------------***

###- The FULL PATH of the script
Script_FUll_Path=$(pwd)
export Script_FUll_Path

###- read all variables and configurations
source "$Script_FUll_Path"/_dcc.f__init__.sh
source "$Script_FUll_Path"/_dcc.f__init1__.sh
source "$Script_FUll_Path"/_dcc.f__init2__.sh
source "$Script_FUll_Path"/_dcc.f_sistema_.sh
source "$Script_FUll_Path"/_dcc.f_backups_.sh
source "$Script_FUll_Path"/_dcc.f_seguranca_.sh
source "$Script_FUll_Path"/_dcc.f_cpanel_.sh
source "$Script_FUll_Path"/_dcc.f_nginx_.sh
source "$Script_FUll_Path"/_dcc.f_varnish_.sh
source "$Script_FUll_Path"/_dcc.f_bd_.sh
source "$Script_FUll_Path"/_dcc.f_menus_.sh

#***----------------------------------------------***
#    Check if everything is installed correctly
#    and clean all files that are not needed anymore
#***----------------------------------------------***
PMODULES
GEOIP1st
CPULIMIT
RSYNC
DIALOGx
CHECK_DIRECTORIAS
LIMPAoQueEuQuiser

#***----------------------------------------------***
#    The MAIN Program
#***----------------------------------------------***
case "$1" in
        sis_perl)
                PMODULES
                exit 0
                ;;
        sis_geoip_u)
                GEOIP
                exit 0
                ;;
        backup_user)
                BACKUP "$1" "$2"
                exit 0
                ;;
        -4)
                BACKUPnas1 "$1" "$2" "$3"
                exit 0
                ;;
        -5)
                BACKUPdiario "$1"
                exit 0
                ;;
        backup_cp_c)
                BACKUPCPanelCheck
                exit 0
                ;;
        backup_cp_nfs)
                BACKUPCPanelNFSCopy "$1" "$2"
                exit 0
                ;;
        sis_puser)
                CORRIGE "$1" "$2"
                exit 0
                ;;
        sis_puser_dir)
                CORRIGE2 "$1" "$2" "$3"
                exit 0
                ;;
        sis_ptodos)
                CorrigeTodos
                exit 0
                ;;
        sis_php_del)
                PHPfcgiKillOrphan "$1"
                exit 0
                ;;
        nginx_i)
                nginx::install
                exit 0
                ;;
        nginx_rpaf)
                nginx::rpaf_module_generator
                exit 0
                ;;
        nginx_vhosts)
                NGINXvhostsFULLcache "$2"
                exit 0
                ;;
        nginx_vhost_hook | nginx_vh)
                NGINXhooksGeraVhosts "$2" "$3" "$4" "$5"
                exit 0
                ;;
        nginx_ru)
                nginx::reset_user_data
                exit 0
                ;;
        -12)
                NGINXvhostsSingle "$1" "$2"
                exit 0
                ;;
        varnish_vhosts)
                VARNISHvhosts "$1"
                exit 0
                ;;
        mysql_o)
                MYSQLoptimiza "$1"
                exit 0
                ;;
        seg_clamav_u)
                antivirusUPDATE
                exit 0
                ;;
        seg_clamav_c)
                antivirusUPDATEclientes
                exit 0
                ;;
        virus_check)
                antivirusCHECKsingle "$1" "$2"
                exit 0
                ;;
        virus_check_full)
                antivirusCHECKfull
                exit 0
                ;;
        virus_check_daily)
                antivirusCHECKfullDiario
                exit 0
                ;;
        virus_undelete)
                antivirusRECUPERAsingle
                exit 0
                ;;
        virus_undelete_full)
                antivirusRECUPERAfull
                exit 0
                ;;
        virus_undelete_daily)
                antivirusRECUPERAfullDAILY
                exit 0
                ;;
        modsec_logs)
                modsecurityAPAGAR
                exit 0
                ;;
        modsec_u)
                modsecurityUPDATE
                exit 0
                ;;
        modsec_ci)
                modsecurity::comodo_install
                exit 0
                ;;
        modsec_clua)
                modsecurity::comodo_activate_LUA
                exit 0
                ;;
        -19)
                BACKUPnas2 $1
                exit 0
                ;;
        -20)
                BACKUPnas2GET1 $1 $2
                exit 0
                ;;
        -21)
                BACKUPnas2GETAll $1
                exit 0
                ;;
        seg_maldet_u)
                maldetUPDATE
                exit 0
                ;;
        sis_inode)
                INODEAbuse $1 $2
                exit 0
                ;;
        nginx_cflare)
                nginx::cloudflare_module_generator
                exit 0
                ;;
        nginx_up)
                NGINXupstream
                exit 0
                ;;
        seg_maldet_ino)
                maldetUpdateINOTIFY
                exit 0
                ;;
        seg_maldet_i)
                MaldetInstall
                exit 0
                ;;
        sis_tmp)
                sistema:limpa_tmp
                exit 0
                ;;
        nginx_u)
                nginx::update
                exit 0
                ;;
        nginx_c)
                nginx::compile
                exit 0
                ;;
        nginx_config)
                nginx::copia_configs
                exit 0
                ;;
        nginx_tar)
                nginx::cria_tar
                exit 0
                ;;
        modsec_tar)
                modsecurityTAR
                exit 0
                ;;
        cp_hooks_i)
                CpanelHooksInstall $2
                exit 0
                ;;
        cp_hooks_o)
                CpanelHooksObrigatorios
                exit 0
                ;;
        sis_untar)
                UnTarGZ ${Script_FUll_Path} $1 $2
                exit 0
                ;;
        sis_untargz)
                UnTarGZ ${Script_FUll_Path} $1 $2
                exit 0
                ;;
        sis_tar)
                TarGZ ${Script_FUll_Path} $1 $2
                exit 0
                ;;
        sis_targz)
                TarGZ "${Script_FUll_Path}" "$1" "$2"
                exit 0
                ;;
        sis_ftpa)
                FtpVerActividade
                exit 0
                ;;
        sis_ac)
                apache:limpa_logs_todos
                exit 0
                ;;
        sis_ae)
                apache:limpa_logs_error_log
                exit 0
                ;;
        sis_am)
                apache:limpa_logs_modsec_audit
                exit 0
                ;;
        sis_csf)
                configserver::csf_install
                exit 0
                ;;
        sis_mq)
                configserver::mail_queues_install
                exit 0
                ;;
        sis_mm)
                configserver::mail_manager_install
                exit 0
                ;;
        sis_msm)
                configserver::modsec_manager_install
                exit 0
                ;;
        sis_filesa)
                CRON:actividade_files_HOUR
                exit 0
                ;;
        sis_hds)
                sistema:HDSentinel
                exit 0
                ;;
        cloud_mg)
                cloudlinux:mysql-governor
                exit 0
                ;;
        -m | menu)
                #########################################################
                # MENU
                #########################################################
                MENUprincipal
                #########################################################
                ;;
        *)
                clear
                echo
                cecho "$PROGRAMANOME $SCRIPT_VERSION" $boldyellow
                cecho "$COPYRIGHT by $SCRIPT_MODIFICATION_AUTHOR" $boldgreen
                cecho "Web site: $SCRIPT_URL" $boldgreen
                echo
                echo  "DataSource Software Install comes with ABSOLUTELY NO WARRANTY."
                echo  "This is free software, and you are welcome to redistribute it "
                echo  "under certain conditions."
                echo
                echo  " Usage: $(basename "$0") OPTION"
                echo
                echo  " Options:"
                echo  "  -m                         Para trabalhar apenas via MENU"
                echo  "  -u                         Update Geral do Script"
                echo  "  ----------------------------------------------------"
                cecho "     BACKUPS" $boldred
                cecho  "    -------------------------" $boldred
                echo  "  backup_user USER           Copia o backup do USER para o directorio dele"
                echo  "  -4 CHAVE DESTINO           Copia os Backups para o NAS v1 (RSYNC)"
                echo  "  -19                        Copia os Backups para o NAS v2 (FTP)"
                echo  "  -20 DIR/FILE               Retira um backup do NAS, exemplo:"
                echo  "                              daily/ficheiro.tar"
                echo  "  -21                        Retira todos os backups do NAS do daily"
                echo  "  -5 DESTINO USER PASS DIAS  Cria os BACKUPS DIARIOS"
                echo  "  backup_cp_c                Verifica backups cpanel e se estiverem em HANG"
                echo  "                              envia email a avisar e apaga processo"
                echo  "  backup_cp_nfs DATA         Copia backups para o NFS Share /home/1backups"
                echo  "                              DATA - Se quiser colocar data, tipo YYY-MM-DD"
                echo  "  ----------------------------------------------------"
                cecho "     SISTEMA" $boldred
                cecho  "    -------------------------" $boldred
                echo  "  sis_perl                   Instalar Perl Modules para o Nginx"
                echo  "  sis_geoip_u                Update do GEO IP Database para o ModSecurity"
                echo  "  sis_puser USERNAME         Permissoes do user USERNAME"
                echo  "  sis_puser_dir USERNAME DIRECTORIO"
                echo  "                              Permissoes do user USERNAME no DIRECTORIO"
                echo  "  sis_ptodos                 Permissoes todos Users corrige"
                echo  "  sis_php_del                Elimina PHP FCGI Orphan Processes"
                echo  "  sis_tmp                    Limpa temporarios do /tmp"
                echo  "  sis_inode                  Utilizadores com mais de 250.000 ficheiros"
                echo  "  sis_untar FICHEIRO         Desempacota ficheiros TAR, FICHEIRO = Nome"
                echo  "  sis_untargz FICHEIRO       Desempacota ficheiros TAR.GZ, FICHEIRO = Nome"
                echo  "  sis_tar FICHEIRO           Empacota ficheiros criando o FICHEIRO.tar"
                echo  "  sis_targz FICHEIRO         Empacota ficheiros criando o FICHEIRO.tar.gz"
                echo  "  sis_ftpa                   Ve a Actividade de FTP"
                echo  "  sis_filesa                 Ve a Actividade de ficheiros no /public_html"
                echo  "  sis_csf                    Instala ConfigServer CSF Firewall"
                echo  "  sis_mq                     Instala ConfigServer Mail Queues"
                echo  "  sis_mm                     Instala ConfigServer Mail Manager"
                echo  "  sis_msm                    Instala ConfigServer ModSEC Manager"
                echo  "  sis_hds                    Instala o HD Sentinel Linux"
                echo  "  sis_ac                     Limpa os logs todos do apache"
                echo  "  sis_ae                     Limpa o log error_log do apache"
                echo  "  sis_am                     Limpa o log modsec_audit.log do apache"
                echo  "  ----------------------------------------------------"
                cecho "     CLOUDLINUX" "$boldred"
                cecho  "    -------------------------" $boldred
                echo  "  cloud_mg                   Instala MARIADB"
                echo  "  ----------------------------------------------------"
                cecho "     CPANEL" $boldred
                cecho  "    -------------------------" $boldred
                echo  "  cp_hooks_i HOOK            Instala Hooks do cpanel"
                echo  "                              HOOK = Vazio Instala todos"
                echo  "  cp_hooks_o                 Instala Hooks OBRIGATORIOS se tiver NginX"
                echo  "  ----------------------------------------------------"
                cecho "     NGINX" $boldred
                cecho  "    -------------------------" $boldred
                echo  "  nginx_i                    INSTALA o Nignx de Raiz"
                echo  "  nginx_upstream             UPSTREAM IP's para os sites"
                echo  "  nginx_rpaf                 RPAF e IP's para o Apache 2.2+"
                echo  "  nginx_cflare               CLOUDFLARE e IP's para o Apache 2.4+"
                echo  "  nginx_vhosts               (Re)Cria /etc/nginx/vhosts"
                echo  "  nginx_vh USER A B C        (Re)Cria vhosts para o USER"
                echo  "                               USER = nome do utilizador"
                echo  "                               A = CACHE: 1 ou 0"
                echo  "                               B = X_Frame_Options: 1 ou 0"
                echo  "                               C = HSTS: 1 ou 0"
                echo  "  -12 VHOST                  (Re)Cria o conteudo do VHOST especificado"
                echo  "  nginx_vhost_hook USER      (Re)Cria o conteudo dos vhosts do USER"
                echo  "  nginx_u                    update de /root/nginx"
                echo  "  nginx_c                    (Re)Compila o Nginx"
                echo  "  nginx_config               Actualiza Configs do Nginx"
                echo  "  nginx_ru                   Faz reset ao /etc/nginx/userdata"
                echo  "  nginx_tar                  Empacota Source Nginx"
                echo  "  ----------------------------------------------------"
                cecho "     VARNISH" $boldred
                cecho  "    -------------------------" $boldred
                echo  "  varnish_vhosts             (Re)Cria vhosts configuration"
                echo  "  ----------------------------------------------------"
                cecho "     MYSQL" $boldred
                cecho  "    -------------------------" $boldred
                echo  "  mysql_o                    Optimiza Todo"
                echo  "  ----------------------------------------------------"
                cecho "     MODSECURITY" $boldred
                cecho  "    -------------------------" $boldred
                echo  "  modsec_logs                ModSecurity Apagar Logs Antigos"
                echo  "  modsec_u                   ModSecurity Update das Regras"
                echo  "  modsec_tar                 Empacota Source modsecurity"
                echo  "  modsec_ci                  COMODO Firewall Install"
                echo  "  modsec_clua                Activa o LUA no COMODO Firewall"
                echo  "  ----------------------------------------------------"
                cecho "     SEGURANCA" $boldred
                cecho  "    -------------------------" $boldred
                echo  "  seg_clamav_u               ClamAV Update BDs do ClamAV para"
                echo  "                              armazenar em https://dcc.hocnet.pt"
                echo  "  seg_clamav_c               ClamAV Update BDs do ClamAV nos"
                echo  "                              servidores clientes"
                echo  "  virus_check DIR            Verifica virus no directorio DIR"
                echo  "  virus_check_full           Verifica virus todos alojamentos"
                echo  "  virus_check_daily          Verifica virus todos alojamentos"
                echo  "                              com datas maximo 2 dias"
                echo  "  virus_undelete             Recupera FALSO POSITIVOS do"
                echo  "                              verifica virus no directorio DIR"
                echo  "  virus_undelete_full        Recupera FALSO POSITIVOS do"
                echo  "                              verifica virus todos alojamentos"
                echo  "  virus_undelete_daily       Recupera FALSO POSITIVOS do"
                echo  "                              verifica virus Diario"
                echo  "  seg_maldet_u               MalDet Update das Definicoes"
                echo  "  seg_maldet_ino             Update diario do INOTIFY do MALDET"
                echo  "  seg_maldet_i               Instalar o MALDET"
                echo
                echo
                exit 0
                ;;
esac
#***-------------------------------------------------------------------------------------------***
