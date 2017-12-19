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
LOG_NAME=exportJDBC.$DOMAIN_NAME.`date '+%Y%m%d'`.txt
cd $DOMAIN_HOME/bin
. $HOME/setDomainEnv.sh
if [ "$WLS_VER" = "11g" ]; 
	then WLST_HOME=$WL_HOME/common/bin/
elif [ "$WLS_VER" = "12c" ]; 
	then WLST_HOME=$ALSB_HOME/tools/configjar/
else 
	echo "Favor ingresar correctamente los parametros.";
	exit;
fi
#Ejecucion de WLST.
$WLST_HOME/wlst.sh $HOME/exportJDBC.py $URL_CONSOLE > $HOME/$LOG_NAME
#Filtrado de resultados.
grep -i 'jdbc:' $HOME/$LOG_NAME > $HOME/logpaso.txt
sed -i 's/ //g' $HOME/logpaso.txt
#Paso a planilla
echo "NAME;JNDI;URL;USER;PASS;TYPE" > $HOME/exportJDBC.$DOMAIN_NAME.csv
more $HOME/logpaso.txt >> $HOME/exportJDBC.$DOMAIN_NAME.csv
rm $HOME/logpaso.txt

