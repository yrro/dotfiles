# .bash_profile is sourced for a login shell.
# my .gnomerc sources it, so place in here 'session' type configuration.
# 
# <http://lists.gnu.org/archive/html/bug-bash/2005-01/msg00263.html> is a good
# explanation of this insanity. Also <http://lkml.org/lkml/2005/4/25/205>.

#echo .bash_profile

export PATH=$PATH:$HOME/bin

#export SDL_AUDIODRIVER=alsa

export DEBEMAIL="sam@robots.org.uk"
export DARCS_EMAIL="Sam Morris <sam@robots.org.uk>"
export BZR_EMAIL="sam@robots.org.uk"

# see termcap(5) for an explanation of these codes
#export LESS_TERMCAP_mb=$'\E[01;31m' # start blink
export LESS_TERMCAP_md=$'\E[01;31m' # start bold
export LESS_TERMCAP_me=$'\E[0m' # back to normal
export LESS_TERMCAP_so=$'\E[01;44;33m' # start standout (status line)
export LESS_TERMCAP_se=$'\E[0m' # end standout
export LESS_TERMCAP_us=$'\E[01;32m' # start underline
export LESS_TERMCAP_ue=$'\E[0m' # end underline

case $HOSTNAME in
albion)
	eval $(ssh-agent)
	;;
esac

# Source .bashrc if this is an interactive shell
case $- in
*i*)
	source ~/.bashrc
	;;
esac
