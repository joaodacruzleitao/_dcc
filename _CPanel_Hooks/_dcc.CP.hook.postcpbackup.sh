#!/bin/bash
# Backup Manager post backup
# Copyright (C) DataSource Team @ 2014-2050
# Web site: http://www.datasource.pt/
##############################################
DIA=`date +%d`
MES=`date +%m`
ANO=`date +%Y`
DATACORRENTE="${ANO}-${MES}-${DIA}"
DATADOISDIAS=`date --date="2 days ago" +%Y-%m-%d`
DATASEMANAANTERIOR=`date --date="7 days ago" +%Y-%m-%d`
DATAMESANTERIOR=`date --date="1 month ago" +%Y-%m-%d`
nomeServo=`/bin/hostname`

/bin/umount /home/1backups >/dev/null 2>&1
sleep 5
/bin/mount /home/1backups >/dev/null 2>&1

DETETA=`/bin/mount | /bin/grep -i /home/1backups`
if [ "$DETETA" == "" ]; then
	/bin/mount /home/1backups
	DETETA2=`/bin/mount | /bin/grep -i /home/1backups`
	if [ "$DETETA2" != "" ]; then
		/usr/local/cpanel/bin/cpuwatch 5.0 /usr/bin/rsync -avh --progress --bwlimit=11520 /home/_backups/$DATACORRENTE/ /home/1backups/$DATACORRENTE/ >/dev/null 2>&1
		rm -rf /home/1backups/$DATADOISDIAS/ >/dev/null 2>&1
		rm -rf/home/_backups/$DATACORRENTE/ >/dev/null 2>&1

		#_________________________
		# Copia o backup SEMANAL, se for caso disso
		if [[ $(date +%u) -eq 7 ]]; then
			/usr/local/cpanel/bin/cpuwatch 5.0 /usr/bin/rsync -avh --progress --bwlimit=11520 /home/_backups/weekly/$DATACORRENTE/ /home/1backups/weekly/$DATACORRENTE/ >/dev/null 2>&1
			rm -rf /home/1backups/weekly/$DATASEMANAANTERIOR/ >/dev/null 2>&1
			rm -rf/home/_backups/weekly/$DATACORRENTE/ >/dev/null 2>&1
		fi
		#_________________________
		
		#_________________________
		# Copia o backup MENSAL, se for caso disso
		if [[ $(date +%d) == "01" ]]; then
			/usr/local/cpanel/bin/cpuwatch 5.0 /usr/bin/rsync -avh --progress --bwlimit=11520 /home/_backups/monthly/$DATACORRENTE/ /home/1backups/monthly/$DATACORRENTE/ >/dev/null 2>&1
			rm -rf /home/1backups/monthly/$DATAMESANTERIOR/ >/dev/null 2>&1
			rm -rf/home/_backups/monthly/$DATACORRENTE/ >/dev/null 2>&1
		fi
		#_________________________

		chmod -R 755 /home/1backups >/dev/null 2>&1
		/bin/umount /home/1backups
		sleep 5
		/bin/mount /home/1backups
	else
		BODY="ERRO NFS\n\nTime: `date`\nBackups nao foram copiados para o /home/1backups.\n\nLiga-te ao servidor e verifica o que se passou, pois nao se conseguiu montar a drive.\n"
		MAIL="Subject: (BACKUP ERRO) on ${nomeServo}\nFrom: root@`hostname`\nTo: root@`hostname`\n\n$BODY"  
		echo -e $MAIL | sendmail -t
	fi
else
	/usr/local/cpanel/bin/cpuwatch 5.0 /usr/bin/rsync -avh --progress --bwlimit=11520 /home/_backups/$DATACORRENTE/ /home/1backups/$DATACORRENTE/ >/dev/null 2>&1
	rm -rf /home/1backups/$DATADOISDIAS/ >/dev/null 2>&1
	rm -rf/home/_backups/$DATACORRENTE/ >/dev/null 2>&1

	#_________________________
	# Copia o backup semanal, se for caso disso
	if [[ $(date +%u) -eq 7 ]]; then
		/usr/local/cpanel/bin/cpuwatch 5.0 /usr/bin/rsync -avh --progress --bwlimit=11520 /home/_backups/weekly/$DATACORRENTE/ /home/1backups/weekly/$DATACORRENTE/ >/dev/null 2>&1
		rm -rf /home/1backups/weekly/$DATASEMANAANTERIOR/ >/dev/null 2>&1
		rm -rf/home/_backups/weekly/$DATACORRENTE/ >/dev/null 2>&1
	fi
	#_________________________
		
	#_________________________
	# Copia o backup MENSAL, se for caso disso
	if [[ $(date +%d) == "01" ]]; then
		/usr/local/cpanel/bin/cpuwatch 5.0 /usr/bin/rsync -avh --progress --bwlimit=11520 /home/_backups/monthly/$DATACORRENTE/ /home/1backups/monthly/$DATACORRENTE/ >/dev/null 2>&1
		rm -rf /home/1backups/monthly/$DATAMESANTERIOR/ >/dev/null 2>&1
		rm -rf/home/_backups/monthly/$DATACORRENTE/ >/dev/null 2>&1
	fi
	#_________________________

	chmod -R 755 /home/1backups >/dev/null 2>&1
	/bin/umount /home/1backups
	sleep 5
	/bin/mount /home/1backups
fi
exit 0
