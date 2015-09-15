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
    alias grep='grep --color=auto'
    alias gitsetupstream='$(git push 2>&1|grep origin)'
    alias sbtsubmitcoursera="sbt 'submit macmac_br@yahoo.com.br 6QYYx4hQ35'"
    alias sshhostless='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
    alias missionControlRestart="osascript -e 'quit application \"Dock\"'"

	export HISTIGNORE="cd:ls:ls -l:fg:bg"
	export HISTCONTROL=ignorespace:ignoredups

    # remote pbcopy
    [ -n "$SSH_CLIENT" ] && alias pbcopy="nc localhost 62224"
fi

[ -f ~/.bash_functions ] && . ~/.bash_functions

# added by Anaconda 1.9.2 installer
export PATH="/usr/local/sbin:/Applications/anaconda/bin:$PATH"

##
# Your previous /Users/mcarvalho/.bash_profile file was backed up as /Users/mcarvalho/.bash_profile.macports-saved_2015-07-03_at_16:15:18
##

# MacPorts Installer addition on 2015-07-03_at_16:15:18: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

