if [ -n "$PS1" ];then
	source ~/.bashrc

	PS1='[    \[$(e=$?; [ $e -gt 0 ] && tput setaf 1; tput cub 4; printf "%3d " $e; tput setaf 6)\]\h:\w \[$(tput sgr0)\]]\$ '
	alias ls='ls -Gp'
	alias ll='ls -l'
	alias rm='rm -i'
	alias cds='pushd ~/git/stumble'
	alias cdp='pushd ~/git/portal'
    alias git_graphical='git log --graph --full-history --all --color         --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"'
    alias acknoExt='ack --ignore-directory=ext --ignore-directory=test'

	export HISTIGNORE="cd:ls:ls -l:fg:bg"
	export HISTCONTROL=ignorespace:ignoredups

fi

[ -f ~/.bash_functions ] && . ~/.bash_functions

# added by Anaconda 1.9.2 installer
export PATH="/Applications/anaconda/bin:$PATH"
