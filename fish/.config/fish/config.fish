if not status is-interactive
    return
end

zoxide init fish | source
fzf --fish | source
mise activate fish --shims | source

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx SUDO_EDITOR nvim

alias y="yay"
alias l="ls -la"
alias ls="eza --git --icons=auto --group-directories-first"
alias cat="bat --theme='Catppuccin Mocha' --paging=auto --color=always"
alias cd="z"
alias n="nvim"
alias op="opencode"
alias t="tmux"
