#!/bin/bash

PROJECT=SUv5-dryrun
LASTBUILD="$(curl -s --fail 'http://10.10.3.72:8080/job/'${PROJECT}'/lastSuccessfulBuild/buildNumber')"
if [ "${1/-/}" != "${1}" ];then 
    OFFSET=${1}
    BUILD=${1/-/}
    OFFSET2="-"$((${BUILD}+1))
    BUILD=$((${LASTBUILD}-${BUILD}))
else
    BUILD=${1:-lastSuccessfulBuild}
    unset OFFSET
    OFFSET2="-1"
    #curl -s --fail 'http://10.10.3.72:8080/job/SUv5-push-commitid/lastSuccessfulBuild/logText/progressiveText?start=0'
fi
TIME=$(curl -s --fail 'http://10.10.3.72:8080/job/'${PROJECT}'/'${BUILD}'/api/xml?tree=id'|sed -e 's/^.*<id>\(.*\)<\/id>.*$/\1/')o

STATUSSCRIPT=${0/deploy_status/deploy_current}

CURRENTSTAGE=$(${STATUSSCRIPT} -q stage ${OFFSET}|tr '\n\r' '  '|sed -e 's/ //g')
CURRENTCANARY=$(${STATUSSCRIPT} -q push ${OFFSET2}|tr '\n\r' '  '|sed -e 's/ //g')
CURRENTPROD=$(${STATUSSCRIPT} -q push ${OFFSET}|tr '\n\r' '  '|sed -e 's/ //g')

REPORTSTAGE=$(${STATUSSCRIPT} -v stage ${OFFSET}|sed '1d'|tr '\n' ' ')
REPORTCANARY=$(${STATUSSCRIPT} -v push ${OFFSET2}|sed '1d'|tr '\n' ' ')
REPORTPROD=$(${STATUSSCRIPT} -v push ${OFFSET}|sed '1d'|tr '\n' ' ')

if ! echo "${REPORTCANARY}" |grep canary >/dev/null;then
	CAUX="$CURRENTPROD"
	CURRENTPROD="$CURRENTCANARY"
	CURRENTCANARY="$CAUX"
	CAUX="$REPORTPROD"
	REPORTPROD="$REPORTCANARY"
	REPORTCANARY="$CAUX"

fi



curl -s --fail 'http://10.10.3.72:8080/job/'${PROJECT}'/'${BUILD}'/logText/progressiveText?start=0' \
   |awk -F'@' '/=== COMMIT HISTORY ===/{p=1;} \
                p {\
		   gsub(/[\r\n]/,"",$0);\
		   split($0,l,"@");\
		   print l[1];\
		   f=0;
		   if (index(l[1], "'"${CURRENTSTAGE:-pleasedontfindthis}"'") > 0) {\
			print "  |---> stage is    \n       '"${REPORTSTAGE}"'"; \
			f=1;\
		   }\
		   if (index(l[1], "'"${CURRENTCANARY:-pleasedontfindthis}"'") > 0) {\
			print "  |---> canary is   \n       '"${REPORTCANARY}"'"; \
			f=1;\
		   }\
		   if (index(l[1], "'"${CURRENTPROD:-pleasedontfindthis}"'") > 0) {\
			print "  |---> production is\n      '"${REPORTPROD}"'"; \
			f=1;\
		   }\
		   if (f) { print "     "; }\
		   next;\
	         }\
		 p'
		 
if [ "${BUILD}" = "lastSuccessfulBuild" ] || [ -n ${LASTBUILD} -a ${LASTBUILD} -eq ${BUILD} ]; then
	echo "job #${LASTBUILD} from ${TIME}."
else
	echo "job #${BUILD} [<${LASTBUILD}] from ${TIME}."
fi
