#Copyright (c) 2008-2012 http://datasource.pt/ 

#  *********************************************************************************************
#  | SECTION:CPANEL -> BEGIN
#  .................................................................

function CpanelHooksInstall {
#----------------------------------------------------
# Instalar os Hooks necessarios para o CPanel
#----------------------------------------------------
    clear

    if [ "$1" == "hetzner_b" ]; then
        echo
        echo "CPanel HetZner BACKUP Hook Install..."
        echo

        #_________________________
        # declaracao de variaveis necessarias
        CHECK_HOOK_INSTALL=$( /usr/local/cpanel/bin/manage_hooks list | grep -i /scripts/_dcc.CP.hook.postcpbackup.sh )

        wget --no-check-certificate -O /home/_src/_dcc.CP.hook.postcpbackup.sh https://dcc.hocnet.pt/_dcc/_CPanel_Hooks/_dcc.CP.hook.postcpbackup.sh
        if [ "$?" -eq "0" ]; then
            cd /home/_src
            if [ -f "/scripts/_dcc.CP.hook.postcpbackup.sh" ]; then
               echo "" >/scripts/_dcc.CP.hook.postcpbackup.sh
            else
                touch /scripts/_dcc.CP.hook.postcpbackup.sh
            fi
            #--
            if [ "$CHECK_HOOK_INSTALL" == "" ]; then
                /usr/local/cpanel/bin/manage_hooks add script /scripts/_dcc.CP.hook.postcpbackup.sh --category=System --event=Backup --stage=post --manual  > /dev/null 2>&1
            fi
            #--
            sleep 5
            mv -f /home/_src/_dcc.CP.hook.postcpbackup.sh /scripts/_dcc.CP.hook.postcpbackup.sh  > /dev/null 2>&1
            chown root.root /scripts/_dcc.CP.hook.postcpbackup.sh
            chmod 0700 /scripts/_dcc.CP.hook.postcpbackup.sh
        fi
    fi

    #_________________________
    echo
    echo "... [ DONE ]"
    echo
    echo "---------------------"
    pause "Press [Enter] to Continue..."
}


