#!/usr/bin/env bash
#Copyright (c) 2022 https://dcc.airjoni.xyz

#***-------------------------------------------------------------------------------------------***
# VARIAVEIS > Begin
#---***

#***----------------------------------------------***
#    Read the configuration file _dcc.config.yaml
#***----------------------------------------------***
#- userdata: -#
UZER=$(shyaml get-value userdata.user < _dcc.config.yaml)
FTPPASS=$(shyaml get-value userdata.ftppass  < _dcc.config.yaml)
#- destination: -#
DESTINO1=$(shyaml get-value destination.destino1 < _dcc.config.yaml)
DESTINO2=$(shyaml get-value destination.destino2 < _dcc.config.yaml)
###- Especial para a funcao BACKUPnas2 -###
BACKUPGERAL1=$(shyaml get-value destination.backupgeral1 < _dcc.config.yaml)
###-E!
###- Especial para a funcao BACKUPdiario -###
DIRBTMP=$(shyaml get-value destination.dirbtmp < _dcc.config.yaml)
DUPLICITY1=$(shyaml get-value destination.duplicity1 < _dcc.config.yaml)
DUPLICITY2=$(shyaml get-value destination.destino2 < _dcc.config.yaml)
###-E!
#- servidores: -#
DIAS=$(shyaml get-value servers.dias < _dcc.config.yaml)
SERVIDORBACKUP=$(shyaml get-value servidores.servidorip < _dcc.config.yaml)
###- General EMAIL Destination for program sending email
EMAIL_de_ENVIO=$(shyaml get-value servidores.emailDeDestino < _dcc.v.yaml)
###-E!
#- script: -#
###- read from file _dcc.v.yaml, specially made only for version
SCRIPT_VERSION=$(shyaml get-value userdata.user < _dcc.v.yaml)
###-E!
SCRIPT_DATE=$(shyaml get-value script.date < _dcc.v.yaml)
SCRIPT_AUTHOR=$(shyaml get-value script.author < _dcc.v.yaml)
SCRIPT_URL=$(shyaml get-value script.url < _dcc.v.yaml)
COPYRIGHT=$(shyaml get-value script.disclaimer < _dcc.v.yaml)
#- script: -#
PROGRAMANOME=$(shyaml get-value script.programanome < _dcc.v.yaml)
NOMEF="${PROGRAMANOME} ${SCRIPT_VERSION} (${SCRIPT_DATE})\n${COPYRIGHT} ${SCRIPT_AUTHOR}"
NOMEFINAL="${PROGRAMANOME} ${SCRIPT_VERSION} (${SCRIPT_DATE})      Author: $SCRIPT_AUTHOR"
#***----------------------------------------------***

#***----------------------------------------------***
#    Declare fixed values
#***----------------------------------------------***
###- Get date and time
DT=$(date +"%d%m%y-%H%M%S")
###-E!
#- Cores do Setup -#
#  1.
black='\E[30;40m'
red='\E[31;40m'
green='\E[32;40m'
yellow='\E[33;40m'
blue='\E[34;40m'
magenta='\E[35;40m'
cyan='\E[36;40m'
white='\E[37;40m'
#  2.
boldblack='\E[1;30;40m'
boldred='\E[1;31;40m'
boldgreen='\E[1;32;40m'
boldyellow='\E[1;33;40m'
boldblue='\E[1;34;40m'
boldmagenta='\E[1;35;40m'
boldcyan='\E[1;36;40m'
boldwhite='\E[1;37;40m'
###- Reset text attributes to normal without clearing screen.
Reset="tput sgr0"
#  3.
RED='\033[01;31m'
GREEN='\033[01;32m'
RESET='\033[0m'
RED='\033[01;31m'
GREEN='\033[01;32m'
RESET='\033[0m'
###- y : enable menu / n : disable  menu
ENABLE_MENU='y'
###-E!

#---***
# VARIAVEIS < END
#***-------------------------------------------------------------------------------------------***
