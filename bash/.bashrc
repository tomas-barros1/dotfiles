if [ -z "$PS1" ]; then
    export PAGER=cat
    export GIT_PAGER=cat
    export GIT_TERMINAL_PROMPT=0
    export CI=1
    export NO_COLOR=1
    export PATH="$HOME/.local/bin:$PATH"
fi

PS1='\[\e[38;5;245m\][\A] \[\e[38;5;183m\]\u\[\e[38;5;245m\]@\[\e[38;5;117m\]\h \[\e[38;5;245m\]\w\[\e[38;5;150m\]$(git branch --show-current 2>/dev/null | sed "s/^/ (/;s/$/)/") \[\e[38;5;245m\]❯ \[\e[0m\]'

export EDITOR='nvim'
export VISUAL='nvim'
export SUDO_EDITOR='nvim'

export OLLAMA_API_BASE=http://127.0.0.1:11434
. "$HOME/.local/share/../bin/env"

# PATH
export PATH="$HOME/.dotnet/tools:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/dotfiles/scripts/.local/scripts:$PATH"

# FZF
export FZF_DEFAULT_OPTS="--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 --color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC --color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 --color=selected-bg:#45475A --color=border:#6C7086,label:#CDD6F4"
export FZF_CTRL_T_OPTS="--style full --walker-skip .git,node_modules,target --preview 'bat -n --theme=\"Catppuccin Mocha\" --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden)'"

# Aliases
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

# Funções
p() {
    if [ $# -eq 0 ]; then
        paru
        return
    fi
    paru -S "$@"
}

ps() {
    paru -Ss "$1"
}

td() {
    if systemctl is-active --quiet docker; then
        echo "🛑 Parando Docker..."
        sudo systemctl stop docker
    else
        echo "🚀 Iniciando Docker..."
        sudo systemctl start docker
    fi
}

y() {
    if [ $# -eq 0 ]; then
        yay
        return
    fi
    yay -S "$@"
}

ys() {
    yay -Ss "$1"
}

convert_mp4_mkv() {
    local input="$1"
    local output="${input%.mp4}.mkv"
    ffmpeg -i "$input" "$output"
}

fastconvert_mp4_mkv() {
    local input="$1"
    local output="${input%.*}.mkv"
    ffmpeg -i "$input" -c copy "$output"
}

save_mp3() {
    yt-dlp --embed-thumbnail -t mp3 "$@"
}

__cache_eval() {
    local name=$1
    shift
    local cache="${XDG_CACHE_HOME:-$HOME/.cache}/bash/$name"
    command -v "$name" >/dev/null 2>&1 || return
    if [[ ! -s "$cache" || "$cache" -ot "$(command -v "$name")" ]]; then
        mkdir -p "$(dirname "$cache")"
        "$@" >"$cache"
    fi
    source "$cache"
}

if [[ $- == *i* ]]; then
    __cache_eval mise mise activate bash
    __cache_eval zoxide zoxide init bash
    __cache_eval fzf fzf --bash
    # Bash completions (com cache, sem duplo load com /etc/bash.bashrc)
    if [[ -r /usr/share/bash-completion/bash_completion ]] && [[ ! -v BASH_COMPLETION_VERSINFO ]]; then
        __bc_cache="${XDG_CACHE_HOME:-$HOME/.cache}/bash/bash-completion"
        if [[ ! -s "$__bc_cache" || "$__bc_cache" -ot /usr/share/bash-completion/bash_completion ]]; then
            cp /usr/share/bash-completion/bash_completion "$__bc_cache"
        fi
        source "$__bc_cache"
        unset __bc_cache
    fi
fi
