if not status is-interactive
    return
end

zoxide init fish | source
fzf --fish | source
mise activate fish --shims | source

set -x EDITOR nvim
set -x SUDO_EDITOR $EDITOR

alias y="yay"
alias l="ls -la"
alias ls="eza --git --icons=auto --group-directories-first"
alias cat="bat --theme='Catppuccin Mocha' --paging=never --color=always"
alias cd="z"
alias n="nvim"
