bindkey '^R' fzf-history-widget

export nvim='/home/tom/.local/share/mise/installs/neovim/0.11.7/bin/nvim'

export SUDO_EDITOR=$nvim

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

export PATH=/home/tom/.local/bin:$PATH

setopt CORRECT
setopt COMPLETE_IN_WORD
setopt AUTO_MENU
setopt AUTO_CD
setopt INTERACTIVE_COMMENTS

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

alias y="yay"

alias gs="git status"
alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"

alias l="ls -la"
alias ls="eza --color=always --git --no-filesize --icons=always"

alias cat="bat --theme='Catppuccin Mocha' --paging=never --color=always"

alias pg="docker exec -it -u postgres postgres psql"

alias vim="nvim"
alias n="nvim"

alias c="clear"

eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval "$(mise activate zsh)"

eval "$(oh-my-posh init --config=~/dotfiles/oh-my-posh/catppuccin_mocha.omp.json zsh)"
source ~/.key-bindings.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
