#!/bin/bash
mkdir -p ~/save
if [ -n "$1" ];then tar -cf - $1|tar -C ~/save -xf - && git checkout -- $1;fi
