# .bashrc is sourced for an interactive shell.

# For some reason, openssh invokes bash as an interactive shell even if we
# are only using scp. Therefore check that we have a terminal before processing
# this file
if [[ -n $SSH_CONNECTION ]] && !tty -s; then
	return
fi

# disable XON/XOFF so that we can use readline's forward-search-history command
# by pressing C-s
command -v stty &>/dev/null && stty stop undef && stty start undef

shopt -s cdspell
shopt -s globstar
shopt -s histappend
shopt -s histverify
shopt -s no_empty_cmd_completion
shopt -s failglob

case $(systemd-detect-virt) in
oracle)
	;;
*)
	export VISUAL=gvim
	;;
esac
export EDITOR=vim

command -v lesspipe > /dev/null && eval "$(lesspipe)"
# https://en.wikipedia.org/wiki/ANSI_escape_code
export LESS_TERMCAP_mb=$'\e[1;31m' # mode blink
export LESS_TERMCAP_md=$'\e[91m' # mode bold
export LESS_TERMCAP_me=$'\e[22;39m' # mode end
export LESS_TERMCAP_so=$'\e[44;93m' # standout
export LESS_TERMCAP_se=$'\e[39;49m' # standout end
export LESS_TERMCAP_us=$'\e[92m' # underline start
export LESS_TERMCAP_ue=$'\e[39m' # underline end

function colorfgbg {
	local x
	local fg
	#local bg
	# XXX why isn't vim taking this from the terminal directly?
	stty -echo
	echo -ne '\e]10;?\a'
	IFS=: read -r -t 0.1 -d $'\a' x fg
	#echo -ne '\e]11;?\a'
	#IFS=: read -t 0.1 -d $'\a' x bg
	if [[ ${fg:0:1} =~ [01234567] ]]; then
		export COLORFGBG='0;15'
	else
		export COLORFGBG='15;0'
	fi
	stty echo
}
#colorfgbg

command -v dircolors >/dev/null && eval "$(dircolors -b)"

# best prompt ever!
#
case $(locale charmap) in
UTF-8)
	_smile_happy='☺'
	_smile_frown='☹'
	;;
*)
	_smile_happy=':)'
	_smile_frown=':('
	;;
esac
function smile {
	if [[ $? -eq 0 ]]; then
		printf "${_csi_green}${_smile_happy}"
	else
		printf "${_csi_red}${_smile_frown}"
	fi
}
function user_colour {
	if test "$UID" = 0; then
		printf "${_csi_red}"
	else
		printf "${_csi_green}"
	fi
}
_csi_default=$'\e[39m'
_csi_cyan=$'\e[36m'
_csi_green=$'\e[32m'
_csi_red=$'\e[91m'
_csi_gold=$'\e[33m'
_csi_purple=$'\e[38;5;141m'
if [[ -e /usr/lib/git-core/git-sh-prompt ]]; then
	source /usr/lib/git-core/git-sh-prompt
else
	function __git_ps1 { :; }
fi
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM='verbose name'
function __java_ps1 {
	if [[ -n $JAVA_HOME ]]; then
		printf 'J=%s' "${JAVA_HOME##*/}"
	fi
}
function __systemd_ps1 {
	local s
	s=$(timeout 1 systemctl is-system-running 2>/dev/null)
	if [[ $s != running ]]; then
		printf '%s%s%s ' "${_csi_purple}" "system:${s:-?}" "${_csi_default}"
	fi
	s=$(timeout 1 systemctl --user is-system-running 2>/dev/null)
	if [[ $s != running ]]; then
		printf '%s%s%s ' "${_csi_purple}" "user:${s:-?}" "${_csi_default}"
	fi
}

PS1="\n\$(smile) ${_csi_cyan}\\A \$(user_colour)\\u@\\h \$(__systemd_ps1)${_csi_gold}\\w${_csi_default} \$(__git_ps1 '(%s) ')\$(__java_ps1)\n\\$ "

