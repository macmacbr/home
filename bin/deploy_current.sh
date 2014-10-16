#!/bin/bash

QUIET=false;
VERBOSE=false;
if [ "${1}" = "-q" ];then
	FULLREPORT="false && ";
	QUIET=true;
	shift;
else
	if [ "${1}" = "-v" ];then
		VERBOSE=true;
		shift;
	fi
fi

proj=push;
if [ "${1}" = "stage" ];then
	proj=stage;
	shift;
else
	if [ "${1}" = "push" ];then
		shift;
	fi
fi

PROJECT=SUv5-${proj}-commitid
LASTBUILD="$(curl -s --fail 'http://10.10.3.72:8080/job/'${PROJECT}'/lastSuccessfulBuild/buildNumber')"
if [ "${1/-/}" != "${1}" ];then
    BUILD=${1/-/}
    BUILD=$((${LASTBUILD}-${BUILD}))
else
    BUILD=${1:-lastSuccessfulBuild}
fi
TIME=$(curl -s --fail 'http://10.10.3.72:8080/job/'${PROJECT}'/'${BUILD}'/api/xml?tree=id'|sed -e 's/^.*<id>\(.*\)<\/id>.*$/\1/')

curl -s --fail 'http://10.10.3.72:8080/job/'${PROJECT}'/'${BUILD}'/logText/progressiveText?start=0' \
	|awk '/COMMITID:/{print $2;} \
	      /\[STEP\] Setting .* at the latest version for the repo /{print substr($3, 0, 7);} \
	      /Updating the servers/{p=1; next;} \
	      p && '"${FULLREPORT}"'/:.*OK \([0-9ms]+\)/{split($0,a,"[()]");++b[a[2]];}\
	      END{n=asorti(b,s); for(i = 1; i <= n; i++) { print b[s[i]]" x " s[i]; }}'

if $VERBOSE ;then
	if [ "${BUILD}" = "lastSuccessfulBuild" ] || [ -n ${LASTBUILD} -a ${LASTBUILD} -eq ${BUILD} ]; then
		echo "job #${LASTBUILD} from ${TIME}."
	else
		echo "job #${BUILD} [<${LASTBUILD}] from ${TIME}."
	fi
fi
