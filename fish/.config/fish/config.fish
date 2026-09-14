set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx SUDO_EDITOR nvim

set -gx fish_greeting ""
set -gx fish_prompt_pwd_dir_length 999

fish_add_path -g \
    $HOME/.dotnet/tools \
    $HOME/.cargo/bin \
    $HOME/.local/bin \
    $HOME/dotfiles/scripts/.local/scripts

set -gx FZF_DEFAULT_OPTS "\
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

set -gx FZF_CTRL_T_OPTS "\
--style full \
--walker-skip .git,node_modules,target \
--preview 'bat -n --theme=\"Catppuccin Mocha\" --color=always {}' \
--bind 'ctrl-/:change-preview-window(down|hidden)'"

alias ls='eza -lh --group-directories-first --icons=auto'
alias la='ls -a'
alias cat="bat --theme='Catppuccin Mocha' --paging=auto --color=always"
alias cd=z
alias n=nvim
alias op=opencode
alias t=tmux
alias py=python
alias man=batman

alias gss='git status --short'
alias gd='git diff'
alias ga='git add .'
alias gcl='git clone'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'

function __fish_cache_eval
    set -l name $argv[1]
    set -l cache $HOME/.cache/fish/$name.fish

    command -q $name; or return

    if not test -s $cache; or test (command -v $name) -nt $cache
        $argv[2..-1] >$cache
    end
    source $cache
end

if status is-interactive
    mkdir -p $HOME/.cache/fish

    __fish_cache_eval mise mise activate fish
    __fish_cache_eval zoxide zoxide init fish
    __fish_cache_eval fzf fzf --fish
end
