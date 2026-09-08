bindkey -e

# --- Histórico ---
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY       # salva timestamp e duração de cada comando
setopt SHARE_HISTORY          # compartilha histórico em tempo real entre sessões abertas
setopt APPEND_HISTORY         # não sobrescreve o arquivo, só acrescenta
setopt INC_APPEND_HISTORY     # grava cada comando assim que é executado (não só ao fechar o shell)
setopt HIST_IGNORE_DUPS       # não repete o mesmo comando duas vezes seguidas
setopt HIST_IGNORE_ALL_DUPS   # ao adicionar um duplicado, remove a ocorrência antiga
setopt HIST_FIND_NO_DUPS      # ao navegar (Ctrl+R), pula duplicados
setopt HIST_IGNORE_SPACE      # comandos que começam com espaço não entram no histórico
setopt HIST_REDUCE_BLANKS     # remove espaços em branco supérfluos antes de salvar
setopt HIST_VERIFY            # ao usar !!/!n, mostra o comando antes de rodar, não roda direto

# --- PATH ---
path=(
  /home/tom/.dotnet/tools
  /home/tom/.cargo/bin
  /home/tom/.local/bin
  /home/tom/dotfiles/scripts/.local/scripts
  $path
)

# --- Editor padrão ---
export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim

# --- Integrações de terceiros (cacheadas em arquivo) ---
zsh_cache_eval() {
  local name=$1 cache="$HOME/.cache/zsh/${1}.zsh"
  shift
  if [[ ! -s "$cache" || "$(command -v $name)" -nt "$cache" ]]; then
    mkdir -p "$HOME/.cache/zsh"
    "$@" > "$cache"
  fi
  source "$cache"
}

zsh_cache_eval mise mise activate zsh
zsh_cache_eval starship starship init zsh
zsh_cache_eval zoxide zoxide init zsh
zsh_cache_eval fzf fzf --zsh

# --- FZF ---
export FZF_DEFAULT_OPTS="\
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

export FZF_CTRL_T_OPTS="\
--style full \
--walker-skip .git,node_modules,target \
--preview 'bat -n --theme=\"Catppuccin Mocha\" --color=always {}' \
--bind 'ctrl-/:change-preview-window(down|hidden)'"

# --- Aliases ---
alias ls='eza -lh --group-directories-first --icons=auto'
alias la='ls -a'
alias cat="bat --theme='Catppuccin Mocha' --paging=auto --color=always"
alias cd="z"
alias n="nvim"
alias op="opencode"
alias t="tmux"

alias ga='git add .'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'

# --- Funções ---
function y() {
  if (( $# == 0 )); then yay; else yay -S "$@"; fi
}
function p() {
  if (( $# == 0 )); then paru; else paru -S "$@"; fi
}
function ps() { paru -Ss "$1" }
function py() { python "$@" }
function save_mp3() { yt-dlp --embed-thumbnail -t mp3 "$@" }

# --- Plugins ---
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- Keybinds (depois dos plugins, pra não ser sobrescrito) ---
bindkey '^[[1;3C' forward-word     # Alt/Option + →
bindkey '^[[1;3D' backward-word    # Alt/Option + ←
bindkey '^[[1;5C' forward-word     # Ctrl + →
bindkey '^[[1;5D' backward-word    # Ctrl + ←
bindkey '^H' backward-kill-word    # Ctrl + Backspace
bindkey '^[[3;5~' kill-word        # Ctrl + Delete

# --- Comportamento estilo Fish ---

# 1. Aceitar sugestão do autosuggestions com → ou End (como no Fish)
bindkey '^[[C' end-of-line          # → aceita a sugestão inteira
bindkey '^[[F' end-of-line          # End faz o mesmo
bindkey '^[[1;5C' forward-word      # Ctrl+→ aceita só a próxima palavra da sugestão

# 2. Histórico filtrado por prefixo nas setas ↑/↓
# (digite "git " e aperte ↑ — só aparecem comandos que começam com "git ", igual no Fish)
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search    # ↑
bindkey '^[[B' down-line-or-beginning-search  # ↓

# 3. Menu de completion navegável com Tab (setas + Tab pra escolher, como no Fish)
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # completion case-insensitive
zmodload zsh/complist
bindkey -M menuselect '^[[Z' reverse-menu-complete  # Shift+Tab volta no menu
