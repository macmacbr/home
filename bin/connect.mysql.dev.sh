#!/bin/bash

DBHOST=10.10.3.4
DBPORT=43564
if [ -f ${HOME}/git/serviceconfig/userdb_readonly_creds.yaml ];then
	DBUSER=$(grep username ${HOME}/git/serviceconfig/userdb_readonly_creds.yaml|cut -d: -f2|sed -e 's/ //g')
	DBPASS=$(grep password ${HOME}/git/serviceconfig/userdb_readonly_creds.yaml|cut -d: -f2|sed -e 's/ //g')
else
	echo "Missing credentials file"
	exit 1
fi

if [ -z "$1" ];then
echo mysql -h ${DBHOST} -P ${DBPORT} -u${DBUSER} -p${DBPASS}
else
mysql -h ${DBHOST} -P ${DBPORT} -u${DBUSER} -p${DBPASS} "$@" 
fi
