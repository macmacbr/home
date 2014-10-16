#!/bin/bash

LOCKERCMDNAME=strongview_submit_flush $(dirname $0)/locker.sh

SU_ENV=${1:-dev}
echo "ENV = ${SU_ENV}"

SU_BASEDIR=${HOME}/git/stumble
SU_INC=${SU_BASEDIR}/ext/portal/www/mysql/include
SU_EMAIL_FLUSH=true 

cd ${SU_BASEDIR}
/usr/bin/php lib/gearman/workers/strongview_digest.php >/dev/null
