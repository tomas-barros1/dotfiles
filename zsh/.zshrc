bindkey -e

bindkey '^R' fzf-history-widget

# Alt arrows
bindkey '\e[1;3D' backward-word
bindkey '\e[1;3C' forward-word

# [Ctrl-RightArrow] - move forward one word
bindkey -M emacs '^[[1;5C' forward-word

# [Ctrl-LeftArrow] - move backward one word
bindkey -M emacs '^[[1;5D' backward-word

# [Ctrl-Delete] - delete whole forward-word
bindkey -M emacs '^[[3;5~' kill-word

export SUDO_EDITOR='nvim'

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

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
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

alias y="yay"
alias l="ls -la"
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias cat="bat --theme='Catppuccin Mocha' --paging=never --color=always"
alias pg="docker exec -it -u postgres postgres psql"
alias vim="nvim"
alias n="nvim"
alias c="clear"

eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval "$(mise activate zsh)"
eval "$(starship init zsh)"

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
