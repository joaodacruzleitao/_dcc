#!/usr/bin/env bash
#Copyright (c) 2008-2012 http://datasource.pt/

#  *********************************************************************************************
#  | SECTION:BASES DE DADOS -> BEGIN
#  .................................................................

function MYSQLoptimiza {
        #---------------------------------------
        # Optimiza todas as bases de dados
        # do MYSQL
        #---------------------------------------
        DIAS1=$(date +%d)
        DIAS2="28"
        clear
        echo
        cecho "A Optimizar o MYSQL Todo ..." $boldyellow
        echo
        #---
        if [ "$1" == "mysql_o" ]; then
                /bin/nice -n 8 /usr/bin/mysqlcheck --defaults-file=/root/.my.cnf --auto-repair -Aa
                if [ "${DIAS1}" == "${DIAS2}" ]; then
                        /usr/bin/mysql-defragger --myisam --optimize
                fi
                echo
                echo -e "... $GREEN[ DONE ]$RESET"
                echo
                echo "---------------------------"
                pause "Pressione [Enter] para Continuar..."
                echo
        else
                dialog --backtitle "$NOMEFINAL" --title "MySQL" --infobox "A Reparar e Analisar todas as BDs do MySQL, Aguarde..." 5 60
                /bin/nice -n 8 /usr/bin/mysqlcheck --defaults-file=/root/.my.cnf --auto-repair -Aa
                if [ "${DIAS1}" == "${DIAS2}" ]; then
                        dialog --backtitle "$NOMEFINAL" --title "MySQL" --infobox "A Optimizar todas as BDs MyISAM do MySQL, Aguarde..." 5 60
                        /usr/bin/mysql-defragger --myisam --optimize
                fi
                dialog --backtitle "$NOMEFINAL" --title "MySQL" --msgbox "Optimizacao do MYSQL Finalizado!!!!!" 6 60
                MENUprincipal
        fi
}

#    *********************************************************************************************
#    | SECTION:BASES DE DADOS -> END
#    .................................................................
