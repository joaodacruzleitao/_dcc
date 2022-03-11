#!/usr/bin/env bash
#Copyright (c) 2008-2012 http://datasource.pt/

###################################################################################################################
# VARIAVEIS > Begin
###
DT=$(date +"%d%m%y-%H%M%S")
SCRIPT_VERSION=$(jq /scripts/_dcc.v.json)
SCRIPT_DATE="31/08/2012"
SCRIPT_AUTHOR='Joao Leitao (j@xanubi.com)'
SCRIPT_URL='http://www.datasource.pt'
COPYRIGHT="Copyright (C) 2012-2050"
DISCLAIMER='This software is provided "as is" in the hope that it will be useful, but WITHOUT ANY WARRANTY, to the extent permitted by law; without even the implied warranty of MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.'
PROGRAMANOME='DataSource Control Center'
NOMEF="$PROGRAMANOME $SCRIPT_VERSION ($SCRIPT_DATE)\n$COPYRIGHT $SCRIPT_AUTHOR"
NOMEFINAL="$PROGRAMANOME $SCRIPT_VERSION ($SCRIPT_DATE)      Author: $SCRIPT_AUTHOR"

# Cores do Setup
black='\E[30;40m'
red='\E[31;40m'
green='\E[32;40m'
yellow='\E[33;40m'
blue='\E[34;40m'
magenta='\E[35;40m'
cyan='\E[36;40m'
white='\E[37;40m'
#
boldblack='\E[1;30;40m'
boldred='\E[1;31;40m'
boldgreen='\E[1;32;40m'
boldyellow='\E[1;33;40m'
boldblue='\E[1;34;40m'
boldmagenta='\E[1;35;40m'
boldcyan='\E[1;36;40m'
boldwhite='\E[1;37;40m'
#
#  Reset text attributes to normal without clearing screen.
Reset="tput sgr0"
#
RED='\033[01;31m'
GREEN='\033[01;32m'
RESET='\033[0m'
RED='\033[01;31m'
GREEN='\033[01;32m'
RESET='\033[0m'

ENABLE_MENU='y'

###
# VARIAVEIS < END
#==================================================================================================================
