# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# keyboard layout
setxkbmap -layout us -variant mac -option "terminate:ctrl_alt_bksp"

# path variable
PATH="$HOME/.cargo/bin:$PATH"
PATH="/opt/resolve/bin:$PATH"
PATH="$HOME/.local/bin/:$PATH"
PATH="$HOME/.pyenv/bin/:$PATH"
PATH="/home/user/repos/musicnn-cpp/essentia/src/essentia:$PATH"
export PATH

# prompt
source ~/.config/scripts/minimal.zsh

# pyenv
eval "$(pyenv init -)"

# aliases
alias k='kubectl'
alias vim=lvim
alias ls="ls --color=auto --hide='Bitwig Studio' --hide='Desktop' --hide='Documents'"
alias virt-manager="sudo GTK_THEME=Adwaita:dark virt-manager"
alias neofetch="neofetch --ascii $HOME/.config/scripts/maquinatotal.txt"

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
