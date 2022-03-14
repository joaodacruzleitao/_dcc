#!/usr/bin/env bash
#Copyright (c) 2022 https://dcc.airjoni.xyz

#***-------------------------------------------------------------------------------------------***
# VARIAVEIS > Begin
#---***

#***----------------------------------------------***
#    Read the configuration file _config.yaml
#***----------------------------------------------***
#- userdata: -#
export UZER=$(shyaml get-value userdata.user < _dcc.config.yaml)
export FTPPASS=$(shyaml get-value userdata.ftppass  < _dcc.config.yaml)
#- destination: -#
export DESTINO1=$(shyaml get-value destination.destino1 < _dcc.config.yaml)
export DESTINO2=$(shyaml get-value destination.destino2 < _dcc.config.yaml)
###- Especial para a funcao BACKUPnas2 -###
export BACKUPGERAL1=$(shyaml get-value destination.backupgeral1 < _dcc.config.yaml)
###-E!
###- Especial para a funcao BACKUPdiario -###
export DIRBTMP=$(shyaml get-value destination.dirbtmp < _dcc.config.yaml)
export DUPLICITY1=$(shyaml get-value destination.duplicity1 < _dcc.config.yaml)
export DUPLICITY2=$(shyaml get-value destination.destino2 < _dcc.config.yaml)
###-E!
#- servidores: -#
export DIAS=$(shyaml get-value servers.dias < _dcc.config.yaml)
export SERVIDORBACKUP=$(shyaml get-value servidores.servidorip < _dcc.config.yaml)
###- General EMAIL Destination for program sending email
export EMAIL_de_ENVIO=$(shyaml get-value servidores.emailDeDestino < _dcc.v.yaml)
###-E!
#- script: -#
###- read from file _config.v.yaml, specially made only for version
export SCRIPT_VERSION=$(shyaml get-value userdata.user < _dcc.v.yaml)
###-E!
export SCRIPT_DATE=$(shyaml get-value script.date < _dcc.v.yaml)
export SCRIPT_AUTHOR=$(shyaml get-value script.author < _dcc.v.yaml)
export SCRIPT_URL=$(shyaml get-value script.url < _dcc.v.yaml)
export COPYRIGHT=$(shyaml get-value script.disclaimer < _dcc.v.yaml)
#- script: -#
export PROGRAMANOME=$(shyaml get-value script.programanome < _dcc.v.yaml)
export NOMEF="${PROGRAMANOME} ${SCRIPT_VERSION} (${SCRIPT_DATE})\n${COPYRIGHT} ${SCRIPT_AUTHOR}"
export NOMEFINAL="${PROGRAMANOME} ${SCRIPT_VERSION} (${SCRIPT_DATE})      Author: $SCRIPT_AUTHOR"
#***----------------------------------------------***

#***----------------------------------------------***
#    Declare fixed values
#***----------------------------------------------***

export ScriptTnamE=$(basename "$0")
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
