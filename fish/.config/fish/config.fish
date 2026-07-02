if not status is-interactive
    return
end

zoxide init fish | source
fzf --fish | source
$HOME/.local/bin/mise activate fish | source

set -x EDITOR nvim
set -x SUDO_EDITOR $EDITOR

if command -q fzf
    set -x FZF_CTRL_T_OPTS \
        "--style full \
        --walker-skip .git,node_modules,target \
        --preview 'bat -n --theme=\"Catppuccin Mocha\" --color=always {}' \
        --bind 'ctrl-/:change-preview-window(down|hidden)'"
end

alias y="yay"
alias l="ls -la"
alias ls="eza --git --icons=auto --group-directories-first"
alias cat="bat --theme='Catppuccin Mocha' --paging=never --color=always"
alias vim="nvim"
alias n="nvim"
alias cd="z"
