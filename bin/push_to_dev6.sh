#!/bin/bash
LOGFILE=~/log/pushtosfodev6
REMOTEHOME=${HOME/\/Users\//\/home\/}

source $(dirname $0)/locker.sh

rm -fr ${LOGFILE} 2>/dev/null

touch ${LOGFILE}

tail -f ${LOGFILE} &

while sleep 1;do
	ssh -o "BatchMode=yes" -o "ConnectTimeout=3" -o "ServerAliveInterval=3" -q sfodev6 "echo -n '' 2>&1" && \
	rsync -apzuri --delete ${HOME}/git/stumble/ -e ssh 'sfodev6:'${REMOTEHOME}'/git/stumble' --exclude '*.*~' --exclude '*.swp' 2>&1 \
	    |xargs -L 1 -I% echo "${date} %" >${LOGFILE}
done

