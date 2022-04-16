# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# keyboard layout
setxkbmap -variant altgr-intl

# prompt
PRINT='echo -n'
[ `$PRINT | wc -c` -ne 0 ] && PRINT=printf
PS1='\e[0;38;5;236m\]\W $(_prompt) '
_prompt() {
	case $? in
	0|130)
		RET=240
		;;
	127)
		RET=196
		;;
	*)
		RET=202
		;;
	esac
	RET="[38;5;${RET}m"
	RET="${RET}─[0m "
	$PRINT $RET
}

# path variable
PATH="~/.local/bin/:$PATH"
PATH="~/.cargo/bin:$PATH"
PATH="/opt/resolve/bin:$PATH"
export PATH

# aliases
alias vim=lvim
alias ls="ls --color=auto --hide='Bitwig Studio' --hide='Documents'"
alias k='kubectl'

# functions
function convert_to_resolve() {
    IFS='.'
    echo a
    echo "$@"
    echo b
    filename="$(echo "$@" | cut -d'.' -f1)"
    ffmpeg -i "$@" -c:v prores_ks -profile:v 3 -qscale:v 9 -vendor ap10 -pix_fmt yuv422p10le -acodec pcm_s16le "$filename.mov"
}
