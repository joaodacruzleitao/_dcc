#!/usr/bin/env bash
#Copyright (c) 2008-2012 http://datasource.pt/

#  *********************************************************************************************
#  | SECTION:NGINX -> BEGIN
#  .................................................................

function nginx::install {
    #---------------------------------------
    # Instala o Nginx
    #---------------------------------------
    clear
    echo
    echo "A instalar o NGINX ..."
    echo

    #---

    #_________________________
    # A fazer download e descompactar
    echo "1) A fazer download e descompactar"
    mkdir -p /root/nginx
    cd /root/nginx
    wget -O /root/nginx/_nginx_.tar.gz --no-check-certificate https://dcc.hocnet.pt/_dcc/_nginx/_nginx_.tar.gz
    tar -xzvf _nginx_.tar.gz
    chown -R root.root /root/nginx
    chmod -R 700 /root/nginx
    echo

    #_________________________
    # Copiar Ficheiros necess�rio para o Servi�o
    echo "2) Copiar Ficheiros necess�rio para o Servi�o"
    cd /root/nginx
    yes | cp /root/nginx/init.d/nginx /etc/rc.d/init.d/
    yes | cp /root/nginx/chkserv.d/nginx /etc/chkserv.d/
    chmod 755 /etc/rc.d/init.d/nginx
    chmod 644 /etc/chkserv.d/nginx
    echo

    #_________________________
    # Criar Directorias necess�rias
    echo "3) Criar Directorias necess�rias"
    mkdir -p /etc/nginx
    mkdir -p /etc/nginx/vhosts
    mkdir -p /var/cache/nginx
    echo

    #_________________________
    # Compilar NGINX
    # Testa primeiro se é centos 5 ou 6
    echo "5) Compilar NGINX"

    cd /root/nginx
    if [ ! -d "/root/nginx/openssl-1.0.1l" ]; then
        /usr/bin/wget http://www.openssl.org/source/openssl-1.0.1l.tar.gz
        if [ "$?" -ne "0" ]; then
            echo "--> ERROR, download do SSL FALHADO!!!!!!"
            exit 0
        fi
        /scripts/_dcc.sh sis_untargz openssl-1.0.1l.tar.gz
    fi

    #-- Build static openssl
    cd /root/nginx/openssl-1.0.1l
    rm -rf "/root/nginx/staticlibssl"
    mkdir "/root/nginx/staticlibssl"
    make clean
    if [[ "$(uname -m)" == 'x86_64' ]]; then
        ./config --prefix=/root/nginx/staticlibssl no-shared enable-ec_nistp_64_gcc_128 \
            && make depend \
            && make \
            && make install_sw
    else
        ./config --prefix=/root/nginx/staticlibssl no-shared \
            && make depend \
            && make \
            && make install_sw
    fi

    cd /root/nginx/nginx-source
    VERSAOOS=$(uname -r | grep -i el5)
    if [[ "$(uname -m)" == 'x86_64' ]]; then
        if [ "${VERSAOOS}" == "" ]; then
            ./configure
            # compila CENTOS 6 x86_64
            VERCP="CENTOS 6 x86_64"
            ./configure --with-cc-opt="-I /root/nginx/staticlibssl/include -I/usr/include" \
                --with-ld-opt="-L /root/nginx/staticlibssl/lib -Wl,-rpath -lssl -lcrypto -ldl -lz" \
                --conf-path=/etc/nginx/nginx.conf \
                --with-pcre=/root/nginx/pcre-8.35 \
                --sbin-path=/usr/local/sbin --pid-path=/var/run/nginx.pid \
                --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log \
                --http-client-body-temp-path=/var/cache/nginx/client \
                --http-proxy-temp-path=/var/cache/nginx/proxy \
                --http-fastcgi-temp-path=/var/cache/nginx/fastcgi \
                --with-http_stub_status_module --with-http_ssl_module --with-http_spdy_module \
                --with-http_flv_module --with-http_geoip_module --with-http_mp4_module \
                --with-file-aio --with-threads \
                --without-http_ssi_module --without-http_uwsgi_module --without-http_scgi_module
        else
            # compila CENTOS 5 x86_64
            VERCP="CENTOS 5 x86_64"
            ./configure --with-cc-opt="-I /root/nginx/staticlibssl/include -I/usr/include" \
                --with-ld-opt="-L /root/nginx/staticlibssl/lib -Wl,-rpath -lssl -lcrypto -ldl -lz" \
                --conf-path=/etc/nginx/nginx.conf \
                --with-pcre=/root/nginx/pcre-8.35 \
                --sbin-path=/usr/local/sbin --pid-path=/var/run/nginx.pid \
                --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log \
                --http-client-body-temp-path=/var/cache/nginx/client \
                --http-proxy-temp-path=/var/cache/nginx/proxy \
                --http-fastcgi-temp-path=/var/cache/nginx/fastcgi \
                --with-http_stub_status_module --with-http_ssl_module --with-http_spdy_module \
                --with-http_flv_module --with-http_geoip_module --with-http_mp4_module \
                --with-file-aio --with-threads \
                --without-http_ssi_module --without-http_uwsgi_module --without-http_scgi_module
        fi
    else
        # compila CENTOS 5/6 i386
        VERCP="compila CENTOS 5/6 i386"
        ./configure --with-cc-opt="-I /root/nginx/staticlibssl/include -I/usr/include" \
            --with-ld-opt="-L /root/nginx/staticlibssl/lib -Wl,-rpath -lssl -lcrypto -ldl -lz" \
            --conf-path=/etc/nginx/nginx.conf \
            --with-pcre=/root/nginx/pcre-8.35 \
            --sbin-path=/usr/local/sbin --pid-path=/var/run/nginx.pid \
            --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log \
            --http-client-body-temp-path=/var/cache/nginx/client \
            --http-proxy-temp-path=/var/cache/nginx/proxy \
            --http-fastcgi-temp-path=/var/cache/nginx/fastcgi \
            --with-http_stub_status_module --with-http_ssl_module --with-http_spdy_module \
            --with-http_flv_module --with-http_geoip_module --with-http_mp4_module \
            --with-file-aio --with-threads \
            --without-http_ssi_module --without-http_uwsgi_module --without-http_scgi_module
    fi
    make
    make install
    cd /root/nginx
    rm -f /etc/nginx/nginx.conf
    # Copy file with override = YES
    \cp /root/nginx/nginx.conf /etc/nginx/nginx.conf
    echo

    #_________________________
    # Copiar Ficheiros NGINX
    echo "-- Copiar Ficheiros NGINX"
    cd /root/nginx
    yes | cp /root/nginx/__firewall__.inc /etc/nginx/__firewall__.inc
    yes | cp /root/nginx/__firewall-init__.inc /etc/nginx/__firewall-init__.inc
    yes | cp /root/nginx/_anti-flood_.inc /etc/nginx/_anti-flood_.inc
    yes | cp /root/nginx/cache.inc /etc/nginx/cache.inc
    yes | cp /root/nginx/cache_estaticos.inc /etc/nginx/cache_estaticos.inc
    yes | cp /root/nginx/cache_1h.inc /etc/nginx/cache_1h.inc
    yes | cp /root/nginx/cache_no.inc /etc/nginx/cache_no.inc
    yes | cp /root/nginx/connection_limits.inc /etc/nginx/connection_limits.inc
    yes | cp /root/nginx/proxy.inc /etc/nginx/proxy.inc
    yes | cp /root/nginx/error_pages.conf /etc/nginx/error_pages.conf
    yes | cp /root/nginx/pagespeed.conf /etc/nginx/pagespeed.conf
    yes | cp /root/nginx/mime.types /etc/nginx/mime.types
    yes | cp /root/nginx/drop.conf /etc/nginx/drop.conf
    yes | cp /root/nginx/estaticos.conf /etc/nginx/estaticos.conf
    yes | cp /root/nginx/estaticos_cache.conf /etc/nginx/estaticos_cache.conf
    yes | cp /root/nginx/127.0.0.1.conf /etc/nginx/vhosts/127.0.0.1.conf
    echo

    #_________________________
    # Configurar servi�o e activo
    echo "6) Configurar servi�o e activo"
    echo "nginx:1" >>/etc/chkserv.d/chkservd.conf
    chkconfig nginx on
    echo

    #_________________________
    # service nginx restart
    echo "7) Fazendo Restart ao servico Nginx"
    /etc/init.d/nginx restart
    echo

    echo "8) Fim, ver se esta tudo ok"

    #---
    echo
    echo -e "... [ DONE ]"
    echo
    echo "---------------------------"
    pause "Pressione [Enter] para Continuar..."
    echo
}