function CpanelHooksObrigatorios {
#----------------------------------------------------
# Instalar os Hooks necessarios para o CPanel 
# Obrigatorios
#----------------------------------------------------
    clear
    echo
    echo "CPanel Hook Install..."
    echo

    #_________________________
	# declaracao de variaveis necessarias
    CHECK_HOOK_POSTWWWACCT=$( /usr/local/cpanel/bin/manage_hooks list | grep -i _dcc.CP.hook.postwwwacct )
    CHECK_HOOK_PREKILLACCT=$( /usr/local/cpanel/bin/manage_hooks list | grep -i _dcc.CP.hook.prekillacct )

    wget --no-check-certificate -O /home/_src/_dcc.CP.hook.postwwwacct https://dcc.hocnet.pt/_dcc/_CPanel_Hooks/_dcc.CP.hook.postwwwacct >/dev/null 2>&1
    if [ "$?" -eq "0" ]; then
        cd /home/_src
        if [ -f "/scripts/_dcc.CP.hook.postcpbackup.sh" ]; then
            echo "" >/scripts/_dcc.CP.hook.postwwwacct
        else
            touch /scripts/_dcc.CP.hook.postwwwacct
        fi
        #--
        if [ "$CHECK_HOOK_POSTWWWACCT" == "" ]; then
            /usr/local/cpanel/bin/manage_hooks add script /scripts/_dcc.CP.hook.postwwwacct --category Whostmgr --event Accounts::Create --stage post --manual >/dev/null 2>&1
            sleep 5
        fi
        #--
        mv -f /home/_src/_dcc.CP.hook.postwwwacct /scripts/_dcc.CP.hook.postwwwacct  > /dev/null 2>&1
        chown root.root /scripts/_dcc.CP.hook.postwwwacct
        chmod 0700 /scripts/_dcc.CP.hook.postwwwacct
    fi
	
    wget --no-check-certificate -O /home/_src/_dcc.CP.hook.prekillacct https://dcc.hocnet.pt/_dcc/_CPanel_Hooks/_dcc.CP.hook.prekillacct >/dev/null 2>&1
    if [ "$?" -eq "0" ]; then
        cd /home/_src
        if [ -f "/scripts/_dcc.CP.hook.prekillacct" ]; then
            echo "" >/scripts/_dcc.CP.hook.prekillacct
        else
            touch /scripts/_dcc.CP.hook.prekillacct
        fi
        #--
        if [ "$CHECK_HOOK_PREKILLACCT" == "" ]; then
            /usr/local/cpanel/bin/manage_hooks add script /scripts/_dcc.CP.hook.prekillacct --category Whostmgr --event Accounts::Remove --stage pre --manual >/dev/null 2>&1
            sleep 5
        fi
        #--
        mv -f /home/_src/_dcc.CP.hook.prekillacct /scripts/_dcc.CP.hook.prekillacct  > /dev/null 2>&1
        chown root.root /scripts/_dcc.CP.hook.prekillacct
        chmod 0700 /scripts/_dcc.CP.hook.prekillacct
    fi

    wget --no-check-certificate -O /home/_src/_incron_NginX https://dcc.hocnet.pt/_dcc/_CPanel_Hooks/_incron_NginX >/dev/null 2>&1
    if [ "$?" -eq "0" ]; then
        cd /home/_src
        if [ -f "/scripts/_incron_NginX" ]; then
            echo "" >/scripts/_incron_NginX
        else
            touch /scripts/_incron_NginX
        fi
        #--
        mv -f /home/_src/_incron_NginX /scripts/_incron_NginX  > /dev/null 2>&1
        chown root.root /scripts/_incron_NginX
        chmod 0700 /scripts/_incron_NginX
        #--
        if [ ! -f "/var/spool/incron/root" ]; then
            echo "#NGinX_Hooks#" > /var/spool/incron/root
            echo "/var/cpanel/users IN_MODIFY,IN_NO_LOOP /scripts/_incron_NginX $#" >> /var/spool/incron/root
            echo "#NGinX_Hooks#" >> /var/spool/incron/root
            /etc/init.d/incrond restart
        fi
        #--
    fi

    #_________________________
	# Install /usr/local/cpanel/hooks/addondomain/
    wget --no-check-certificate -O /home/_src/addaddondomain https://dcc.hocnet.pt/_dcc/_CPanel_Hooks/usr_local_cpanel_hooks/addondomain/addaddondomain >/dev/null 2>&1
    if [ "$?" -eq "0" ]; then
        cd /home/_src
        mv -f /home/_src/addaddondomain /usr/local/cpanel/hooks/addondomain/addaddondomain  > /dev/null 2>&1
        chown root.root /usr/local/cpanel/hooks/addondomain/addaddondomain
        chmod 0755 /usr/local/cpanel/hooks/addondomain/addaddondomain
    fi
    wget --no-check-certificate -O /home/_src/deladdondomain https://dcc.hocnet.pt/_dcc/_CPanel_Hooks/usr_local_cpanel_hooks/addondomain/deladdondomain >/dev/null 2>&1
    if [ "$?" -eq "0" ]; then
        cd /home/_src
        mv -f /home/_src/deladdondomain /usr/local/cpanel/hooks/addondomain/deladdondomain  > /dev/null 2>&1
        chown root.root /usr/local/cpanel/hooks/addondomain/deladdondomain
        chmod 0755 /usr/local/cpanel/hooks/addondomain/deladdondomain
    fi

    #_________________________
	# Install /usr/local/cpanel/hooks/park/
    wget --no-check-certificate -O /home/_src/park https://dcc.hocnet.pt/_dcc/_CPanel_Hooks/usr_local_cpanel_hooks/park/park >/dev/null 2>&1
    if [ "$?" -eq "0" ]; then
        cd /home/_src
        mv -f /home/_src/park /usr/local/cpanel/hooks/park/park  > /dev/null 2>&1
        chown root.root /usr/local/cpanel/hooks/park/park
        chmod 0755 /usr/local/cpanel/hooks/park/park
    fi
    wget --no-check-certificate -O /home/_src/unpark https://dcc.hocnet.pt/_dcc/_CPanel_Hooks/usr_local_cpanel_hooks/park/unpark >/dev/null 2>&1
    if [ "$?" -eq "0" ]; then
        cd /home/_src
        mv -f /home/_src/unpark /usr/local/cpanel/hooks/park/unpark  > /dev/null 2>&1
        chown root.root /usr/local/cpanel/hooks/park/unpark
        chmod 0755 /usr/local/cpanel/hooks/park/unpark
    fi

    #_________________________
	# Install /usr/local/cpanel/hooks/subdomain/
    wget --no-check-certificate -O /home/_src/addsubdomain https://dcc.hocnet.pt/_dcc/_CPanel_Hooks/usr_local_cpanel_hooks/subdomain/addsubdomain >/dev/null 2>&1
    if [ "$?" -eq "0" ]; then
        cd /home/_src
        mv -f /home/_src/addsubdomain /usr/local/cpanel/hooks/subdomain/addsubdomain  > /dev/null 2>&1
        chown root.root /usr/local/cpanel/hooks/subdomain/addsubdomain
        chmod 0755 /usr/local/cpanel/hooks/subdomain/addsubdomain
    fi
    wget --no-check-certificate -O /home/_src/delsubdomain https://dcc.hocnet.pt/_dcc/_CPanel_Hooks/usr_local_cpanel_hooks/subdomain/delsubdomain >/dev/null 2>&1
    if [ "$?" -eq "0" ]; then
        cd /home/_src
        mv -f /home/_src/delsubdomain /usr/local/cpanel/hooks/subdomain/delsubdomain > /dev/null 2>&1
        chown root.root /usr/local/cpanel/hooks/subdomain/delsubdomain
        chmod 0755 /usr/local/cpanel/hooks/subdomain/delsubdomain
    fi

    #_________________________
	# Install /scripts/after_apache_make_install
    wget --no-check-certificate -O /home/_src/after_apache_make_install https://dcc.hocnet.pt/_dcc/_CPanel_Hooks/after_apache_make_install >/dev/null 2>&1
    if [ "$?" -eq "0" ]; then
        cd /home/_src
        mv -f /home/_src/after_apache_make_install /scripts/after_apache_make_install  > /dev/null 2>&1
        chown root.root /scripts/after_apache_make_install
        chmod 0755 /scripts/after_apache_make_install
    fi

    #_________________________
	# Install /scripts/preeasyapache
    wget --no-check-certificate -O /home/_src/preeasyapache https://dcc.hocnet.pt/_dcc/_CPanel_Hooks/preeasyapache >/dev/null 2>&1
    if [ "$?" -eq "0" ]; then
        cd /home/_src
        mv -f /home/_src/preeasyapache /scripts/preeasyapache  > /dev/null 2>&1
        chown root.root /scripts/preeasyapache
        chmod 0755 /scripts/preeasyapache
    fi


    #_________________________
    echo
    echo "... [ DONE ]"
    echo
    echo "---------------------"
    pause "Press [Enter] to Continue..."
}

#    *********************************************************************************************
#    | SECTION:CPANEL -> END
#    .................................................................
