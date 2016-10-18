# For X11, tell terminal emulators to launch Bash as a login shell. Previously
# this was sources by ~/.xsessionrc to apply to all X11 programs, but that
# changed once gnome-terminal began requiring /etc/profile.d/vte.sh to be
# sourced by every shell.
#
# <http://lists.gnu.org/archive/html/bug-bash/2005-01/msg00263.html> is a good
# explanation of this insanity. Also <http://lkml.org/lkml/2005/4/25/205>.

export EMAIL=sam@robots.org.uk
export BZR_EMAIL="$EMAIL"
export NAME='Sam Morris'
export PATH=$PATH:$HOME/bin:$HOME/.local/bin

test -f ~/.pythonrc && export PYTHONSTARTUP=$HOME/.pythonrc

case "$(uname -s)" in
CYGWIN_*)
	# Received wisdom from Cygwin's default .bashrc
	unset TMP
	unset TEMP
	;;
Darwin)
	export CLICOLOR=1
	;;
esac

case "${HOSTNAME%%.*}" in
traxus)
	export TZ=Europe/London
	;;
esac

if [[ -n $SSH_AUTH_SOCK && -n $TMUX && ! -L $SSH_AUTH_SOCK ]]; then
	ln -sfr  "$SSH_AUTH_SOCK" "$TMUX.ssh"
	SSH_AUTH_SOCK="$TMUX.ssh"
fi

# Source .bashrc if this is an interactive shell
case $- in
*i*)
	source ~/.bashrc
	;;
esac

etckeeper_check
