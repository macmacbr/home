#!/bin/bash

DBHOST=mysql_host_ip
DBPORT=mysql_port
if [ -f ${HOME}/git/serviceconfig/userdb_readonly_creds.yaml ];then
	DBUSER=$(grep username ${HOME}/git/serviceconfig/userdb_readonly_creds.yaml|cut -d: -f2|sed -e 's/ //g')
	DBPASS=$(grep password ${HOME}/git/serviceconfig/userdb_readonly_creds.yaml|cut -d: -f2|sed -e 's/ //g')
else
	echo "Missing credentials file"
	exit 1
fi

if [ "$1" == "-show" ];then
    echo "mysql -h ${DBHOST} -P ${DBPORT} -u${DBUSER} -p${DBPASS}"
    exit 0
fi

if [ -z "$1" ];then
mysql -h ${DBHOST} -P ${DBPORT} -u${DBUSER} -p${DBPASS}
else
mysql -h ${DBHOST} -P ${DBPORT} -u${DBUSER} -p${DBPASS} "$@" 
fi
