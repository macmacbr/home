#!/bin/bash

ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no emailstaging -p 2223 -l core "$@"
