# .bash_profile is sourced for a login shell.
# my .xsessionrc sources it, so place in here 'session' type configuration.
# 
# <http://lists.gnu.org/archive/html/bug-bash/2005-01/msg00263.html> is a good
# explanation of this insanity. Also <http://lkml.org/lkml/2005/4/25/205>.

#echo .bash_profile

export PATH=$PATH:$HOME/bin

#export SDL_AUDIODRIVER=alsa

test -f ~/.pythonrc && export PYTHONSTARTUP=~/.pythonrc

export DEBEMAIL="sam@robots.org.uk"
export DARCS_EMAIL="Sam Morris <sam@robots.org.uk>"
export BZR_EMAIL="sam@robots.org.uk"

case $HOSTNAME in
albion)
	#eval $(ssh-agent)
	;;
esac

# Source .bashrc if this is an interactive shell
case $- in
*i*)
	source ~/.bashrc
	;;
esac
