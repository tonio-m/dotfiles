source $HOME/.config/scripts/minimal.zsh

if [ -f ~/.env ]; then
  source ~/.env
fi

source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
chruby ruby-3.2.2

export EDITOR="nvim"
export TERM="xterm-256color"
export PYENV_ROOT="$HOME/.pyenv"
export do='--dry-run=client -o=yaml'
export DOCKER_DEFAULT_PLATFORM=linux/amd64
export PATH="/Users/user/.local/bin/:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export OBSIDIAN_HOME="$HOME/Obsidian/marco_vault/"

command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

alias vim=nvim
# alias k=kubectl
alias make=gmake

add_worktree() {
    if [ -z "$1" ]; then
        echo "Please provide a branch name."
        return 1
    fi
    branch_name=$1
    git_dir=$(find . -name "*.git" -type d | head -n 1)
    echo $git_dir
    if [ -z "$git_dir" ]; then
        echo "No .git directory found."
        return 1
    fi
    cd $git_dir
    git worktree add ../${branch_name} ${branch_name}
    cd ../${branch_name}
}

gh_switch() {
    gh auth switch
    git config --global user.name $(gh api user | jq -r '.login')
    git config --global user.email $(gh api user/emails | jq -r '.[0].email')
}

# c() {
#   local content="$*"
#   curl -s https://api.openai.com/v1/chat/completions \
#     -H "Content-Type: application/json" \
#     -H "Authorization: Bearer $OPENAI_API_KEY" \
#     -d '{
#       "model": "gpt-3.5-turbo",
#       "messages": [{"role": "user", "content": "'"${content}"'"}],
#       "temperature": 0.7
#     }' | jq -r '.choices[0].message.content'
# }

c() {
  local content="$*"
  curl -s https://api.anthropic.com/v1/complete \
    -H "Content-Type: application/json" \
    -H "anthropic-version: 2023-06-01" \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -d '{
      "model": "claude-2",
      "prompt": "\n\nHuman: '"${content}"'\n\nAssistant:",
      "max_tokens_to_sample": 1024,
      "temperature": 0.7
    }' | jq -r '.completion'
}


alias apa="export AWS_PROFILE=amherst"
# alias s3r="aws s3 ls --recursive --human-readable"
alias s3="aws s3 ls --human-readable"
alias git_undo="git reset --soft HEAD~1"
alias cdv="cd ~/.config/nvim"
alias cdy="cd ~/.local/share/yadm/repo.git"
alias cdj="cd ~/Obsidian/marco_vault"
# alias c="llm chat"
alias vps="ssh -i ~/.ssh/tonio-m root@$VPS_IP"
alias dbx="python ~/.config/scripts/databricks_repl.py"
alias vj="vim ~/Obsidian/marco_vault"
