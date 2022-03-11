#!/bin/bash
#Copyright (c) 2008-2012 http://datasource.pt/ 

/usr/bin/wget --no-check-certificate https://dcc.hocnet.pt/_dcc/_dcc.v.txt -q -O /home/_src/versionu.txt >/dev/null 2>&1
if [ "$?" -ne "0" ]; then
	echo "_dcc.v.txt failed"
	exit 0
fi
VERSIONU=$( cat /home/_src/versionu.txt )
minimumsize=2
nomeServo=`hostname`
ENVIAEMAIL="0"
SENDEMAIL="1"
RESTARTCRON="1"
RESTARTCRON2="1"
TEXTOEMAIL="Relatorio"
TEXTOEMAIL+="\n============="

if [ ! -f /scripts/_dcc.v.sh ]
then
    VERSIONC="0.0"
else
    VERSIONC=$(cat /scripts/_dcc.v.sh)
fi

if [ "$VERSIONC" == "$VERSIONU" ]
then
    exit 0
else
    echo ${VERSIONU} > /scripts/_dcc.v.sh

    wget -O /scripts/_dcc.f__init__.sh.tmp --no-check-certificate https://dcc.hocnet.pt/_dcc/_dcc.f__init__.sh >/dev/null 2>&1
	if [ "$?" -ne "0" ]; then
		rm -f /scripts/_dcc.f__init__.sh.tmp
		TEXTOEMAIL+="\nDNS ERROR: Falha de resolucao de DNS!!"
		printf "$TEXTOEMAIL" | /bin/mail -s "(_dcc UPDATE) on ${nomeServo}" servidores@datasource.pt
		exit 0
	fi
    tamanho=$(du -b "/scripts/_dcc.f__init__.sh.tmp" | cut -f 1)
    if [ $tamanho -gt $minimumsize ]; then
        mv /scripts/_dcc.f__init__.sh.tmp /scripts/_dcc.f__init__.sh
        chmod 400 /scripts/_dcc.f__init__.sh
    else
        TEXTOEMAIL+="\nERROR: _dcc.f__init__.sh nao gravado"
        ENVIAEMAIL="1"
        rm -f /scripts/_dcc.f__init__.tmp
    fi


    wget -O /scripts/_dcc.f__init1__.sh.tmp --no-check-certificate https://dcc.hocnet.pt/_dcc/_dcc.f__init1__.sh >/dev/null 2>&1
	if [ "$?" -ne "0" ]; then
		rm -f /scripts/_dcc.f__init1__.sh.tmp
		TEXTOEMAIL+="\nDNS ERROR: Falha de resolucao de DNS!!"
		printf "$TEXTOEMAIL" | /bin/mail -s "(_dcc UPDATE) on ${nomeServo}" servidores@datasource.pt
		exit 0
	fi
    tamanho=$(du -b "/scripts/_dcc.f__init1__.sh.tmp" | cut -f 1)
    if [ $tamanho -gt $minimumsize ]; then
        mv /scripts/_dcc.f__init1__.sh.tmp /scripts/_dcc.f__init1__.sh
        chmod 400 /scripts/_dcc.f__init1__.sh
    else
        TEXTOEMAIL+="\nERROR: _dcc.f__init1__.sh nao gravado"
        ENVIAEMAIL="1"
        rm -f /scripts/_dcc.f__init1__.tmp
    fi


    wget -O /scripts/_dcc.f__init2__.sh.tmp --no-check-certificate https://dcc.hocnet.pt/_dcc/_dcc.f__init2__.sh >/dev/null 2>&1
	if [ "$?" -ne "0" ]; then
		rm -f /scripts/_dcc.f__init2__.sh.tmp
		TEXTOEMAIL+="\nDNS ERROR: Falha de resolucao de DNS!!"
		printf "$TEXTOEMAIL" | /bin/mail -s "(_dcc UPDATE) on ${nomeServo}" servidores@datasource.pt
		exit 0
	fi
    tamanho=$(du -b "/scripts/_dcc.f__init2__.sh.tmp" | cut -f 1)
    if [ $tamanho -gt $minimumsize ]; then
        mv /scripts/_dcc.f__init2__.sh.tmp /scripts/_dcc.f__init2__.sh
        chmod 400 /scripts/_dcc.f__init2__.sh
    else
        TEXTOEMAIL+="\nERROR: _dcc.f__init2__.sh nao gravado"
        ENVIAEMAIL="1"
        rm -f /scripts/_dcc.f__init2__.tmp
    fi


    wget -O /scripts/_dcc.f_backups_.sh.tmp --no-check-certificate https://dcc.hocnet.pt/_dcc/_dcc.f_backups_.sh >/dev/null 2>&1
	if [ "$?" -ne "0" ]; then
		rm -f /scripts/_dcc.f_backups_.sh.tmp
		TEXTOEMAIL+="\nDNS ERROR: Falha de resolucao de DNS!!"
		printf "$TEXTOEMAIL" | /bin/mail -s "(_dcc UPDATE) on ${nomeServo}" servidores@datasource.pt
		exit 0
	fi
    tamanho=$(du -b "/scripts/_dcc.f_backups_.sh.tmp" | cut -f 1)
    if [ $tamanho -gt $minimumsize ]; then
        mv /scripts/_dcc.f_backups_.sh.tmp /scripts/_dcc.f_backups_.sh
        chmod 400 /scripts/_dcc.f_backups_.sh
    else
        TEXTOEMAIL+="\nERROR: _dcc.f_backups_.sh nao gravado"
        ENVIAEMAIL="1"
        rm -f /scripts/_dcc.f_backups_.tmp
    fi


    wget -O /scripts/_dcc.f_bd_.sh.tmp --no-check-certificate https://dcc.hocnet.pt/_dcc/_dcc.f_bd_.sh >/dev/null 2>&1
	if [ "$?" -ne "0" ]; then
		rm -f /scripts/_dcc.f_bd_.sh.tmp
		TEXTOEMAIL+="\nDNS ERROR: Falha de resolucao de DNS!!"
		printf "$TEXTOEMAIL" | /bin/mail -s "(_dcc UPDATE) on ${nomeServo}" servidores@datasource.pt
		exit 0
	fi
    tamanho=$(du -b "/scripts/_dcc.f_bd_.sh.tmp" | cut -f 1)
    if [ $tamanho -gt $minimumsize ]; then
        mv /scripts/_dcc.f_bd_.sh.tmp /scripts/_dcc.f_bd_.sh
        chmod 400 /scripts/_dcc.f_bd_.sh
    else
        TEXTOEMAIL+="\nERROR: _dcc.f_bd_.sh nao gravado"
        ENVIAEMAIL="1"
        rm -f /scripts/_dcc.f_bd_.tmp
    fi


    wget -O /scripts/_dcc.f_cpanel_.sh.tmp --no-check-certificate https://dcc.hocnet.pt/_dcc/_dcc.f_cpanel_.sh >/dev/null 2>&1
	if [ "$?" -ne "0" ]; then
		rm -f /scripts/_dcc.f_cpanel_.sh.tmp
		TEXTOEMAIL+="\nDNS ERROR: Falha de resolucao de DNS!!"
		printf "$TEXTOEMAIL" | /bin/mail -s "(_dcc UPDATE) on ${nomeServo}" servidores@datasource.pt
		exit 0
	fi
    tamanho=$(du -b "/scripts/_dcc.f_cpanel_.sh.tmp" | cut -f 1)
    if [ $tamanho -gt $minimumsize ]; then
        mv /scripts/_dcc.f_cpanel_.sh.tmp /scripts/_dcc.f_cpanel_.sh
        chmod 400 /scripts/_dcc.f_cpanel_.sh
    else
        TEXTOEMAIL+="\nERROR: _dcc.f_cpanel_.sh nao gravado"
        ENVIAEMAIL="1"
        rm -f /scripts/_dcc.f_cpanel_.tmp
    fi


    wget -O /scripts/_dcc.f_menus_.sh.tmp --no-check-certificate https://dcc.hocnet.pt/_dcc/_dcc.f_menus_.sh >/dev/null 2>&1
	if [ "$?" -ne "0" ]; then
		rm -f /scripts/_dcc.f_menus_.sh.tmp
		TEXTOEMAIL+="\nDNS ERROR: Falha de resolucao de DNS!!"
		printf "$TEXTOEMAIL" | /bin/mail -s "(_dcc UPDATE) on ${nomeServo}" servidores@datasource.pt
		exit 0
	fi
    tamanho=$(du -b "/scripts/_dcc.f_menus_.sh.tmp" | cut -f 1)
    if [ $tamanho -gt $minimumsize ]; then
        mv /scripts/_dcc.f_menus_.sh.tmp /scripts/_dcc.f_menus_.sh
        chmod 400 /scripts/_dcc.f_menus_.sh
    else
        TEXTOEMAIL+="\nERROR: _dcc.f_menus_.sh nao gravado"
        ENVIAEMAIL="1"
        rm -f /scripts/_dcc.f_menus_.tmp
    fi


    wget -O /scripts/_dcc.f_nginx_.sh.tmp --no-check-certificate https://dcc.hocnet.pt/_dcc/_dcc.f_nginx_.sh >/dev/null 2>&1
	if [ "$?" -ne "0" ]; then
		rm -f /scripts/_dcc.f_nginx_.sh.tmp
		TEXTOEMAIL+="\nDNS ERROR: Falha de resolucao de DNS!!"
		printf "$TEXTOEMAIL" | /bin/mail -s "(_dcc UPDATE) on ${nomeServo}" servidores@datasource.pt
		exit 0
	fi
    tamanho=$(du -b "/scripts/_dcc.f_nginx_.sh.tmp" | cut -f 1)
    if [ $tamanho -gt $minimumsize ]; then
        mv /scripts/_dcc.f_nginx_.sh.tmp /scripts/_dcc.f_nginx_.sh
        chmod 400 /scripts/_dcc.f_nginx_.sh
    else
        TEXTOEMAIL+="\nERROR: _dcc.f_nginx_.sh nao gravado"
        ENVIAEMAIL="1"
        rm -f /scripts/_dcc.f_nginx_.tmp
    fi


    wget -O /scripts/_dcc.f_seguranca_.sh.tmp --no-check-certificate https://dcc.hocnet.pt/_dcc/_dcc.f_seguranca_.sh >/dev/null 2>&1
	if [ "$?" -ne "0" ]; then
		rm -f /scripts/_dcc.f_seguranca_.sh.tmp
		TEXTOEMAIL+="\nDNS ERROR: Falha de resolucao de DNS!!"
		printf "$TEXTOEMAIL" | /bin/mail -s "(_dcc UPDATE) on ${nomeServo}" servidores@datasource.pt
		exit 0
	fi
    tamanho=$(du -b "/scripts/_dcc.f_seguranca_.sh.tmp" | cut -f 1)
    if [ $tamanho -gt $minimumsize ]; then
        mv /scripts/_dcc.f_seguranca_.sh.tmp /scripts/_dcc.f_seguranca_.sh
        chmod 400 /scripts/_dcc.f_seguranca_.sh
    else
        TEXTOEMAIL+="\nERROR: _dcc.f_seguranca_.sh nao gravado"
        ENVIAEMAIL="1"
        rm -f /scripts/_dcc.f_seguranca_.tmp
    fi


    wget -O /scripts/_dcc.f_sistema_.sh.tmp --no-check-certificate https://dcc.hocnet.pt/_dcc/_dcc.f_sistema_.sh >/dev/null 2>&1
	if [ "$?" -ne "0" ]; then
		rm -f /scripts/_dcc.f_sistema_.sh.tmp
		TEXTOEMAIL+="\nDNS ERROR: Falha de resolucao de DNS!!"
		printf "$TEXTOEMAIL" | /bin/mail -s "(_dcc UPDATE) on ${nomeServo}" servidores@datasource.pt
		exit 0
	fi
    tamanho=$(du -b "/scripts/_dcc.f_sistema_.sh.tmp" | cut -f 1)
    if [ $tamanho -gt $minimumsize ]; then
        mv /scripts/_dcc.f_sistema_.sh.tmp /scripts/_dcc.f_sistema_.sh
        chmod 400 /scripts/_dcc.f_sistema_.sh
    else
        TEXTOEMAIL+="\nERROR: _dcc.f_sistema_.sh nao gravado"
        ENVIAEMAIL="1"
        rm -f /scripts/_dcc.f_sistema_.tmp
    fi


    wget -O /scripts/_dcc.f_varnish_.sh.tmp --no-check-certificate https://dcc.hocnet.pt/_dcc/_dcc.f_varnish_.sh >/dev/null 2>&1
	if [ "$?" -ne "0" ]; then
		rm -f /scripts/_dcc.f_varnish_.sh.tmp
		TEXTOEMAIL+="\nDNS ERROR: Falha de resolucao de DNS!!"
		printf "$TEXTOEMAIL" | /bin/mail -s "(_dcc UPDATE) on ${nomeServo}" servidores@datasource.pt
		exit 0
	fi
    tamanho=$(du -b "/scripts/_dcc.f_varnish_.sh.tmp" | cut -f 1)
    if [ $tamanho -gt $minimumsize ]; then
        mv /scripts/_dcc.f_varnish_.sh.tmp /scripts/_dcc.f_varnish_.sh
        chmod 400 /scripts/_dcc.f_varnish_.sh
    else
        TEXTOEMAIL+="\nERROR: _dcc.f_varnish_.sh nao gravado"
        ENVIAEMAIL="1"
        rm -f /scripts/_dcc.f_varnish_.tmp
    fi


    wget -O /scripts/_dcc.f_SSLconv.sh.tmp --no-check-certificate https://dcc.hocnet.pt/_dcc/_dcc.f_SSLconv.sh >/dev/null 2>&1
	if [ "$?" -ne "0" ]; then
		rm -f /scripts/_dcc.f_SSLconv.sh.tmp
		TEXTOEMAIL+="\nDNS ERROR: Falha de resolucao de DNS!!"
		printf "$TEXTOEMAIL" | /bin/mail -s "(_dcc UPDATE) on ${nomeServo}" servidores@datasource.pt
		exit 0
	fi
    tamanho=$(du -b "/scripts/_dcc.f_SSLconv.sh.tmp" | cut -f 1)
    if [ $tamanho -gt $minimumsize ]; then
        mv /scripts/_dcc.f_SSLconv.sh.tmp /scripts/_dcc.f_SSLconv.sh
        chmod 700 /scripts/_dcc.f_SSLconv.sh
    else
        TEXTOEMAIL+="\nERROR: _dcc.f_SSLconv.sh nao gravado"
        ENVIAEMAIL="1"
        rm -f /scripts/_dcc.f_SSLconv.tmp
    fi


    wget -O /scripts/_dcc.sh.tmp --no-check-certificate https://dcc.hocnet.pt/_dcc/_dcc.sh >/dev/null 2>&1
	if [ "$?" -ne "0" ]; then
		rm -f /scripts/_dcc.sh.tmp
		TEXTOEMAIL+="\nDNS ERROR: Falha de resolucao de DNS!!"
		printf "$TEXTOEMAIL" | /bin/mail -s "(_dcc UPDATE) on ${nomeServo}" servidores@datasource.pt
		exit 0
	fi
    tamanho=$(du -b "/scripts/_dcc.sh.tmp" | cut -f 1)
    if [ $tamanho -gt $minimumsize ]; then
        mv /scripts/_dcc.sh.tmp /scripts/_dcc.sh
        chmod 700 /scripts/_dcc.sh
    else
        TEXTOEMAIL+="\nERROR: _dcc.sh nao gravado"
        ENVIAEMAIL="1"
        rm -f /scripts/_dcc.tmp
    fi


    wget -O /scripts/_dccAPI.pl.tmp --no-check-certificate https://dcc.hocnet.pt/_dcc/_dccAPI.txt >/dev/null 2>&1
	if [ "$?" -ne "0" ]; then
		rm -f /scripts/_dccAPI.pl.tmp
		TEXTOEMAIL+="\nDNS ERROR: Falha de resolucao de DNS!!"
		printf "$TEXTOEMAIL" | /bin/mail -s "(_dcc UPDATE) on ${nomeServo}" servidores@datasource.pt
		exit 0
	fi
    tamanho=$(du -b "/scripts/_dccAPI.pl.tmp" | cut -f 1)
    if [ $tamanho -gt $minimumsize ]; then
        mv /scripts/_dccAPI.pl.tmp /scripts/_dccAPI.pl
        chmod 755 /scripts/_dccAPI.pl
    else
        TEXTOEMAIL+="\nERROR: _dccAPI.pl nao gravado"
        ENVIAEMAIL="1"
        rm -f /scripts/_dccAPI.pl.tmp
    fi


    wget -O /scripts/_crond_spamExperts.tmp --no-check-certificate https://dcc.hocnet.pt/_dcc/_crond_spamExperts >/dev/null 2>&1
	if [ "$?" -ne "0" ]; then
		rm -f /scripts/_crond_spamExperts.tmp
		TEXTOEMAIL+="\nDNS ERROR: Falha de resolucao de DNS!!"
		printf "$TEXTOEMAIL" | /bin/mail -s "(_dcc UPDATE) on ${nomeServo}" servidores@datasource.pt
		exit 0
	fi
    tamanho=$(du -b "/scripts/_crond_spamExperts.tmp" | cut -f 1)
    if [ $tamanho -gt $minimumsize ]; then
        mv /scripts/_crond_spamExperts.tmp /scripts/_crond_spamExperts
        chmod 755 /scripts/_crond_spamExperts
    else
        TEXTOEMAIL+="\nERROR: _crond_spamExperts nao gravado"
        ENVIAEMAIL="1"
        rm -f /scripts/_crond_spamExperts.tmp
    fi


    wget -O /scripts/_crond-root.tmp --no-check-certificate https://dcc.hocnet.pt/_dcc/_crond-root >/dev/null 2>&1
	if [ "$?" -ne "0" ]; then
		rm -f /scripts/_crond-root.tmp
		TEXTOEMAIL+="\nDNS ERROR: Falha de resolucao de DNS!!"
		printf "$TEXTOEMAIL" | /bin/mail -s "(_dcc UPDATE) on ${nomeServo}" servidores@datasource.pt
		exit 0
	fi
    tamanho=$(du -b "/scripts/_crond-root.tmp" | cut -f 1)
    if [ $tamanho -gt $minimumsize ]; then
        mv /scripts/_crond-root.tmp /etc/cron.d/_crond-root
        chmod 600 /etc/cron.d/_crond-root
    else
        TEXTOEMAIL+="\nERROR: _crond-root nao gravado"
        ENVIAEMAIL="1"
        RESTARTCRON="0"
        rm -f /scripts/_crond-root.tmp
    fi

    chmod 400 /scripts/_dcc.config.sh
    chmod 700 /scripts/_dcc.sh
    chmod 700 /scripts/_dccU.sh

    if [ "$ENVIAEMAIL" == "$SENDEMAIL" ]; then
        printf "$TEXTOEMAIL" | /bin/mail -s "(_dcc UPDATE) on ${nomeServo}" servidores@datasource.pt
    fi

    if [ "$RESTARTCRON" == "$RESTARTCRON2" ]; then
        /etc/init.d/crond restart
    fi

fi

#_________________________
# Faz symlink do _dcc.sh
if [ -f "/scripts/_dcc.sh" ]; then
    if [ ! -h "/usr/bin/d-" ]; then
        cd /usr/bin
        ln -s /scripts/_dcc.sh d-
        cd /root
    fi
fi
#-------------------------
	
#_________________________
# Faz symlink do _dcU.sh
if [ -f "/usr/bin/dU-" ]; then
    if [ ! -h "/usr/bin/dU-" ]; then
        cd /usr/bin
        ln -s /scripts/_dccU.sh dU-
        cd /root
    fi
fi
#-------------------------

chmod 700 /scripts/_dcc.sh
chmod 700 /scripts/_dccU.sh
exit 0