HISTCONTROL=ignorespace:ignoredups:erasedups
HISTSIZE=100000
#HISTFILESIZE=100000
shopt -s histappend

# xterm/screen title
#
case "$TERM" in
xterm*|rxvt*|screen)
	PS1="\\e]0;\\h:\\w\\a$PS1"
	;;
esac

PS0='$(history -a)'

function envof {
	local file="/proc/${1:?Usage: $0 pid}/environ"
	local cmd=(cat "$file")
	test -r "$file" || cmd=(sudo "${cmd[@]}")
	"${cmd[@]}" | tr '\0' '\n' | cat -v
}

function physize {
	echo $(( $(stat -c '%B * %b' "$1") / 1024 )) "$1"
}

function block {
	sudo iptables -I OUTPUT -d "$1" -j DROP
}

function batchfg {
	local foo="$(awk '{print $1}' /proc/loadavg) < 1.5"
	while test "$(bc <<< "$foo")" = '0'; do
		foo="$(awk '{print $1}' /proc/loadavg) < 1.5"
		sleep 5
	done
	"$@"
}

function svngrep {
	find -name '.svn' -prune -or -exec grep "$@" {} +
}

function debskew {
	apt-cache showsrc "$1" \
		| grep-dctrl . --show=binary -n \
		| tr ', ' '\n' \
		| sort -u \
		| xargs -r dpkg -l
}

function exaudio {
	ffmpeg -i "$1" -acodec copy -vn "$2"
}

