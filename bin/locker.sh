#!/bin/bash

 
#Shell vars to this script
# LOCKERCMDNAME=<optional name for this instance>. 
#     Will use your script name (when you use source locker,sh).
#     Will use the first parameter passed to locker.sh when it's
#       called directly.
# LOCKERKILLOLD=<optional signal name or number> to send to running PID, if you want to send anything to it.


# lock dirs/files
if [ ! -d /var/lock ] && [ ! -w /var/lock ];then
    echo "Please create /var/lock with write permissions" >&2
    exit 1;
fi

GIVEMEANAME=${LOCKERCMDNAME:-$(basename $0)}
if [ ${GIVEMEANAME} == "locker.sh" ];then
    echo "#running as locker.sh <command to run>"
    GIVEMEANAME=${LOCKERCMDNAME:-$1}
fi
if [ -z "${GIVEMEANAME}" ];then
    echo "Need either a command to run as parameter or to be included (sourced) in a script"
    echo "Note: you can set the LOCKERCMDNAME env variable for the program unique name."
    exit 2;
fi

LOCKDIR=/var/lock/${GIVEMEANAME}
PIDFILE="${LOCKDIR}/PID"
MYPID=${MYPID:-$$}
RUNCMD="$@"

# exit codes and text for them - additional features nobody needs :-)
ENO_SUCCESS=0; ETXT[0]="ENO_SUCCESS"
ENO_GENERAL=1; ETXT[1]="ENO_GENERAL"
ENO_LOCKFAIL=2; ETXT[2]="ENO_LOCKFAIL"
ENO_RECVSIG=3; ETXT[3]="ENO_RECVSIG"
 
###
### start locking attempt
###
 
trap 'ECODE=$?; echo "[locker] Exit: ${ETXT[ECODE]}($ECODE)"' 0
echo -n "[locker] Locking: " 
 
if mkdir "${LOCKDIR}" &>/dev/null; then
 
    # lock succeeded, install signal handlers before storing the PID just in case 
    # storing the PID fails
    if [ -n "${RUNCMD}" ];then
        trap 'ECODE=$?;
              echo "[locker] Killing PID ${MYPID}" >&2
              [ -n "${MYPID}" ] && kill -SIGTERM "${MYPID}" 2>/dev/null >/dev/null;
              echo "[locker] Removing lock. Exit: ${ETXT[ECODE]}($ECODE)" 
              rm -rf "${LOCKDIR}"' 0
        ${RUNCMD} &
        MYPID=$!
        echo -n "NEW "
    else
        trap 'ECODE=$?;
              echo "[locker] Removing lock. Exit: ${ETXT[ECODE]}($ECODE)" 
              rm -rf "${LOCKDIR}"' 0
    fi
    echo -n "PID=[${MYPID}]  - ";
    echo "${MYPID}" >"${PIDFILE}" 
    # the following handler will exit the script on receiving these signals
    # the trap on "0" (EXIT) from above will be triggered by this trap's "exit" command!
    trap 'echo "[locker] Killed by a signal." >&2
          exit ${ENO_RECVSIG}' 1 2 3 15
    echo "[locker] success, installed signal handlers"

    wait
else
 
    # lock failed, now check if the other PID is alive
    OTHERPID="$(cat "${PIDFILE}")"
 
    # if cat wasn't able to read the file anymore, another instance probably is
    # about to remove the lock -- exit, we're *still* locked
    #  Thanks to Grzegorz Wierzowiecki for pointing this race condition out on
    #  http://wiki.grzegorz.wierzowiecki.pl/code:mutex-in-bash
    if [ $? != 0 ]; then
      echo "lock failed, PID ${OTHERPID} is active" >&2
      exit ${ENO_LOCKFAIL}
    fi
    
    #Force kill if LOCKERKILLOLD has a number
	if [ -n "${LOCKERKILLOLD}" ];then
        #If process is there.
        if kill -0 $OTHERPID &>/dev/null ;then
            kill -${LOCKERKILLOLD} $OTHERPID 2>/dev/null
            sleep 3
        fi
    fi	

    if ! kill -0 $OTHERPID &>/dev/null; then
        # lock is stale, remove it and restart
        echo "removing stale lock of nonexistant PID ${OTHERPID}" >&2
        rm -rf "${LOCKDIR}"
        echo "[locker] restarting myself" >&2
        exec "$0" "$@"
    else
        # lock is valid and OTHERPID is active - exit, we're locked!
        echo "lock failed, PID ${OTHERPID} is still active" >&2
        exit ${ENO_LOCKFAIL}
    fi
 
fi

