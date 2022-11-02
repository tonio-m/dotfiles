# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# keyboard layout
setxkbmap -layout us -variant mac -option "terminate:ctrl_alt_bksp"

# disable ctrl+z job suspend
stty susp undef

# vim keybindings
bindkey -v

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
alias vim=lvim
alias k='kubectl'
alias watch='watch '
alias jupyter="PYENV_VERSION=anaconda3-2021.11 jupyter lab"
alias virt-manager="sudo GTK_THEME=Adwaita:dark virt-manager"
alias neofetch="neofetch --ascii $HOME/.config/scripts/maquinatotal.txt"
alias ls="ls --color=auto --hide='Bitwig Studio' --hide='Desktop' --hide='Documents' --hide='CacheClip'"


# env vars
export TERM="xterm-256color"
export PIPEWIRE_LATENCY="128/48000"

# functions
function convert_to_resolve() {
    IFS='.'
    filename="$(echo "$@" | cut -d'.' -f1)"
    ffmpeg -i "$@" -c:v prores_ks -profile:v 3 -qscale:v 9 -vendor ap10 -pix_fmt yuv422p10le -acodec pcm_s16le "$filename.mov"
}

function convert_audio_to_resolve() {
    IFS='.'
    filename="$(echo "$@" | cut -d'.' -f1)"
    ffmpeg -i "$@" -c:a pcm_s16le "$filename.wav"
}

function move_pictures() {
  mv *.bmp ~/Pictures/
  mv *.gif ~/Pictures/
  mv *.jpg ~/Pictures/
  mv *.png ~/Pictures/
  mv *.psd ~/Pictures/
  mv *.svg ~/Pictures/
  mv *.jfif ~/Pictures/
  mv *.jpeg ~/Pictures/
  mv *.webp ~/Pictures/
}

function move_videos() {
  mv *.mkv ~/Pictures/videos/
  mv *.mov ~/Pictures/videos/
  mv *.mp4 ~/Pictures/videos/
  mv *.webm ~/Pictures/videos/
}

function move_audios() {
  mv *.3gp ~/Music/audios/
  mv *.MID ~/Music/audios/
  mv *.MP3 ~/Music/audios/
  mv *.WAV ~/Music/audios/
  mv *.aac ~/Music/audios/
  mv *.aif ~/Music/audios/
  mv *.m4a ~/Music/audios/
  mv *.mid ~/Music/audios/
  mv *.mp3 ~/Music/audios/
  mv *.ogg ~/Music/audios/
  mv *.wav ~/Music/audios/
  mv *.wma ~/Music/audios/
  mv *.flac ~/Music/audios/
}

# utils 

function kportforwarddask(){
  kubectl port-forward --namespace dask service/$@ 8787:8787
}

alias kportforwardminio='kubectl port-forward -n minio-ml-eu svc/minio-ml 9010:9000'
alias kportforwardargo='kubectl port-forward -n argo svc/argo-workflow-argo-workflows-server 2746:2746'
alias kgetwf='kubectl -n argo get wf -o=custom-columns="NAME:.metadata.name,STATUS:.metadata.labels.workflows\.argoproj\.io/phase,IMAGE:.spec.arguments.parameters[?(@.name=='"'imageTag'"')].value,START:.metadata.creationTimestamp" --sort-by=.metadata.creationTimestamp'
alias kgetcwf='kubectl -n argo get cwf -o=custom-columns="NAME:.metadata.name,SCHEDULE:.spec.schedule,SUSPEND:.spec.suspend,IMAGE:.spec.workflowSpec.arguments.parameters[?(@.name=='"'imageTag'"')].value,SITEKEYS:.spec.workflowSpec.arguments.parameters[?(@.name=='"'site_config_file'"')].value"'
alias argogettoken='echo Bearer $(kubectl get secret -n argo argo-workflow-argo-workflows-server-token-dgzjq  -o=jsonpath="{ .data.token }" | base64 -d)'
alias botclassifiershell='ENV_FILE="./config/.env.prod" docker-compose run --rm botclassifier bash'
