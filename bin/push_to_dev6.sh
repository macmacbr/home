#!/bin/bash
LOGFILE=~/log/pushtosfodev6
REMOTEHOME=${HOME/\/Users\//\/home\/}

source $(dirname $0)/locker.sh

rm -fr ${LOGFILE} 2>/dev/null

touch ${LOGFILE}

tail -f ${LOGFILE} &

a="-";
function g() {
    a=$(echo "$a" | sed -e 'y#-\\|/#\\|/-#'); 
    echo -e -n "\r$a ";
}

while sleep 1;do
    g;
	ssh -o "BatchMode=yes" -o "ConnectTimeout=3" -o "ServerAliveInterval=3" -q sfodev6 "echo -n "\r" 2>&1" && \
	rsync -apzuri --delete ${HOME}/git/stumble/ -e 'ssh -o "ConnectTimeout=10"' 'sfodev6:'${REMOTEHOME}'/git/stumble' --exclude '*.*~' --exclude '*.swp' 2>&1 \
    |xargs -L 1 -I% echo "$(date +%H:%M:%S)%" >${LOGFILE}
done

