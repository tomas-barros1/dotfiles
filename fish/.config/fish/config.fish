set -x EDITOR nvim
set -x SUDO_EDITOR $EDITOR

set -x FZF_CTRL_T_OPTS "\
  --style full \
  --walker-skip .git,node_modules,target \
  --preview \"bat -n --theme='Catppuccin Mocha' --color=always {}\" \
  --bind 'ctrl-/:change-preview-window(down|hidden)'"

alias y="yay"
alias l="ls -la"
alias ls="eza --git --icons=auto --group-directories-first"
alias cat="bat --theme='Catppuccin Mocha' --paging=never --color=always"
alias pg="docker exec -it -u postgres meu-postgres psql"
alias vim="nvim"
alias n="nvim"
alias cd="z"

starship init fish | source
zoxide init fish | source
fzf --fish | source
/home/tom/.local/bin/mise activate fish | source

fish_config theme choose catppuccin-mocha --color-theme=dark
