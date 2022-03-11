#!/usr/bin/env bash
# Copyright (c) 2008-2012 http://datasource.pt/

#  *********************************************************************************************
#  | SECTION:INICIAL 1 -> BEGIN
#  .................................................................

function LIMPAoQueEuQuiser {
        #---------------------------------------
        # Esta funcao e usada para fazer coisas
        # temporarias que queiramos fazer e devemos
        # usa-la para coisas rapidas a fazer em
        # todos os servidores
        #---------------------------------------

        ###- Limpa bug do 0.conf
        if [ -f "/etc/nginx/vhosts/0.conf" ]; then
                rm -f /etc/nginx/vhosts/0.conf
        fi
        if [ -f "/etc/nginx/vhosts/0_CONFIG__.inc" ]; then
                rm -f /etc/nginx/vhosts/0_CONFIG__.inc
        fi
        if [ -f "/etc/nginx/userdata/0" ]; then
                rm -f /etc/nginx/userdata/0
        fi
        #-------------------------

        #_________________________
        # Limpa antivirus a mais
        if [ -f "/var/lib/clamav/scam.ndb" ]; then
                rm -f /var/lib/clamav/scam.ndb
        fi
        if [ -f "/var/lib/clamav/bofhland_malware_attach.hdb" ]; then
                rm -f /var/lib/clamav/bofhland_malware_attach.hdb
        fi
        if [ -f "/var/lib/clamav/porcupine.ndb" ]; then
                rm -f /var/lib/clamav/porcupine.ndb
        fi
        if [ -f "/var/lib/clamav/hocnetemail.ndb" ]; then
                rm -f /var/lib/clamav/hocnetemail.ndb
        fi
        if [ -f "/var/lib/clamav/bofhland_cracked_URL.ndb" ]; then
                rm -f /var/lib/clamav/bofhland_cracked_URL.ndb
        fi
        if [ -f "/var/lib/clamav/bofhland_malware_URL.ndb" ]; then
                rm -f /var/lib/clamav/bofhland_malware_URL.ndb
        fi
        if [ -f "/var/lib/clamav/phish.ndb" ]; then
                rm -f /var/lib/clamav/phish.ndb
        fi
        #-
        if [ -f "/var/lib/clamav/securiteinfosh.hdb" ]; then
                rm -f /var/lib/clamav/securiteinfosh.hdb
        fi
        if [ -f "/usr/local/cpanel/3rdparty/share/clamav/securiteinfosh.hdb" ]; then
                rm -f /usr/local/cpanel/3rdparty/share/clamav/securiteinfosh.hdb
        fi
        if [ -f "/usr/share/clamav/securiteinfosh.hdb" ]; then
                rm -f /var/lib/clamav/securiteinfosh.hdb
        fi
        #-
        if [ -f "/var/lib/clamav/securiteinfoelf.hdb" ]; then
                rm -f /var/lib/clamav/securiteinfoelf.hdb
        fi
        if [ -f "/usr/local/cpanel/3rdparty/share/clamav/securiteinfoelf.hdb" ]; then
                rm -f /usr/local/cpanel/3rdparty/share/clamav/securiteinfoelf.hdb
        fi
        if [ -f "/usr/share/clamav/securiteinfoelf.hdb" ]; then
                rm -f /usr/share/clamav/securiteinfoelf.hdb
        fi

        #-------------------------

        #_________________________
        # Faz symlink do _dcc.sh
        if [ -f "/scripts/_dcc.sh" ]; then
                if [ ! -h "/usr/bin/d-" ]; then
                        ln -s /scripts/_dcc.sh /usr/bin/d-
                        cd /root
                fi
        fi
        #-------------------------

        #_________________________
        # Faz symlink do _dccU.sh
        if [ -f "/scripts/_dccU.sh" ]; then
                if [ ! -h "/usr/bin/dU-" ]; then
                        cd /usr/bin
                        ln -s /scripts/_dccU.sh dU-
                        cd /root
                fi
        fi
        #-------------------------

        echo
}

#    *********************************************************************************************
#    | SECTION:INICIAL 2 -> END
#    .................................................................
