ZSH_THEME="agnoster"
export LANG=en_US.UTF-8
export TERM=xterm-256color
export NVM_DIR="$HOME/.nvm"
export ARCHFLAGS="-arch x86_64"
export ZSH="$HOME/.config/.oh-my-zsh"
export MANPATH="/usr/local/man:$MANPATH"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PATH="/home/user/.pyenv/bin:$PATH"
export TERMINAL="kitty --single-instance"
export XDG_DATA_HOME="$HOME/.local/share"
export PATH=$HOME/bin:/usr/local/bin:$PATH
export SCRIPT_DIR="$HOME/.config/i3blocks/i3blocks-contrib"

plugins=(git)

alias vim="nvim"
alias goto-i3="cd ~/.config/i3/"
alias goto-vim="cd ~/.config/nvim/"
alias goto-kitty="cd ~/.config/kitty/"
alias goto-i3blocks="cd ~/.config/i3blocks/"
alias clipboard="~/.config/i3/rofi-clipboard.sh"
alias cb="clipboard"

export EDITOR='nvim'

eval "$(pyenv init -)"
eval $(/home/user/.linuxbrew/bin/brew shellenv)
source $ZSH/oh-my-zsh.sh
eval "$(pyenv virtualenv-init -)"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

