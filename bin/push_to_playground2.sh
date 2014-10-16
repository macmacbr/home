#!/bin/bash
LOGFILE=~/log/pushtoplayground2
REMOTEHOME=${HOME/\/Users\//\/home\/}

source $(dirname $0)/locker.sh

rm -fr ${LOGFILE} 2>/dev/null

touch ${LOGFILE}

tail -f ${LOGFILE} &

a="-";
function g() {
    a=$(echo -n "$a" | sed -e 'y#-\\|/#\\|/-#'); 
    echo -e -n "  $a \r";
}

while sleep 1;do
    g;
	ssh -o "BatchMode=yes" -o "ConnectTimeout=3" -o "ServerAliveInterval=3" -q playground2 "echo -n "\r" 2>&1" && \
	rsync -apzuri --delete ${HOME}/IdeaProjects/emailqueue/ -e 'ssh -o "ConnectTimeout=10"' 'playground2:'${REMOTEHOME}'/git/emailqueue' --exclude '*.*~' --exclude '*.swp' --exclude 'build' --exclude '*logs' --exclude '*log' --exclude 'out' 2>&1 \
    |xargs -L 1 -I% echo "$(date +%H:%M:%S)%" >${LOGFILE}
done

