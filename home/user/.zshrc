ZSH_THEME="agnoster"
export LANG=en_US.UTF-8
export XDG_DATA_HOME="$HOME/.local/share"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export WEECHAT_HOME="$XDG_CONFIG_HOME/weechat"
export PATH="$XDG_DATA_HOME/cargo/bin:$PATH"
export TERMINAL="kitty --single-instance"
export TERM=xterm-256color
export NVM_DIR="$HOME/.nvm"
export ARCHFLAGS="-arch x86_64"
export ZSH="$HOME/.config/.oh-my-zsh"
export MANPATH="/usr/local/man:$MANPATH"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PATH="/home/user/.pyenv/bin:$PATH"
export PATH=$HOME/bin:/usr/local/bin:$PATH
export SCRIPT_DIR="$HOME/.config/i3blocks/i3blocks-contrib"

plugins=(git)

alias vim="nvim"
alias run="$HOME/.config/i3/rofi.sh &"
alias goto-i3="cd ~/.config/i3/"
alias goto-vim="cd ~/.config/nvim/"
alias goto-kitty="cd ~/.config/kitty/"
alias goto-i3blocks="cd ~/.config/i3blocks/"

export EDITOR='vim'

eval "$(pyenv init -)"
source $XDG_DATA_HOME/cargo/env
source $ZSH/oh-my-zsh.sh
eval "$(pyenv virtualenv-init -)"
[ -s "$nvm_dir/nvm.sh" ] && \. "$nvm_dir/nvm.sh"
[ -s "$nvm_dir/bash_completion" ] && \. "$nvm_dir/bash_completion"
