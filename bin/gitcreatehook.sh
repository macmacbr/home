#!/bin/bash

ROOTDIR=$(git rev-parse --show-toplevel)
if [ -z "${ROOTDIR}" ];then
    echo "Need to be inside the proper git repository"
    exit 1;
fi

if [ -d .git ];then
    pushd ${ROOTDIR}
    scp -p -P 2222 review.stumble.net:hooks/commit-msg .git/hooks/
    REMOTE=$(git remote show origin|awk -F'[:/]' '/Fetch URL/{split($NF,a,".");print a[1];}')
    if ! git remote -v |grep -e '^review';then
        git remote add review "ssh://review.stumble.net:2222/${REMOTE}"
    else
        echo "Remote already set for 'review'"
        git remote -v
    fi
    echo "Command to run commit is: "
    echo "git push review HEAD:refs/for/master"
else
    echo ".git directory not found";
    exit 2;
fi
