#!/bin/bash
LOGFILE=~/log/pushtosfodev6
REMOTEHOME=${HOME/\/Users\//\/home\/}

source $(dirname $0)/locker.sh

rm -fr ${LOGFILE} 2>/dev/null

touch ${LOGFILE}

tail -f ${LOGFILE} &

a="-";
function g() {
    a=$(echo -n "$a" | sed -e 'y#-\\|/#\\|/-#'); 
    echo -e -n "$(date)  $a \r";
}

while sleep 1;do
    g;
	ssh -o "BatchMode=yes" -o "ConnectTimeout=3" -o "ServerAliveInterval=3" -q sfodev6 "echo -n "\r" 2>&1" && \
    for dir in non wanted directories;do
        rsync -apzuri --delete ${HOME}/git/${dir}/ -e 'ssh -o "ConnectTimeout=10"' 'sfodev6:'${REMOTEHOME}'/git/'${dir} --exclude '*.*~' --exclude '*.swp' 2>&1 \
        |xargs -L 1 -I% echo "$(date +%H:%M:%S)%" >${LOGFILE}
    done
done