function nginx::update {
    #---------------------------------------
    # Faz o Update do direct�rio Source do
    # Nginx em /root/nginx
    #---------------------------------------
    clear
    echo
    echo "A fazer update do direct�rio /root/nginx ..."
    echo

    #---

    # A fazer download e descompactar
    #
    echo "1) A fazer download e descompactar"
    mkdir -p /root/nginx
    cd /root/nginx
    rm -rf /root/nginx/*
    wget -O /root/nginx/_nginx_.tar.gz --no-check-certificate https://dcc.hocnet.pt/_dcc/_nginx/_nginx_.tar.gz
    tar -xzvf _nginx_.tar.gz
    chown -R root.root /root/nginx
    chmod -R 700 /root/nginx
    echo

    #---
    echo
    echo -e "... [ DONE ]"
    echo
    echo "---------------------------"
    pause "Pressione [Enter] para Continuar..."
    echo
}

function nginx::compile {
    #---------------------------------------
    # Faz a recompilacao do Nginx
    #---------------------------------------
    clear
    echo
    echo "Compilando NGINX ..."
    echo

    #---

    #_________________________
    # Compilar NGINX
    # Testa primeiro se � centos 5 ou 6
    echo "-- Compilar NGINX"

        cd /root/nginx
        if [ ! -d "/root/nginx/openssl-1.0.1l" ]; then
            /usr/bin/wget http://www.openssl.org/source/openssl-1.0.1l.tar.gz
            if [ "$?" -ne "0" ]; then
               echo "--> ERROR, download do SSL FALHADO!!!!!!"
               exit 0
        fi
            /scripts/_dcc.sh sis_untargz openssl-1.0.1l.tar.gz
    fi

    #-- Build static openssl
        cd /root/nginx/openssl-1.0.1l
        rm -rf "/root/nginx/staticlibssl"
        mkdir "/root/nginx/staticlibssl"
        make clean
    if [[ "$(uname -m)" == 'x86_64' ]]; then
            ./config --prefix=/root/nginx/staticlibssl no-shared enable-ec_nistp_64_gcc_128 \
            && make depend \
            && make \
            && make install_sw
    else
            ./config --prefix=/root/nginx/staticlibssl no-shared \
            && make depend \
            && make \
            && make install_sw
    fi

        cd /root/nginx/nginx-source
    VERSAOOS=$(uname -r | grep -i el5)
    if [[ "$(uname -m)" == 'x86_64' ]]; then
            if [ "${VERSAOOS}" == "" ]; then
                ./configure
            # compila CENTOS 6 x86_64
                VERCP="CENTOS 6 x86_64"
                ./configure --with-cc-opt="-I /root/nginx/staticlibssl/include -I/usr/include" \
                --with-ld-opt="-L /root/nginx/staticlibssl/lib -Wl,-rpath -lssl -lcrypto -ldl -lz" \
                --conf-path=/etc/nginx/nginx.conf \
                --with-pcre=/root/nginx/pcre-8.35 \
                --sbin-path=/usr/local/sbin --pid-path=/var/run/nginx.pid \
                --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log \
                --http-client-body-temp-path=/var/cache/nginx/client \
                --http-proxy-temp-path=/var/cache/nginx/proxy \
                --http-fastcgi-temp-path=/var/cache/nginx/fastcgi \
                --with-http_stub_status_module --with-http_ssl_module --with-http_spdy_module \
                --with-http_flv_module --with-http_geoip_module --with-http_mp4_module \
                --with-file-aio --with-threads \
                --without-http_ssi_module --without-http_uwsgi_module --without-http_scgi_module
        else
            # compila CENTOS 5 x86_64
                VERCP="CENTOS 5 x86_64"
                ./configure --with-cc-opt="-I /root/nginx/staticlibssl/include -I/usr/include" \
                --with-ld-opt="-L /root/nginx/staticlibssl/lib -Wl,-rpath -lssl -lcrypto -ldl -lz" \
                --conf-path=/etc/nginx/nginx.conf \
                --with-pcre=/root/nginx/pcre-8.35 \
                --sbin-path=/usr/local/sbin --pid-path=/var/run/nginx.pid \
                --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log \
                --http-client-body-temp-path=/var/cache/nginx/client \
                --http-proxy-temp-path=/var/cache/nginx/proxy \
                --http-fastcgi-temp-path=/var/cache/nginx/fastcgi \
                --with-http_stub_status_module --with-http_ssl_module --with-http_spdy_module \
                --with-http_flv_module --with-http_geoip_module --with-http_mp4_module \
                --with-file-aio --with-threads \
                --without-http_ssi_module --without-http_uwsgi_module --without-http_scgi_module
        fi
    else
        # compila CENTOS 5/6 i386
                VERCP="compila CENTOS 5/6 i386"
                ./configure --with-cc-opt="-I /root/nginx/staticlibssl/include -I/usr/include" \
            --with-ld-opt="-L /root/nginx/staticlibssl/lib -Wl,-rpath -lssl -lcrypto -ldl -lz" \
            --conf-path=/etc/nginx/nginx.conf \
            --with-pcre=/root/nginx/pcre-8.35 \
            --sbin-path=/usr/local/sbin --pid-path=/var/run/nginx.pid \
            --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log \
            --http-client-body-temp-path=/var/cache/nginx/client \
            --http-proxy-temp-path=/var/cache/nginx/proxy \
            --http-fastcgi-temp-path=/var/cache/nginx/fastcgi \
            --with-http_stub_status_module --with-http_ssl_module --with-http_spdy_module \
            --with-http_flv_module --with-http_geoip_module --with-http_mp4_module \
            --with-file-aio --with-threads \
            --without-http_ssi_module --without-http_uwsgi_module --without-http_scgi_module
    fi
        make
        service nginx stop
        sleep 8
        make install
        cd /root/nginx
        rm -f /etc/nginx/nginx.conf
        yes | cp /root/nginx/nginx.conf /etc/nginx/nginx.conf
    echo

    # Copiar Ficheiros NGINX
    #
    echo "-- Copiar Ficheiros NGINX"
    cd /root/nginx
    yes | cp /root/nginx/__firewall__.inc /etc/nginx/__firewall__.inc
    yes | cp /root/nginx/__firewall-init__.inc /etc/nginx/__firewall-init__.inc
    yes | cp /root/nginx/_anti-flood_.inc /etc/nginx/_anti-flood_.inc
    yes | cp /root/nginx/cache.inc /etc/nginx/cache.inc
    yes | cp /root/nginx/cache_estaticos.inc /etc/nginx/cache_estaticos.inc
    yes | cp /root/nginx/cache_1h.inc /etc/nginx/cache_1h.inc
    yes | cp /root/nginx/cache_no.inc /etc/nginx/cache_no.inc
    yes | cp /root/nginx/connection_limits.inc /etc/nginx/connection_limits.inc
    yes | cp /root/nginx/proxy.inc /etc/nginx/proxy.inc
    yes | cp /root/nginx/error_pages.conf /etc/nginx/error_pages.conf
    yes | cp /root/nginx/pagespeed.conf /etc/nginx/pagespeed.conf
    yes | cp /root/nginx/mime.types /etc/nginx/mime.types
    yes | cp /root/nginx/drop.conf /etc/nginx/drop.conf
    yes | cp /root/nginx/estaticos.conf /etc/nginx/estaticos.conf
    yes | cp /root/nginx/estaticos_cache.inc /etc/nginx/estaticos_cache.inc
    yes | cp /root/nginx/127.0.0.1.conf /etc/nginx/vhosts/127.0.0.1.conf
    echo
    echo "-- Fazendo Restart ao NginX"
    /etc/init.d/nginx restart
    echo

    echo "-- Fim, agora deve fazer, service nginx restart, e ver se esta tudo ok"
    echo

    #---
    echo " -- ( compilado ${VERCP} )"
    echo -e "... [ DONE ]"
    echo
    echo "---------------------------"
    pause "Pressione [Enter] para Continuar..."
    echo
}

function nginx::copia_configs {
    #---------------------------------------
    # Faz download do Nginx e Copia e
    # actualiza apenas os configs fazend reload
    #---------------------------------------
    clear
    echo
    echo "Actualizando Configs NGINX ..."
    echo

    #---
    # A fazer download e descompactar
    #
    echo "-- A fazer download e descompactar"
    mkdir -p /root/nginx
    cd /root/nginx
    rm -rf /root/nginx/*
    wget -O /root/nginx/_nginx_.tar.gz --no-check-certificate https://dcc.hocnet.pt/_dcc/_nginx/_nginx_.tar.gz
    tar -xzvf _nginx_.tar.gz
    chown -R root.root /root/nginx
    chmod -R 700 /root/nginx
    echo

    # Copiar Ficheiros NGINX
    #
    echo "-- Copiar Ficheiros de Config NGINX"
    cd /root/nginx
    yes | cp /root/nginx/nginx.conf /etc/nginx/nginx.conf
    yes | cp /root/nginx/__firewall__.inc /etc/nginx/__firewall__.inc
    yes | cp /root/nginx/__firewall-init__.inc /etc/nginx/__firewall-init__.inc
    yes | cp /root/nginx/_anti-flood_.inc /etc/nginx/_anti-flood_.inc
    yes | cp /root/nginx/cache.inc /etc/nginx/cache.inc
    yes | cp /root/nginx/cache_estaticos.inc /etc/nginx/cache_estaticos.inc
    yes | cp /root/nginx/cache_1h.inc /etc/nginx/cache_1h.inc
    yes | cp /root/nginx/cache_no.inc /etc/nginx/cache_no.inc
    yes | cp /root/nginx/connection_limits.inc /etc/nginx/connection_limits.inc
    yes | cp /root/nginx/proxy.inc /etc/nginx/proxy.inc
    yes | cp /root/nginx/error_pages.conf /etc/nginx/error_pages.conf
    yes | cp /root/nginx/pagespeed.conf /etc/nginx/pagespeed.conf
    yes | cp /root/nginx/mime.types /etc/nginx/mime.types
    yes | cp /root/nginx/drop.conf /etc/nginx/drop.conf
    yes | cp /root/nginx/estaticos.conf /etc/nginx/estaticos.conf
    yes | cp /root/nginx/estaticos_cache.conf /etc/nginx/estaticos_cache.conf
    yes | cp /root/nginx/127.0.0.1.conf /etc/nginx/vhosts/127.0.0.1.conf

    echo
    echo "-- Fazendo Reload ao NginX"
    /etc/init.d/nginx reload
    echo

    #---
    echo
    echo -e "... [ DONE ]"
    echo
    echo "---------------------------"
    pause "Pressione [Enter] para Continuar..."
    echo
}

function nginx::cria_tar {
    #---------------------------------------
    # Empacota a Source do Nginx
    # em /home/dcchocne/public_html/_dcc/_nginx
    #---------------------------------------
    clear
    echo
    echo "Empacotando NGINX ..."
    echo

    #---

    # Faz o check se esta no servidor certo
    #
    if [ ! -d "/home/dcchocne/public_html/_dcc/_nginx" ]; then
        echo "ISTO SO PODE SER FEITO NO Servidor dcc.hocnet.pt, o B83!!!!!!"
        echo
        echo "Exited!"
        echo
        exit 0
    fi

    # Chamar directorio
    #
    echo "1) a Chamar /home/dcchocne/public_html/_dcc/_nginx"
    cd /home/dcchocne/public_html/_dcc/_nginx

    # Copiar Ficheiros NGINX
    #
    echo "2) A criar o _nginx_.tar.gz"
    cd /home/dcchocne/public_html/_dcc/_nginx
    rm -f _nginx_.tar.gz
    tar -czvf _nginx_.tar.gz --exclude='__do.tar.sh' --exclude='_nginx_.tar.gz' *
    chown dcchocne.dcchocne _nginx_.tar.gz
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

function NGINXupstream {
    #---------------------------------------
    # Recria todo o /etc/nginx/vhosts/DOMINIOS
    # para o alojamento do USER
    #---------------------------------------
    clear
    echo
    cecho "A criar /etc/nginx/upstream.conf ..." $boldyellow
    echo
    #--
    echo "" >/etc/nginx/upstream.conf

    for ipa in $(/sbin/ifconfig | grep Bcast | awk '{ print $2}' | cut -d ":" -f2); do
        ipb=$(echo "${ipa}" | tr . _)
        cat >>/etc/nginx/upstream.conf  <<EOF
upstream ${ipb}_app {
    # fail_timeout=0 means we always retry an upstream even if it failed
    # to return a good HTTP response (in case the Unicorn master nukes a
    # single worker for timing out).

    # for TCP setups, point these to your backend servers
    server ${ipa}:6081;
}

upstream ${ipb}_app_ssl {
    # fail_timeout=0 means we always retry an upstream even if it failed
    # to return a good HTTP response (in case the Unicorn master nukes a
    # single worker for timing out).

    # for TCP setups, point these to your backend servers
    server ${ipa}:444;
}

EOF
    done
    #---
    echo
    echo -e "... $GREEN[ DONE ]$RESET"
    echo
    echo "---------------------------"
    pause "Pressione [Enter] para Continuar..."
    echo
}

function NGINXvhostsSingle {
    #---------------------------------------
    # Recria todo o /etc/nginx/vhosts/DOMINIOS
    # para o alojamento do USER
    #---------------------------------------
    clear
    echo
    cecho "A criar NGinX Vhost $1 ..." $boldyellow
    echo
    #--
    if [ "$1" == "-12" ]; then
        if [ -z "$2" ]; then
            echo "� preciso especificar o VHOST, assim:"
            echo "Exemplo: $(basename $0) -12 VHOST"
            echo "Exemplo: $(basename $0) -12 jonix.com"
            echo
            exit 0
        fi
        KEY=$2
        RESULT=$(/scripts/_dccAPI.pl --gd  $KEY)
        if [ "$RESULT" == "" ]; then
            echo "N�o existe neste servidor!!"
            exit 0
        fi
    else
        read -p "Digite a VHOST por favor: " KEY
        RESULT=$(/scripts/_dccAPI.pl --gd  $KEY)
        if [ "$RESULT" == "" ]; then
            echo "N�o existe neste servidor!!"
            exit 0
        fi
    fi
    #---
    IP=$(echo "$RESULT\n" | grep "IP" | cut -d: -f2)
    USER=$(echo "$RESULT" | grep ^USER | cut -d: -f2)
    DOMAIN=$(echo "$RESULT" | grep ^DOMAIN | cut -d: -f2)
    ROOT=$(echo "$RESULT" | grep ^DOCUMENTROOT | cut -d: -f2)
    ALIASES=$(echo "$RESULT" | grep ^ALIAS | cut -d: -f2)
    if [ ! -d /etc/nginx/vhosts ]; then
        mkdir /etc/nginx/vhosts
    fi
    if [ ! -f /etc/nginx/vhosts/${DOMAIN}_.inc ]; then
            cat <<'EOF'  >/etc/nginx/vhosts/${DOMAIN}__firewall__.inc
    ## Block Common Joomla Attacks #1
    if ( $request_uri ~* "/index\.php/component/k2/?" ) {
       return 444;
    }
    if ( $request_uri ~* "/index.php/nulla-varius-tincidunt" ) {
       return 444;
    }
    if ( $request_uri ~* "/recente/guestbook" ) {
       return 444;
    }
    if ( $request_uri ~* "/index\.php\?page=shop.recommend.*option=com_virtuemart" ) {
       return 444;
    }
    if ( $request_uri ~* "/index2\.php\?page=shop.recommend.*option=com_virtuemart" ) {
       return 444;
    }

    ## ## Block Common Joomla Attacks #2
    #index.php?option=com_jce&task=plugin&plugin=imgmanager&file=imgmanager&method=form&cid=20
    if ( $request_uri ~* ".*index\.php.*com_jce.*task.*plugin.*imgmanager.*form.*" ) {
       return 444;
    }


    ## Block Referer SPAM
    if ($http_referer ~* (pornogig|prostitutki|viagra)) {
       return 444;
    }


    ## Block spam Normal
    if ($query_string ~ "\b(ultram|unicauca|valium|viagra|vicodin|xanax|ypxaieo)\b") {
        return 444;
    }
    if ($query_string ~ "\b(erections|hoodia|huronriveracres|impotence|levitra|libido)\b") {
        return 444;
    }
    if ($query_string ~ "\b(ambien|blue\spill|cialis|cocaine|ejaculation|erectile)\b") {
        return 444;
    }
    if ($query_string ~ "\b(lipitor|phentermin|pro[sz]ac|sandyauer|tramadol|troyhamby)\b") {
        return 444;
    }


    ## Block user agents
    set $block_user_agents 0;
    # Disable Akeeba Remote Control 2.5 and earlier
    if ($http_user_agent ~ "Indy Library") {
        return 444;
    }
    # Common bandwidth hoggers and hacking tools.
    if ($http_user_agent ~ "libwww-perl") {
        return 444;
    }
    if ($http_user_agent ~ "GetRight") {
        return 444;
    }
    if ($http_user_agent ~ "GetWeb!") {
        return 444;
    }
    if ($http_user_agent ~ "Go!Zilla") {
        return 444;
    }
    if ($http_user_agent ~ "Download Demon") {
        return 444;
    }
    if ($http_user_agent ~ "Go-Ahead-Got-It") {
        return 444;
    }
    if ($http_user_agent ~ "TurnitinBot") {
        return 444;
    }
    if ($http_user_agent ~ "GrabNet") {
        return 444;
    }
    if ($http_user_agent ~* (360Spider|80legs|App3leWebKit|Baiduspider|EasouSpider)) {
        return 444;
    }
    if ($http_user_agent ~* "BOT for JCE") {
        return 444;
    }


    ## Block common exploits
    set $block_common_exploits 0;
    if ($query_string ~ "(<|%3C).*script.*(>|%3E)") {
        return 444;
    }
    if ($query_string ~ "GLOBALS(=|\[|\%[0-9A-Z]{0,2})") {
        return 444;
    }
    if ($query_string ~ "_REQUEST(=|\[|\%[0-9A-Z]{0,2})") {
        return 444;
    }
    if ($query_string ~ "proc/self/environ") {
        return 444;
    }
    if ($query_string ~ "mosConfig_[a-zA-Z_]{1,21}(=|\%3D)") {
        return 444;
    }
    if ($query_string ~ "base64_(en|de)code\(.*\)") {
        return 444;
    }
EOF

            cat <<'EOF'  >/etc/nginx/vhosts/${DOMAIN}_.inc
#   location ~* "^/$" {
#      error_page 405 = @backend;
#      include connection_limits.inc;
#      proxy_pass http://${DOMAIN}:6081;
#      include proxy.inc;
#   }

EOF
    fi
    cat >"/etc/nginx/vhosts/${DOMAIN}.conf"  <<EOF
server {
   error_log /var/log/nginx/vhost-error_log warn;
   listen ${IP}:80;
   server_name ${DOMAIN} $ALIASES;
   access_log /usr/local/apache/domlogs/$DOMAIN bytes_log;
   access_log /usr/local/apache/domlogs/$DOMAIN combined;
   root $ROOT;

   ## Bloco DEFESAS ANTI-HACKERS
   include "/etc/nginx/__firewall__.inc";

   ## Bloco CONNECTIONS LIMIT and PROTECTED DIRECTORIES
   include "/etc/nginx/_anti-flood_.inc";

   ## Bloco DEFESAS ANTI-HACKERS ADICIONAIS POR DOMINIO
   include "/etc/nginx/vhosts/${DOMAIN}__firewall__.inc";

   ## Bloco REGRAS ESPECIAIS PARA O DOMINIO
   include "/etc/nginx/vhosts/${DOMAIN}_.inc";

   location / {
      error_page 405 = @backend;
      include connection_limits.inc;
      proxy_pass http://${IP}:6081;
      include proxy.inc;
	  include "/etc/nginx/estaticos.conf";
      try_files \$uri \$uri/ @backend;
   }

   include "/etc/nginx/estaticos.conf";
   include "/etc/nginx/drop.conf";

   location @backend {
      internal;
      include connection_limits.inc;
      proxy_pass http://${IP}:6081;
	  include cache.inc;
      include proxy.inc;
   }

   location @floodANDdir {
      internal;
      include connection_limits.inc;
      proxy_pass http://${IP}:6081;
      include proxy.inc;
   }

}
EOF
    #---
    echo
    echo -e "... $GREEN[ DONE ]$RESET"
    echo
    echo "---------------------------"
    pause "Pressione [Enter] para Continuar..."
    echo
}

function NGINXvhosts2a {
    #---------------------------------------
    # Recria todo o /etc/nginx/vhosts
    # para todos os alojamentos
    #---------------------------------------
    clear
    echo
    cecho "A criar NGinX Vhosts ..." $boldyellow
    echo
    #---
    cd /var/cpanel/users
    for USER in *; do
        TOTALLINES=$(cat /var/cpanel/userdata/$USER/main | wc -l)
        SUBLINE=$(grep -n sub_domains /var/cpanel/userdata/$USER/main | awk -F ":" '{print $1}')
        IP=$(cat /var/cpanel/users/$USER | grep ^IP | cut -d= -f2)

        #SUBDOMAIN and ADDONS
        TOT1=$(echo "$TOTALLINES-$SUBLINE" | bc)
        for SUB in $(cat /var/cpanel/userdata/$USER/main | tail -n $TOT1 | awk '{print $2}' | xargs -L100); do
            NGINXvhosts1 $SUB
        done

        #MAIN DOMAIN and his aliases
        DOMAIN=$(grep main_domain /var/cpanel/userdata/$USER/main | awk '{print $2}')
        NGINXvhosts1 $DOMAIN
    done
    echo
    echo -e "... $GREEN[ DONE ]$RESET"
    echo
    echo "---------------------------"
    pause "Pressione [Enter] para Continuar..."
    echo
}

function NGINXvhostsUser_Cache {
    #---------------------------------------
    # Fun��o a ser usada na NGINXvhosts2b
    # e que serve para criar cada ficheiro
    # de configura��o de um alojamento
    # recebendo como parametro o sub/dominio
    # SEM CACHE
    #---------------------------------------
    #printf "%s" "$@"
    #echo
    for DOMAIN in $1; do
        ROOT=$(cat /var/cpanel/userdata/$2/$DOMAIN | grep documentroot | awk '{print $2}')
        ALIASES=$(cat /var/cpanel/userdata/$2/$DOMAIN | grep serveralias | sed "s/serveralias: //g" | sed "s/www\.\*\.$DOMAIN//g")
        VHOSTFILE="/etc/nginx/vhosts/${DOMAIN}.conf"
        VHOSTFILESSL="/etc/nginx/vhosts/${DOMAIN}_SSL.conf"
        Strict_Transport_Security=$(cat /etc/nginx/userdata/$2 | grep "Strict_Transport_Security" | awk '{print $2}')
        Caching=$(cat /etc/nginx/userdata/$2 | grep "Caching" | awk '{print $2}')
        X_Frame_Options=$(cat /etc/nginx/userdata/$2 | grep "X_Frame_Options" | awk '{print $2}')

        if [ ! -f /etc/nginx/vhosts/${DOMAIN}_CONFIG__.inc ]; then
            cat >"/etc/nginx/vhosts/${DOMAIN}_CONFIG__.inc"  <<EOF
	### INTRUCOES ###############
	# 1=Ligado
	# 0=Desligado

	####### Configuracao de CACHE ######################################
	set \$querocacheSimNao "${Caching}";

	####### BAD Countries Rules ######################################
	set \$no_countries "1";

    ####### JOOMLA Rules ######################################
	set \$joomla_n001 "1";
	set \$joomla_n002 "1";
	set \$joomla_n003 "1";
	set \$joomla_n003 "1";
	set \$joomla_n004 "1";
	set \$joomla_n005 "1";

    ####### USER-AGENTS Rules ######################################
    set \$user_agents "1";

    ####### COMMON EXPLOITS Rules ######################################
    set \$common_exploits "1";

    ####### CACHE DE CONTEUDOS ESTATICOS ######################################
    set \$estaticos_caches "";

EOF
        else
            if [ "${Caching}" == "0" ]; then
                replace 'set $querocacheSimNao "1";' 'set $querocacheSimNao "0";' -- /etc/nginx/vhosts/${DOMAIN}_CONFIG__.inc
            else
                replace 'set $querocacheSimNao "0";' 'set $querocacheSimNao "1";' -- /etc/nginx/vhosts/${DOMAIN}_CONFIG__.inc
            fi
        fi

        cat >"$VHOSTFILE"  <<EOF
server {
   error_log /var/log/nginx/vhost-error_log warn;
   listen $IP:80;
   server_name ${DOMAIN} $ALIASES;
   access_log /usr/local/apache/domlogs/${DOMAIN} bytes_log;
   access_log /usr/local/apache/domlogs/${DOMAIN} combined;
   root $ROOT;

EOF
        if [ "$X_Frame_Options" == "1" ]; then
            cat >>"$VHOSTFILE"  <<EOF
   # config to don't allow the browser to render the page inside an frame or iframe
   # and avoid clickjacking http://en.wikipedia.org/wiki/Clickjacking
   # if you need to allow [i]frames, you can use SAMEORIGIN or even set an uri with ALLOW-FROM uri
   # https://developer.mozilla.org/en-US/docs/HTTP/X-Frame-Options
   add_header X-Frame-Options SAMEORIGIN;

EOF
        fi
        cat >>"$VHOSTFILE"  <<EOF
   ## Inicializacao das opcoes de Firewall e cache
   include "/etc/nginx/vhosts/${DOMAIN}_CONFIG__.inc";

   ## Firewall Regras
   include "/etc/nginx/__firewall__.inc";
   ##### Firewall Regras ####

   ## Bloco CONNECTIONS LIMIT and PROTECTED DIRECTORIES
   include "/etc/nginx/_anti-flood_.inc";

   location / {
      error_page 405 = @backend;
      include connection_limits.inc;
      proxy_pass http://${IP}:6081;
      include proxy.inc;
	  include cache.inc;
      try_files \$uri \$uri/ @backend;
   }

   include "/etc/nginx/estaticos.conf";
   include "/etc/nginx/drop.conf";

   location @backend {
      internal;
      include connection_limits.inc;
      proxy_pass http://${IP}:6081;
	  include cache.inc;
      include proxy.inc;
   }

   location @floodANDdir {
      internal;
      include connection_limits.inc;
      proxy_pass http://${IP}:6081;
      include proxy.inc;
   }

}
EOF

        if [ -f /var/cpanel/userdata/$2/${DOMAIN}_SSL ]; then
            if [ ! -f /etc/nginx/vhosts/${DOMAIN}_SSL_CONFIG__.inc ]; then
                cat >"/etc/nginx/vhosts/${DOMAIN}_SSL_CONFIG__.inc"  <<EOF
	### INTRUCOES ###############
	# 1=Ligado
	# 0=Desligado

	####### Configuracao de CACHE ######################################
	set \$querocacheSimNao "${Caching}";

	####### BAD Countries Rules ######################################
	set \$no_countries "1";

    ####### JOOMLA Rules ######################################
	set \$joomla_n001 "1";
	set \$joomla_n002 "1";
	set \$joomla_n003 "1";
	set \$joomla_n003 "1";
	set \$joomla_n004 "1";
	set \$joomla_n005 "1";

    ####### USER-AGENTS Rules ######################################
    set \$user_agents "1";

    ####### COMMON EXPLOITS Rules ######################################
    set \$common_exploits "1";

    ####### CACHE DE CONTEUDOS ESTATICOS ######################################
    set \$estaticos_caches "";

EOF
            else
                if [ "${Caching}" == "0" ]; then
                    replace 'set $querocacheSimNao "1";' 'set $querocacheSimNao "0";' -- /etc/nginx/vhosts/${DOMAIN}_SSL_CONFIG__.inc
                else
                    replace 'set $querocacheSimNao "0";' 'set $querocacheSimNao "1";' -- /etc/nginx/vhosts/${DOMAIN}_SSL_CONFIG__.inc
                fi
            fi

            CERTIFICADO=$(cat /var/cpanel/userdata/$2/${DOMAIN}_SSL | grep sslcertificatefile | awk '{print $2}')
            CHAVE=$(cat /var/cpanel/userdata/$2/${DOMAIN}_SSL | grep sslcertificatekeyfile | head -1 | awk '{print $2}')
            CERTIFICADOFINAL=$( /scripts/_dcc.f_SSLconv.sh ${CERTIFICADO} /etc/nginx/certs/${DOMAIN}.crt)
            if [ "${CABUNDLE}" == "" ]; then
                CABUNDLEF="#ssl_trusted_certificate ;"
                SSLSTAPLING="#ssl_stapling on;"
            else
                CABUNDLEF="ssl_trusted_certificate ${CABUNDLE};"
                SSLSTAPLING="ssl_stapling off;"
            fi
            cat >"$VHOSTFILESSL"  <<EOF
server {
   error_log /var/log/nginx/vhost-error_log warn;
   listen $IP:443 ssl spdy;
   server_name ${DOMAIN} $ALIASES;

   ssl_certificate     /etc/nginx/certs/${DOMAIN}.crt;
   ssl_certificate_key ${CHAVE};
   ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
   ssl_prefer_server_ciphers on;
   ssl_ciphers "ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SH";
   ssl_session_cache   shared:SSLS:32m;
   ssl_session_timeout 5m;
   spdy_headers_comp 6;
   ssl_buffer_size 4k;

   access_log /usr/local/apache/domlogs/${DOMAIN}-ssl_log bytes_log;
   access_log /usr/local/apache/domlogs/${DOMAIN}-ssl_log combined;
   root $ROOT;

   add_header Alternate-Protocol  443:npn-spdy/2;
EOF
            if [ "${X_Frame_Options}" == "1" ]; then
                cat >>"$VHOSTFILESSL"  <<EOF
   # config to don't allow the browser to render the page inside an frame or iframe
   # and avoid clickjacking http://en.wikipedia.org/wiki/Clickjacking
   # if you need to allow [i]frames, you can use SAMEORIGIN or even set an uri with ALLOW-FROM uri
   # https://developer.mozilla.org/en-US/docs/HTTP/X-Frame-Options
   add_header X-Frame-Options SAMEORIGIN;

EOF
            fi

            if [ "${Strict_Transport_Security}" == "1" ]; then
                cat >>"$VHOSTFILESSL"  <<EOF
   add_header Strict-Transport-Security "max-age=31536000; includeSubdomains";

EOF
            fi
            cat >>"$VHOSTFILESSL"  <<EOF
   ## Inicializacao das opcoes de Firewall e cache
   include "/etc/nginx/vhosts/${DOMAIN}_SSL_CONFIG__.inc";

   ## Firewall Regras
   include "/etc/nginx/__firewall__.inc";

   ## Bloco CONNECTIONS LIMIT and PROTECTED DIRECTORIES
   include "/etc/nginx/_anti-flood_.inc";

   location / {
      error_page 405 = @backend;
      include connection_limits.inc;
      proxy_pass https://${IP}:444;
	  include cache.inc;
      include proxy.inc;
	  try_files \$uri \$uri/ @backend;
   }

   include "/etc/nginx/estaticos.conf";
   include "/etc/nginx/drop.conf";

   location @backend {
      internal;
      include connection_limits.inc;
      proxy_pass https://${IP}:444;
	  include cache.inc;
      include proxy.inc;
   }

   location @floodANDdir {
      internal;
      include connection_limits.inc;
      proxy_pass https://${IP}:444;
      include proxy.inc;
   }

}
EOF
        fi

    done
}

function NGINXvhostsFULLcache {
    #---------------------------------------
    # Recria todo o /etc/nginx/vhosts
    # para todos os alojamentos
    #---------------------------------------
    clear
    echo
    echo "Criar NGinX Vhosts com CACHE ..."
    echo
    #---
    echo "-- A copiar ficheiros necessario de arranque do nginx"
    mkdir -p /var/cache/nginx/cache
    rm -f /etc/nginx/vhosts/*.inc
    rm -f /etc/nginx/vhosts/*.conf
    OS_RELEASE=$(cat /etc/redhat-release | sed -ne 's/\(^.*release \)\(.*\)\(\..*$\)/\2/p')
    yes | cp /root/nginx/__firewall__.inc /etc/nginx/__firewall__.inc
    yes | cp /root/nginx/__firewall-init__.inc /etc/nginx/__firewall-init__.inc
    yes | cp /root/nginx/_anti-flood_.inc /etc/nginx/_anti-flood_.inc
    yes | cp /root/nginx/cache.inc /etc/nginx/cache.inc
    yes | cp /root/nginx/cache_estaticos.inc /etc/nginx/cache_estaticos.inc
    yes | cp /root/nginx/cache_1h.inc /etc/nginx/cache_1h.inc
    yes | cp /root/nginx/cache_no.inc /etc/nginx/cache_no.inc
    yes | cp /root/nginx/connection_limits.inc /etc/nginx/connection_limits.inc
    yes | cp /root/nginx/proxy.inc /etc/nginx/proxy.inc
    yes | cp /root/nginx/error_pages.conf /etc/nginx/error_pages.conf
    yes | cp /root/nginx/pagespeed.conf /etc/nginx/pagespeed.conf
    yes | cp /root/nginx/mime.types /etc/nginx/mime.types
    yes | cp /root/nginx/drop.conf /etc/nginx/drop.conf
    yes | cp /root/nginx/estaticos.conf /etc/nginx/estaticos.conf
    yes | cp /root/nginx/estaticos_cache.conf /etc/nginx/estaticos_cache.conf
    yes | cp /root/nginx/127.0.0.1.conf /etc/nginx/vhosts/127.0.0.1.conf

    echo
    echo "-- A Detectar se existem sites com SSL e mudar porta SSL para 444"
    CACHENGINX="$1"
    if [ "${CACHENGINX}" == "0" ]; then
        CACHENGINX="0"
    else
        CACHENGINX="1"
    fi

    TEMSSL=$(find /var/cpanel/userdata -name '*_SSL')
    TEMSSLS=$(grep -i "0.0.0.0:444" /var/cpanel/cpanel.config)
    if [ "${TEMSSL}" != "" ]; then
        if [ "${TEMSSLS}" == "" ]; then
            replace "apache_ssl_port=0.0.0.0:443" "apache_ssl_port=0.0.0.0:444" -- /var/cpanel/cpanel.config >/dev/null 2>&1
            /usr/local/cpanel/whostmgr/bin/whostmgr2 --updatetweaksettings >/dev/null 2>&1
            sleep 15
            /etc/init.d/httpd restart
            sleep 2
            /etc/init.d/httpd restart
        fi
    fi

    echo
    echo "-- A criar todos os vhosts globais"
    cd /var/cpanel/users
    for UTILIZADOR in *; do
        #REMOVE OS HASH()
        if [[ $UTILIZADOR != *"HASH("* ]]; then
            TOTALLINES=$(cat /var/cpanel/userdata/$UTILIZADOR/main | wc -l)
            SUBLINE=$(grep -n sub_domains /var/cpanel/userdata/$UTILIZADOR/main | awk -F ":" '{print $1}')
            IP=$(cat /var/cpanel/users/$UTILIZADOR | grep ^IP | cut -d= -f2)

            #SUBDOMAIN and ADDONS
            TOT1=$(echo "$TOTALLINES-$SUBLINE" | bc)
            for SUB in $(cat /var/cpanel/userdata/$UTILIZADOR/main | tail -n $TOT1 | awk '{print $2}' | xargs -L100); do
                NGINXvhostsUser_Cache $SUB $UTILIZADOR $CACHENGINX
            done

            #MAIN DOMAIN and his aliases
            DOMAIN=$(grep main_domain /var/cpanel/userdata/$UTILIZADOR/main | awk '{print $2}')
            NGINXvhostsUser_Cache $DOMAIN $UTILIZADOR $CACHENGINX
        fi
    done

    echo
    echo "-- A Fazer restart ao NginX"
    /etc/init.d/nginx restart

    echo
    echo -e "... [ DONE ]"
    echo
    echo "---------------------------"
    pause "Pressione [Enter] para Continuar..."
    echo
}

function NGINXhooksGeraVhosts {
    #---------------------------------------
    # Recria todo o /etc/nginx/vhosts/DOMINIOS
    # para o alojamento do USER
    #---------------------------------------
    clear
    echo
    echo "A criar NGinX Vhosts para $1 ..."
    echo

    #--
    if [ -z "$1" ]; then
        echo "E preciso especificar o USER, assim:"
        echo "Exemplo: $(basename "$0") -13 USER"
        echo "Exemplo: $(basename $0) -13 jonix"
        echo
    else
        #_________________________
        # Determina qual � o USER
        UTILIZADOR=$1

        #_________________________
        # Consegue as variaveis para
        # o /etc/nginx/userdata/USER
        if [ -f "/etc/nginx/userdata/$UTILIZADOR" ]; then
            HSTSf=$(cat /etc/nginx/userdata/$UTILIZADOR | grep "Strict_Transport_Security" | awk '{print $2}')
            CACHEf=$(cat /etc/nginx/userdata/$UTILIZADOR | grep "Caching" | awk '{print $2}')
            XFRAMEf=$(cat /etc/nginx/userdata/$UTILIZADOR | grep "X_Frame_Options" | awk '{print $2}')
        else
            HSTSf="1"
            CACHEf="1"
            XFRAMEf="1"
        fi
        if [ -z "$2" ]; then
            CACHENGINX="${CACHEf}"
        else
            CACHENGINX=$2
        fi
        if [ -z "$3" ]; then
            XFRAME="${XFRAMEf}"
        else
            XFRAME=$3
        fi
        if [ -z "$4" ]; then
            HSTS="${HSTSf}"
        else
            HSTS=$4
        fi
        cat >"/etc/nginx/userdata/$UTILIZADOR"  <<EOF
---
Strict_Transport_Security: ${HSTS}
Caching: ${CACHENGINX}
X_Frame_Options: ${XFRAME}
EOF

        #_________________________
        # Recolhe o necessario e cria os
        # vhosts para o username escolhido
        TOTALLINES=$(cat /var/cpanel/userdata/$UTILIZADOR/main | wc -l)
        SUBLINE=$(grep -n sub_domains /var/cpanel/userdata/$UTILIZADOR/main | awk -F ":" '{print $1}')
        IP=$(cat /var/cpanel/users/$UTILIZADOR | grep ^IP | cut -d= -f2)

        #SUBDOMAIN and ADDONS
        TOT1=$(echo "$TOTALLINES-$SUBLINE" | bc)
        for SUB in $(cat /var/cpanel/userdata/$UTILIZADOR/main | tail -n $TOT1 | awk '{print $2}' | xargs -L100); do
            NGINXvhostsUser_Cache $SUB $UTILIZADOR
        done

        #MAIN DOMAIN and his aliases
        DOMAIN=$(grep main_domain /var/cpanel/userdata/$UTILIZADOR/main | awk '{print $2}')
        NGINXvhostsUser_Cache $DOMAIN $UTILIZADOR
        #--

        echo
        echo -e "... $GREEN[ DONE ]$RESET"
        echo
        echo "---------------------------"
        pause "Pressione [Enter] para Continuar..."
        echo
    fi
}

function nginx::reset_user_data {
    #---------------------------------------
    # Recria todo o /etc/nginx/userdata
    #---------------------------------------

    #_________________________
    # CRIA USERS NO /etc/nignx/userdata/*
    if [ ! -d /etc/nginx/userdata ]; then
        mkdir -p /etc/nginx/userdata
    else
        rm -rf /etc/nginx/userdata/*
    fi

    cd /var/cpanel/users
    for GAIJO in *; do
        #REMOVE OS HASH()
        if [[ $GAIJO != *"HASH("* ]]; then
            if [ ! -f /etc/nginx/userdata/${GAIJO} ]; then
                cat >"/etc/nginx/userdata/${GAIJO}"  <<EOF
---
Strict_Transport_Security: 1
Caching: 1
X_Frame_Options: 0

EOF
            fi
        fi
    done
}

function nginx::rpaf_module_generator {
    #----------------------------------------------------
    # Instalar/Regenerar o RPAF do nignx/varnish
    #----------------------------------------------------
    clear
    echo
    cecho "RPAF Instalar/Update..." $boldyellow
    echo
    if [ ! -d "/root/nginx/mod_rpaf-0.6" ]; then
        echo "/root/nginx/mod_rpaf-0.6 NAO ENCONTRADO!!!!"
        echo "Por favor faça upload do mod_rpaf para /root/nginx/mod_rpaf-0.6"
        echo
        echo -e "... $RED[ FAILED ]$RESET"
    else
        if [ ! -f "/usr/local/apache/modules/mod_rpaf-2.0.so" ]; then
            echo "-- Compilando o mod_rpaf-2.0.so"
            cd /root/nginx/mod_rpaf-0.6
            /usr/local/apache/bin/apxs -i -c -n mod_rpaf-2.0.so mod_rpaf-2.0.c >/dev/null 2>&1
        fi
        cd /root/nginx
        echo "-- A gerar lista de ips do servidor"
        IP_LIST=$(for i in $(/sbin/ifconfig | grep Bcast | awk '{ print $2}' | cut -d ":" -f2); do echo -ne "$i "; done)
        echo "-- A Criar ficheiro config rpaf.conf para o Apache"
        if [ -f "/usr/local/apache/conf/mod_rpaf.conf" ]; then
            rm -rf /usr/local/apache/conf/mod_rpaf.conf
        fi
        cat >/usr/local/apache/conf/includes/rpaf.conf  <<EOF
LoadModule rpaf_module        modules/mod_rpaf-2.0.so
RPAFenable On
RPAFproxy_ips 127.0.0.1 $IP_LIST
RPAFsethostname On
RPAFsethostname On
RPAFheader X-Forwarded-For
EOF
            cat >"/usr/local/apache/conf/includes/pre_main_2.conf"  <<EOF
Include "/usr/local/apache/conf/includes/rpaf.conf"

## QoS Settings
<IfModule mod_qos.c>
    # handles connections from up to 100000 different IPs
    QS_ClientEntries 100000
    # will allow only 50 connections per IP
    QS_SrvMaxConnPerIP 50
    # maximum number of active TCP connections is limited to 256
    MaxClients              256
    # disables keep-alive when 70% of the TCP connections are occupied:
    QS_SrvMaxConnClose      180
    # minimum request/response speed (deny slow clients blocking the server, ie. slowloris keeping connections open without requesting anything):
    QS_SrvMinDataRate       150 1200
    # and limit request header and body (carefull, that limits uploads and post requests too):
    # LimitRequestFields      30
    # QS_LimitRequestBody     102400
</IfModule>

EOF
        sleep 3
        echo "-- Restarting Apache ..."
        /etc/init.d/httpd restart
        echo
        echo -e "... $GREEN[ DONE ]$RESET"
    fi
    cd /root
    echo
    echo "---------------------"
    pause "Press [Enter] to Continue..."
    #    /scripts/restartsrv_httpd >/dev/null 2>&1
}

function nginx::cloudflare_module_generator {
    #----------------------------------------------------
    # Instalar/Regenerar o MOD_CLOUDFLARE do nginx/varnish
    #----------------------------------------------------
    clear
    echo
    cecho "RPAF Instalar/Update..." $boldyellow
    echo
    if [ ! -d "/root/nginx/mod_cloudflare" ]; then
        echo "/root/nginx/mod_cloudflare NAO ENCONTRADO!!!!"
        echo "Por favor faça upload do mod_cloudflare para /root/nginx/mod_cloudflare"
        echo
        echo -e "... $RED[ FAILED ]$RESET"
    else
        if [ ! -f "/usr/local/apache/modules/mod_cloudflare.so" ]; then
            echo "-- Compilando o mod_cloudflare.so"
            cd /root/nginx/mod_cloudflare
            /usr/local/apache/bin/apxs -a -i -c mod_cloudflare.c >/dev/null 2>&1
        else
            echo "/root/nginx/mod_cloudflare NAO ENCONTRADO!!!!"
            echo "ERRO!!! /usr/local/apache/modules/mod_cloudflare.so j� existe"
            echo
            echo -e "... $RED[ FAILED ]$RESET"
        fi
        cd /root/nginx
        echo "-- A Criar ficheiro config do mod_cloudflare para o Apache"
        if [ -f "/usr/local/apache/conf/mod_cloudflare.conf" ]; then
            rm -rf /usr/local/apache/conf/mod_cloudflare.conf
        fi
        cat >/usr/local/apache/conf/includes/mod_cloudflare.conf <<EOF
LoadModule cloudflare_module modules/mod_cloudflare.so
CloudFlareRemoteIPHeader X-Forwarded-For
CloudFlareRemoteIPTrustedProxy 127.0.0.1
EOF
        for i in $(/sbin/ifconfig | grep Bcast | awk '{ print $2}' | cut -d ":" -f2); do
            echo "CloudFlareRemoteIPTrustedProxy ${i}" >>/usr/local/apache/conf/includes/mod_cloudflare.conf
        done
         echo 'Include "/usr/local/apache/conf/includes/mod_cloudflare.conf"' >/usr/local/apache/conf/includes/pre_main_2.conf
        echo "-- Opera��o Concluida!!"
        echo
        echo -e "... $GREEN[ DONE ]$RESET"
    fi
    cd /root
    echo
    echo "---------------------"
    echo ""
    #    /scripts/restartsrv_httpd >/dev/null 2>&1
}

#    *********************************************************************************************
#    | SECTION:NGINX -> END
#    .................................................................
