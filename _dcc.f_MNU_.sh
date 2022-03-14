#!/usr/bin/env bash
#Copyright (c) 2008-2012 http://datasource.pt/

#  *********************************************************************************************
#  | SECTION:BASES DE DADOS -> BEGIN
#  .................................................................

function MENUprincipal {
        #---------------------------------------
        # MENU PRINCIPAL DO SISTEMA
        #---------------------------------------
        MENUE=$(
                dialog \
                        --clear \
                        --stdout \
                        --begin 2 2 \
                        --backtitle "$NOMEFINAL" \
                        --title 'MENU Principal' \
                        --no-cancel \
                        --menu "Escolha Opcao:" 0 0 0 \
                        1 'INSTALL - Perl Modules para o NGinX' \
                        2 'UPDATE  - GEOIP Database ModSecurity' \
                        3 'BACKUP - Copiar o backup de um USER para o directorio dele' \
                        4 'UTILITIES - FIX Permissoes de um User (corrige)' \
                        5 'UTILITIES - Optimiza o MYSQL Todo' \
                        0 'Exit'
        )

        case "$MENUE" in
                1)
                        PMODULES
                        MENUprincipal
                        ;;
                2)
                        GEOIP
                        MENUprincipal
                        ;;
                3)
                        BACKUP
                        MENUprincipal
                        ;;
                4)
                        CORRIGE
                        MENUprincipal
                        ;;
                5)
                        MYSQLoptimiza
                        MENUprincipal
                        ;;
                0)
                        clear
                        cecho "$NOMEF" $boldyellow
                        echo ""
                        echo "--exit"
                        exit 0
                        ;;
        esac
}

#    *********************************************************************************************
#    | SECTION:BASES DE DADOS -> END
#    .................................................................
