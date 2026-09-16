set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx SUDO_EDITOR nvim

set -gx fish_greeting ""
set -gx fish_prompt_pwd_dir_length 999

set -gx --path PATH \
    $HOME/.dotnet/tools \
    $HOME/.cargo/bin \
    $HOME/.local/bin \
    $HOME/dotfiles/scripts/.local/scripts \
    $PATH

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

function __fish_init --description 'source cached tool inits'
    set -l cache $HOME/.cache/fish/init.fish
    set -l omp $HOME/dotfiles/oh-my-posh/catppuccin_mocha.omp.json
    set -l deps (command --search zoxide fzf oh-my-posh) $omp

    set -l stale 1
    if test -s $cache
        set stale 0
        for d in $deps
            test $d -nt $cache; and set stale 1; and break
        end
    end

    if test $stale -eq 1
        command mkdir -p (path dirname $cache)
        begin
            command -q zoxide; and zoxide init fish
            command -q fzf; and fzf --fish
            command -q oh-my-posh; and oh-my-posh init fish --config $omp
        end >$cache
    end

    source $cache
end

function __mise_init --on-event fish_prompt --description 'lazy: carrega mise no 1º prompt'
    functions --erase __mise_init
    command -q mise; or return
    set -l cache $HOME/.cache/fish/mise.fish
    if not test -s $cache; or test (command -v mise) -nt $cache
        mise activate fish >$cache 2>/dev/null
    end
    source $cache
end

if status is-interactive
    __fish_init
end
