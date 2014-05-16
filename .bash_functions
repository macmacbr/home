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
