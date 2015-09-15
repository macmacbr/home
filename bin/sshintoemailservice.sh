#!/bin/bash

ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no emailserver3 -p 2223 -l core "$@"
