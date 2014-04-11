if [ -n "$PS1" ];then
	source ~/.bashrc

	PS1='[    \[$(e=$?; [ $e -gt 0 ] && tput setaf 1; tput cub 4; printf "%3d " $e; tput setaf 6)\]\h:\w \[$(tput sgr0)\]]\$ '
	alias ls='ls -Gp'
	alias ll='ls -l'
	alias rm='rm -i'
	alias cds='pushd ~/git/stumble'
	alias cdp='pushd ~/git/portal'


	export HISTIGNORE="cd:ls:ls -l:fg:bg"
	export HISTCONTROL=ignorespace:ignoredups

fi
function savemarcoenv {
	cd && ( [ -f marco.tgz ] && rm -f marco.tgz ); tar -czf marco.tgz .bash* .vim* bin
	cd -
}

function cdlast {
	cd $(ls -tr -1 |tail -1)
}
