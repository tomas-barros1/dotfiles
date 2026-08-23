if not status is-interactive
    return
end

zoxide init fish | source
fzf --fish | source
mise activate fish --shims | source

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx SUDO_EDITOR nvim

alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias cat="bat --theme='Catppuccin Mocha' --paging=auto --color=always"
alias cd="z"
alias n="nvim"
alias op="opencode"
alias t="tmux"
