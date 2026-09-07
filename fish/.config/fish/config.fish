if not status is-interactive
    return
end

set -g fish_key_bindings fish_vi_key_bindings

zoxide init fish | source
fzf --fish | source
mise activate fish --shims | source

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx SUDO_EDITOR nvim

set -gx FZF_DEFAULT_OPTS "\
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

set -gx FZF_CTRL_T_OPTS "\
--style full \
--walker-skip .git,node_modules,target \
--preview '\''bat -n --theme=\"Catppuccin Mocha\" --color=always {}'\'' \
--bind '\''ctrl-/:change-preview-window(down|hidden)'\''"

fish_config theme choose catppuccin-mocha

alias ls='eza -lh --group-directories-first --icons=auto'
alias la='ls -a'
alias cat="bat --theme='Catppuccin Mocha' --paging=auto --color=always"
alias cd="z"
alias n="nvim"
alias op="opencode"
alias t="tmux"

set -g fish_greeting
set -g fish_prompt_pwd_dir_length 999
set -g fish_user_paths /home/tom/.dotnet/tools /home/tom/.cargo/bin /home/tom/.local/bin /home/tom/dotfiles/scripts/.local/scripts
