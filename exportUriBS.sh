#!/bin/sh
#Parametro 1 = ruta del dominio
#Parametro 2 = url de consola, en formato t3://host:port
#Parametro 3 = Version de WLS (11g o 12c)
HOME=$(pwd)
DOMAIN_HOME=$1
URL_CONSOLE=$2
WLS_VER=$3
#Seteo de Variables.
DOMAIN_NAME=$(echo $DOMAIN_HOME | awk -F"/" '{print $8}')
LOG_NAME=exportUri.$DOMAIN_NAME.`date '+%Y%m%d'`.txt
cd $DOMAIN_HOME/bin
. ./setDomainEnv.sh
if [ "$WLS_VER" = "11g" ]; 
	then WLST_HOME=$WL_HOME/common/bin/
elif [ "$WLS_VER" = "12c" ]; 
	then WLST_HOME=$ALSB_HOME/tools/configjar/
else 
	echo "Favor ingresar correctamente los parametros.";
	exit;
fi
#Ejecucion de WLST.
$WLST_HOME/wlst.sh $HOME/exportUriBS.py $URL_CONSOLE > $HOME/$LOG_NAME
#Filtrado de resultados.
grep -i 'EXP\|COMP\|IMPL\|business\|	\|tran:uri\|#' $HOME/$LOG_NAME > $HOME/logpaso.txt
#grep -i '#' $HOME/$LOG_NAME > $HOME/logpaso.txt
#grep -v "COMP\|IMPL" $HOME/logpaso.txt > $HOME/$LOG_NAME
sed ':a;N;$!ba;s/\n/ /g' $HOME/logpaso.txt | sed -e 's/<[^>]*>//g' > $HOME/$LOG_NAME
rm $HOME/logpaso.txt
