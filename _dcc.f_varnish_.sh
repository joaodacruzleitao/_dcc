#Copyright (c) 2008-2012 http://datasource.pt/ 

#  *********************************************************************************************
#  | SECTION:VARNISH -> BEGIN
#  .................................................................

function VARNISHvhosts {
#---------------------------------------
# Recria os ficheiros de configuração
# dos vhosts para o VARNISH
#---------------------------------------
    clear
    echo
    cecho "A criar VARNISH vhost.vcl e acl.vcl ..." $boldyellow
    echo
	#--
	CONF=/usr/local/varnish/etc/varnish/vhost.vcl
    CONF1=/usr/local/varnish/etc/varnish/acl.vcl
    TMPF=/tmp/IP
    IP_1=`hostname -i`
    /scripts/ipusage | awk '{print $1}'|while read ip; do echo  -e "${ip}"; done > $TMPF
	#--
    if [ "$1" == "varnish_vhosts" ]; then
        if [ -e $CONF ] ; then
            rm -rf $CONF
        fi
(echo "backend default {
    .host = \"$IP_1\";
    .port = \"82\";
    .connect_timeout = 600s;
    .first_byte_timeout = 600s;
    .between_bytes_timeout = 600s;
}" >>  $CONF)
        for i in `cat $TMPF`
        do
            REV=`echo $i | sed 's/\./_/g'`
(echo "backend be$REV {
    .host = \"$i\";
    .port = \"82\";
    .connect_timeout = 600s;
    .first_byte_timeout = 600s;
    .between_bytes_timeout = 600s;
}" >>  $CONF )
        done
    
	    for i in `cat $TMPF`
        do
            REV=`echo $i | sed 's/\./_/g'`
(echo "acl acl$REV {
\"$i\";
}" >> $CONF)
        done
        ###############ACL VERIFICATION##########
        if [ -e $CONF1 ]; then
            rm -rf $CONF1
        fi
        AIP=`hostname -i`
        AIR=`echo $AIP  | sed 's/\./_/g'`
echo "if (server.ip ~ acl$AIR) {
set req.backend = be$AIR;
}" >> $CONF1

        for i in `cat $TMPF|grep -v $AIP`
        do
            AREV=`echo $i | sed 's/\./_/g'`
echo "else if (server.ip ~ acl$AREV) {
set req.backend = be$AREV;
}" >> $CONF1
        done
        #---
        echo
        echo -e "... $GREEN[ DONE ]$RESET"
        echo
        echo "---------------------------"
        pause "Pressione [Enter] para Continuar..."
        echo
    else
        dialog --backtitle "$NOMEFINAL" --title "vhost.vcl" --infobox "Gerando o /usr/local/varnish/etc/varnish/vhost.vcl" 5 60
        if [ -e $CONF ] ; then
            rm -rf $CONF
        fi
(echo "backend default {
    .host = \"$IP_1\";
    .port = \"82\";
    .connect_timeout = 600s;
    .first_byte_timeout = 600s;
    .between_bytes_timeout = 600s;
}" >>  $CONF)
        for i in `cat $TMPF`
        do
            REV=`echo $i | sed 's/\./_/g'`
(echo "backend be$REV {
    .host = \"$i\";
    .port = \"82\";
    .connect_timeout = 600s;
    .first_byte_timeout = 600s;
    .between_bytes_timeout = 600s;
}" >>  $CONF )
        done
    
	    for i in `cat $TMPF`
        do
            REV=`echo $i | sed 's/\./_/g'`
(echo "acl acl$REV {
\"$i\";
}" >> $CONF)
        done
		sleep 3
        ###############ACL VERIFICATION##########
        dialog --backtitle "$NOMEFINAL" --title "acl.vcl" --infobox "Gerando o /usr/local/varnish/etc/varnish/acl.vcl" 5 60
        if [ -e $CONF1 ]; then
            rm -rf $CONF1
        fi
        AIP=`hostname -i`
        AIR=`echo $AIP  | sed 's/\./_/g'`
echo "if (server.ip ~ acl$AIR) {
set req.backend = be$AIR;
}" >> $CONF1

        for i in `cat $TMPF|grep -v $AIP`
        do
            AREV=`echo $i | sed 's/\./_/g'`
echo "else if (server.ip ~ acl$AREV) {
set req.backend = be$AREV;
}" >> $CONF1
        done
		sleep 3
		dialog --backtitle "$NOMEFINAL" --title "Varnish Vhosts" --msgbox "Operacao finalizada, ficheiros gerados!!!!!" 6 60
        MENUprincipal
    #---
    fi
}

#    *********************************************************************************************
#    | SECTION:VARNISH -> END
#    .................................................................
