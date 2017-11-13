#!/bin/bash

DOMAIN=$1
grep -H "timeout\|env:value" $DOMAIN/osb/config/core/*_IMPL/Bus*/*.xml > ./tmp.log

input="./tmp.log"
> ./paso.log
while IFS= read -r var
do
                timeOut=$(echo "$var" | awk -F "[><]" '/http:timeout/{print $3}')
                connTimeout=$(echo "$var" | awk -F "[><]" '/http:connection-timeout/{print $3}')
                bsName=$(echo "$var" | awk -F":" '{print $1}'  | awk -F"/" '{print $14}' | awk -F"." '{print $1}')
                uri=$(echo "$var" | awk -F "[><]" '/env:value/{print $3}')
                if [ -n "$uri" ];
                                then echo $bsName";"""'"'$uri'"'";" >> ./paso.log
                        elif [ -n "$timeOut" ];
                                        then echo $timeOut";" >> ./paso.log
                        elif [ -n "$connTimeout" ];
                                        then echo $connTimeout"#" >> ./paso.log
                        else
                                        echo ";;#" >> ./paso.log
                                        echo "ERROR en" $bsName
                fi
done < "$input"

#####################################################################
more paso.log | sed ':a;N;$!ba;s/\n/ /g' | tr '#' '\n' > filtro.log
sed -i 's/ //g' ./filtro.log
echo "BS;URI;Read TimeOut;Connection TimeOut" > ./exportTO.csv
more ./filtro.log >> ./exportTO.csv

