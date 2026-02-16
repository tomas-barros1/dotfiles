set -x EDITOR nvim
set -x SUDO_EDITOR $EDITOR

set -x FZF_CTRL_T_OPTS "\
  --style full\
  --walker-skip .git,node_modules,target\
  --preview 'bat -n --color=always {}'\
  --bind 'ctrl-/:change-preview-window(down|hidden)'"

alias y="yay"
alias l="ls -la"
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias z="zoxide"
alias cat="bat --theme='Catppuccin Mocha' --paging=never"
alias pg="docker exec -it -u postgres postgres psql"

zoxide init fish | source
starship init fish | source
/home/tom/.local/bin/mise activate fish | source
atuin init fish --disable-up-arrow | source
