# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# keyboard layout
setxkbmap -variant altgr-intl


# prompt
source ~/.config/scripts/minimal.zsh

# path variable
PATH="$HOME/.local/bin/:$PATH"
PATH="$HOME/.cargo/bin:$PATH"
PATH="/opt/resolve/bin:$PATH"
export PATH

# aliases
alias vim=lvim
alias ls="ls --color=auto --hide='Bitwig Studio' --hide='Documents'"
alias k='kubectl'

# env vars
export TERM="xterm-256color"

# functions
function convert_to_resolve() {
    IFS='.'
    echo a
    echo "$@"
    echo b
    filename="$(echo "$@" | cut -d'.' -f1)"
    ffmpeg -i "$@" -c:v prores_ks -profile:v 3 -qscale:v 9 -vendor ap10 -pix_fmt yuv422p10le -acodec pcm_s16le "$filename.mov"
}

function clip() {
    if [ -t 0 ]; then
        t=1440
        if [ ! -z $2 ];then
            t="$2"
        fi
        curl -sF "file=@$1" -F "time=$t" https://clip.0x7359.com | grep -o "https://clip.0x7359.com/l/.*" | tee /dev/tty | xsel -ib
    fi
}