function winbreak {
	~/src/debugbreak/debugbreak $(tasklist //fi "imagename eq $1" | awk "\$1 == \"$1\" { print \$2 }")
}

function etckeeper_check {
	if command -v sudo >/dev/null 2>&1 && command -v etckeeper >/dev/null 2>&1; then
		if timeout 1 sudo -n etckeeper unclean; then
			echo 'etckeeper has uncommitted changes.'
		fi
	fi
}

function dpkg-grep {
	local package="$1"; shift
	local grep_args=("$@")
	dpkg --listfiles "$package" | while read line; do
		if [[ -f $line && ! -L $line ]]; then
			grep --color=auto -H "${grep_args[@]}" -- "$line"
		fi
	done
}

declare -A _wc_delta
function wcl-delta {
	local file="$1"; shift
	local hash=$(printf "$file" | sha256sum | cut -d ' ' -f 1)
	local prior=${_wc_delta[$hash]:-0}
	local new=$(wc -l "$file" | cut -d ' ' -f 1)
	local _wc_delta[$hash]="$new"
	echo $((new - prior))
}

function cheap-dpigs {
	dpkg-query -W -f '${Installed-Size}\t${Package}\n' \
		| sort -k 1nr,1 \
		| numfmt --field=1 --from-unit=1Ki --to=iec-i \
		| column -t
}

function git {
	unset LESS
	command git "$@"
}

function trust-check {
	local crt skid p11id
	for crt in "$@"; do
		skid=$(openssl x509 -in "$crt" -noout -ext subjectKeyIdentifier | tail -n +2)
		p11id=$(<<< "$skid" tr -d '[:space:]:' | sed -e 's/../%\U&/g')
		trust list | grep -A 4 "^pkcs11:id=$p11id;type=cert"
	done
}

alias aptwhy='apt rdepends --no-conflicts --no-breaks --no-replaces --no-enhances'
alias aptwhyi='aptwhy --installed'
alias bc='bc -q'
alias dig='dig +multi'
alias dnf='sudo dnf'
alias docker='sudo -g docker docker'
alias docker-pid=$'docker inspect --format \'{{ .State.Pid }}\''
alias dquilt='QUILT_PATCHES=debian/patches QUILT_NO_DIFF_INDEX=1 QUILT_NO_DIFF_TIMESTAMPS=1 QUILT_REFRESH_ARGS="-p ab" quilt'
alias dux='du -xm --max-depth=1'
alias e="$EDITOR"
alias g=git
alias gbp-buildpackage-cow="gbp buildpackage --git-pbuilder --git-pbuilder-options='--hookdir $HOME/.pbuilder-hooks'"
alias gdb='gdb -silent'
alias gnutls-cli-verify="gnutls-cli --x509cafile /etc/ssl/certs/ca-certificates.crt"
alias grpe=grep
alias ffprobe='ffprobe -hide_banner'
alias ip='ip -br -c'
alias j=journalctl
alias journalctl='journalctl --no-hostname'
alias la='ls -A'
alias ll='ls -lh'
alias lsacpi=$'(for x in /sys/bus/acpi/devices/*; do if [[ -e "$x/path" ]]; then path=$(<"$x/path"); else path=\'?\'; fi; printf \'%s %s\n\' "$path" "$(readlink -e "$x")"; done | sort -k 1,1 | column -t)'
alias massif='valgrind --tool=massif --depth=5 --alloc-fn={g_malloc,g_realloc,g_try_malloc,g_malloc0,g_mem_chunk_alloc}'
alias mysql='mysql --pager --sigint-ignore'
alias odh='od -A x -t x1z'
alias ping='ping -n'
alias pol='apt-cache policy'
alias psc='ps xawf -o pid,user,cgroup,args'
alias psc2='ps -o pid,user,nlwp,cgroup,args -e --forest'
alias psc3='ps -o pid,user,nlwp,unit,args -e --forest'
alias py3='ipython3'
alias rsync='rsync -h'
alias s=systemctl
alias s_client-verify='openssl s_client -showcerts -verify 20 -verify_return_error'
alias sndtest1='pasuspender -- aplay -D plughw:CARD=I82801AAICH,DEV=0 /usr/share/sounds/alsa/Front_Left.wav'
alias tar='tar --force-local'
alias units='units --verbose'
alias watch='watch -c'
alias wgoat='wget'
alias whois='whois -H'
alias xc='xclip -selection clipboard -in'
alias xp='xclip -selection clipboard -out'
alias xse='tail --follow=name ~/.xsession-errors -n 0'

function docker-ip {
	docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@"
}

function docker-rmi-dangling {
	local images=($(docker images -q --filter=dangling=true))
	[[ ${#images[@]} -eq 0 ]] || docker rmi "${images[@]}"
}

function pheldapvi {
	local servers=($(dig -t SRV _ldap._tcp.gc._msdcs.phe.gov.uk +short | cut -d' ' -f4 | sed -e 's,^,ldap://,' -e 's/\.$//'))
	if [[ ${#servers[@]} -eq 0 ]]; then
		echo 'DNS failure?' >&2
		return 1
	fi
	ldapvi -Q -Y GSSAPI -h $(IFS=,; echo "${servers[*]}") "$@"
}

function ps-user {
	ps -u "$1" -o pid,nlwp,cmd f
}

function srv {
	busctl -j call \
		org.freedesktop.resolve1 \
		/org/freedesktop/resolve1 \
		org.freedesktop.resolve1.Manager \
		ResolveService \
		isssit \
		0 '' '' "$1" 0 129 \
	| jq -c '.data[0][]'
}

if command -v dpigs >/dev/null; then
	alias dpigs='dpigs -H'
else
	alias dpigs=cheap-dpigs
fi

if command -v gio &> /dev/null; then
	alias open='gio open'
elif command -v gvfs-open &>/dev/null; then
	alias open=gvfs-open
fi

if test -z "$CLICOLOR"; then
	alias grep='grep --color=auto'
	alias dgrep='dgrep --color=auto'
	alias ls='ls --color=auto --hyperlink=auto'

	function cgrep {
		pattern="$1"; shift
		grep "^\\|$pattern" "$@"
	}
fi

function hibp {
	local hash noise count
	read -p 'Password: ' -rs pass
	read -r hash noise < <(echo -n "$pass" | sha1sum - | tr 'a-z' 'A-Z')
	count=
	IFS=: read -r noise count < <(curl -sSL "https://api.pwnedpasswords.com/range/${hash:0:5}" | grep "^${hash:5}:")
	#IFS=: read -r noise count < <(curl -sSL "https://api.pwnedpasswords.com/range/${hash:0:5}" | look -b "${hash:5}:")
	echo "${count:-0}"
}

function for-each-pem {
	local inputs=()
	local usage='Usage: for-each-pem file1 ... -- command -in {} other args'
	while [[ $1 != -- ]]; do
		if ! (($#)); then
			echo "$usage" >&2
			return 1
		fi
		inputs+=("$1")
		shift
	done
	shift # --

	local certs=()
	for input in "${inputs[@]}"; do
		while read -r line; do
				if [[ $line = "-----BEGIN CERTIFICATE-----" ]]; then
						local cert="$line"$'\n'
						while read -r line2; do
								cert+="$line2"$'\n'
								if [[ "$line2" = "-----END CERTIFICATE-----" ]]; then
										certs+=("$cert")
										break
								fi
						done
				fi
		done < "$input"
	done

	for cert in "${certs[@]}"; do
		(
			# Name based on RFC7468 5.3
			local cert_file
			cert_file=$(mktemp -t for-each-pem-XXXXXXXX.crt)
			if [[ -z "$cert_file" ]]; then
				return 1
			fi
			echo -n "$cert" > "$cert_file"
			trap "rm -f \"$cert_file\"" EXIT

			local args=()
			for c in "$@"; do
				if [[ $c == {} ]]; then
					args+=("$cert_file")
				else
					args+=("$c")
				fi
			done
			if ! ((${#args[@]})); then
				echo "$usage" >&2
				return 2
			fi
			if ! "${args[@]}"; then
				return 3
			fi
		)
		local r="$?"
		if ((r)); then return "$r"; fi
	done
}

function oc-events {
	{
		echo $'TIME\tNAMESPACE\tTYPE\tREASON\tOBJECT\tSOURCE\tMESSAGE';
		oc get events -o json "$@" \
			| jq -r  '.items | map(. + {t: (.eventTime//.lastTimestamp)}) | sort_by(.t)[] | [.t[0:19], .metadata.namespace, .type, .reason, .involvedObject.kind + "/" + .involvedObject.name, .source.component + (if .source.host then "," + .source.host else "" end), .message] | @tsv';
	} \
		| column -s $'\t' -t \
		| less -SF
}

function oc-es-exec {
	es_pod="$(oc -n openshift-logging get pod -l component=elasticsearch -o name --field-selector=status.phase=Running | shuf -n1)"
	if [[ -z "$es_pod" ]]; then
		echo 'No running elasticsearch pods found' >&2
		oc -n openshift-logging get pod -l component=elasticsearch
		return 1
	fi
	oc -n openshift-logging \
		exec -c elasticsearch "$es_pod" \
			-- "$@"
}

function oc-machine-ips {
	{
		echo $'MACHINE\tTYPE\tROLE\tINSTANCE-TYPE\tREGION\tZONE\tADDRESS';
		oc get -o json machine -n openshift-machine-api \
			| jq -r '.items[] | [.metadata.name, .metadata.labels["machine.openshift.io/cluster-api-machine-type"], .metadata.labels["machine.openshift.io/cluster-api-machine-role"], .metadata.labels["machine.openshift.io/instance-type"], .metadata.labels["machine.openshift.io/region"], .metadata.labels["machine.openshift.io/zone"], (.status.addresses[] | select(.type=="InternalIP") | .address) ] | @tsv';
	} \
		| column -s $'\t' -t \
		| less -SF
}

function oc-scc-access {
	{
		echo $'NAME\tPRIORITY\tUSERS\tGROUPS';
		oc get scc -o json \
			| jq -r '.items[] | [.metadata.name, .priority//0, (.users|join(",")), (.groups|join(","))] | @tsv'
	} \
		| column -s $'\t' -t \
		| less -SF
}

if command -v direnv &>/dev/null; then
	eval "$(direnv hook bash)"
fi

command -v direnv >/dev/null 2>&1 && eval "$(direnv hook bash)"

etckeeper_check
