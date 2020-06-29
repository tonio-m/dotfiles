# oh by bash config
OSH_THEME="font"
export OSH=/home/user/.oh-my-bash

completions=(
  git
  ssh
  composer
)

aliases=(
  general
)

plugins=(
  git
  bashmarks
)

source $OSH/oh-my-bash.sh

# disable weird behavior inside GNU screen 
export TERM=xterm-256color

# i3blocks
export SCRIPT_DIR="$HOME/.config/i3blocks/i3blocks-contrib"

# pyenv
export PATH="/home/user/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# aliases
alias goto-i3blocks="cd ~/.config/i3blocks/"
alias goto-i3="cd ~/.config/i3/"
alias bashrc="vim ~/.bashrc"
