#!/bin/bash
#Copy whole directories from server1 to server2
# $0 /path/to/dir/ sourceserver targetserver

DIR=${1:?Need a directory}
shift
SERVER1=${1:?Need source server}
shift
SERVER2=${1:?Need target server}
shift

set -x
ssh -t ${SERVER2} -R12345:${SERVER1}:22 'cd /;sudo rsync -avz -e "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -t -l '$(whoami)' -p 12345" localhost:'"${DIR} ${DIR}"
