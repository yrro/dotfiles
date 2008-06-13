# .bashrc is sourced for an interactive shell.

#echo .bashrc

# For some reason, openssh invokes bash as an interactive shell even if we
# are only using scp. Therefore check that we have a terminal before processing
# this file
tty --silent || return

# disable XON/XOFF so that we can use readline's forward-search-history command
# by pressing C-s
stty -ixon

shopt -s cdspell
shopt -s failglob
shopt -s histverify
shopt -s no_empty_cmd_completion

export GREP_OPTIONS='--color=auto'

if test -n "$DISPLAY"
then
	EDITOR=gvim
	BROWSER=gnome-open
else
	EDITOR=vim
	BROWSER=w3m
fi
export EDITOR BROWSER

export MANHTMLPAGER=$BROWSER

export PAGER=less
export LESS='-icR'
command -v lesspipe &>/dev/null && eval "$(lesspipe)"

command -v dircolors &>/dev/null && eval "$(dircolors)"

# best prompt ever!
#
function smile {
	if test $? = 0; then
		echo -ne "${csi_green}:)"
	else
		echo -ne "${csi_red}:("
	fi
}
function user_colour {
	if test "$UID" = 0; then
		echo -ne "${csi_red}"
	else
		echo -ne "${csi_green}"
	fi
}
csi='\e['
csi_default=${csi}0m
csi_cyan=${csi}36m
csi_green=${csi}32m
csi_red=${csi}31m
csi_gold=${csi}33m
PS1="\n\$(smile) ${csi_cyan}\A $(user_colour)\u@\h ${csi_gold}\w${csi_default} \n\\$ "

HISTCONTROL=ignoreboth
HISTSIZE=5000

# xterm/screen title
#
case "$TERM" in
xterm*|rxvt*|screen)
	PROMPT_COMMAND='echo -ne "\e]2;${HOSTNAME}:${PWD/#$HOME/~}\a"'
	# ESC]2;{string}BELL
	;;
esac

function gvimcpp {
	gvim $1.cpp "+new $1.h"
}

#function remotesign {
#	set -e
#
#	host="$1"
#
#	while shift; do
#		test -n "$1" || continue
#
#		data=$(ssh "$host" cat "$file")
#		sign=$(gpg --armor --detach-sign <<< "$data")
#		ssh "$host" cat '>' "$file.asc"
#	done
#}

function envof {
	file=/proc/${1:?Usage: $0 pid}/environ
	cmd="cat $file"
	test -r $file || cmd="sudo $cmd"
	$cmd | tr '\0' '\n'
}

function physize {
	echo $(( $(stat -c '%B * %b' "$1") / 1024 )) "$1"
}

function block {
	sudo iptables -I OUTPUT -d "$1" -j DROP
}

function batchfg {
	foo="$(awk '{print $1}' /proc/loadavg) < 1.5"
	while test "$(bc <<< "$foo")" = '0'; do
		foo="$(awk '{print $1}' /proc/loadavg) < 1.5"
		sleep 5
	done
	"$@"
}

#function info {
#	gnome-open "http://localhost/cgi-bin/info2www?($1)$2"
#}

function svngrep {
	find -name '.svn' -prune -or -print0 | xargs -0 grep "$@"
}

#test -r /etc/bash_completion && source /etc/bash_completion

alias apt='aptitude'
alias dquilt='QUILT_PATCHES=debian/patches quilt'
alias dux='du -xm --max-depth=1'
alias e="$EDITOR"
#alias gdb='LD_LIBRARY_PATH=/usr/lib/debug gdb -silent'
alias gdb='gdb -silent'
#alias gnutls-cli="gnutls-cli --x509cafile /etc/ssl/certs/ca-certificates.crt"
alias la='ls -A'
alias ll='ls -lh'
alias ls='ls --color=auto'
alias massif='valgrind --tool=massif --depth=5 --alloc-fn={g_malloc,g_realloc,g_try_malloc,g_malloc0,g_mem_chunk_alloc}'
alias mysql='mysql --pager'
alias open='gnome-open'
alias pol='apt-cache policy'
alias rm='rm --preserve-root'
alias wgoat='wget'
alias whois='whois -H'
alias xse='tail --follow=name ~/.xsession-errors -n 0'

case $HOSTNAME in
xerces)
	alias hdsleep='sudo hdparm -y /dev/hd[acdef]'
	#alias update-menus='update-menus --nodefaultdirs --menufilesdir ~/.menu/'
	;;
esac
