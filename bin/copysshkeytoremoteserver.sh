#!/bin/bash

SERVER=${1}; shift
USER=${2:$(whoami)}; shift

if [ -z "${SERVER}" ];then
	echo "need a server"
	exit 1;
fi

ssh -t ${SERVER} -R60000:localhost:22 'sudo bash -c "ssh -t -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 60000 localhost -l '${USER}' \"cat ~/.ssh/id_rsa.pub\"|cat - >/etc/ssh/userkeys/'${USER}'.pub"'
