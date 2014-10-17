#!/bin/bash
function savemarcoenv {
	cd && ( [ -f marco.tgz ] && rm -f marco.tgz ); tar -czf marco.tgz .bash* .vim* bin
	cd -
}

function cdlast {
	cd $(ls -tr -1 |tail -1)
}

function hostnamefromhosts {
    awk '/'$(hostname)'/{print $3;}' /etc/hosts
}

function pwdCheckSymlinks {
    real='..'
    dest=$1;
    shift;
    if [ "${dest:0:1}" != "/" ];then
        dest="$(pwd -P)/${dest}"
    fi

    pushd $dest >/dev/null && real=$(pwd -P)
    if [ $real != $dest ];then
        diff  <(echo $dest) <(echo $real)|awk '/^[<>]/{print $0;}'
        popd >/dev/null
        false;
    else
        echo "They are the same"
        popd >/dev/null
        true 
    fi
}

update_tmux() {
    # Check for tmux session
    if [ -n "$TMUX" ]; then     
        TMUX_STATUS_LOCATION="right"
        #REPO
        GIT_REPO=$(2>/dev/null basename $(2>/dev/null git rev-parse --show-toplevel)) 
        if [ -n "${GIT_REPO}" ];then
            #BRANCH
            GIT_BRANCH=$(2>/dev/null git symbolic-ref HEAD | sed "s/^refs\/heads\///")
            #DIRTY
            local status=$(2>/dev/null git status --porcelain 2> /dev/null)
            if [[ "$status" != "" ]]; then
                GIT_DIRTY=true
            else
                GIT_DIRTY=false
            fi

            #SETTING
            TMUX_STATUS="${GIT_REPO}:${GIT_BRANCH}"
          
            if $GIT_DIRTY; then 
                tmux set-window-option status-$TMUX_STATUS_LOCATION-attr bright > /dev/null
            else
                tmux set-window-option status-$TMUX_STATUS_LOCATION-attr none > /dev/null
            fi
                
                
                tmux set-window-option status-$TMUX_STATUS_LOCATION "$TMUX_STATUS" > /dev/null            
         else
                tmux set-window-option status-$TMUX_STATUS_LOCATION-attr none > /dev/null
                tmux set-window-option status-$TMUX_STATUS_LOCATION "no git" > /dev/null
                            
         fi
    fi
}
if [ "${PROMPT_COMMAND/update_tmux/}" == "${PROMPT_COMMAND}" ];then
    PROMPT_COMMAND="update_tmux; $PROMPT_COMMAND"
    export PROMPT_COMMAND
fi
