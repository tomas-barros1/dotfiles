bindkey -e

# --- Histórico ---
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

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
  command -v "$name" >/dev/null || return
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
alias gcl='git clone'
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
function ys() { yay -Ss "$1" }
function ps() { paru -Ss "$1" }
function py() { python "$@" }
function save_mp3() { yt-dlp --embed-thumbnail -t mp3 "$@" }

# --- Completion (zstyle antes do compinit) ---
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# --- compinit cacheado (só rebuild completo 1x/dia) ---
autoload -Uz compinit
_comp_dump="$HOME/.cache/zsh/zcompdump"
mkdir -p "$HOME/.cache/zsh"
if [[ -n "$_comp_dump"(#qN.mh+24) || ! -f "$_comp_dump" ]]; then
  compinit -d "$_comp_dump"
else
  compinit -C -d "$_comp_dump"
fi

zmodload zsh/complist
bindkey -M menuselect '^[[Z' reverse-menu-complete  # Shift+Tab

# --- Histórico por prefixo (↑/↓ estilo Fish) ---
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# --- Plugins + keybinds dependentes (adiados até o 1º prompt) ---
autoload -Uz add-zsh-hook

_load_deferred() {
  add-zsh-hook -d precmd _load_deferred

  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

  local plugins=(
    /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  )
  for f in $plugins; do
    [[ -f "$f" && ( ! -f "$f.zwc" || "$f" -nt "$f.zwc" ) ]] && zcompile "$f" 2>/dev/null
    source "$f"
  done

  # keybinds que os plugins acima podem sobrescrever
  bindkey '^[[1;3C' forward-word
  bindkey '^[[1;3D' backward-word
  bindkey '^[[1;5C' forward-word
  bindkey '^[[1;5D' backward-word
  bindkey '^H'       backward-kill-word
  bindkey '^[[3;5~'  kill-word
  bindkey '^[[C'      end-of-line
  bindkey '^[[F'      end-of-line

  bindkey '^[[H'  beginning-of-line   # Home
  bindkey '^[[F'  end-of-line         # End (já tinha, mantém uma vez só)
  bindkey '^[[3~' delete-char         # Delete
  bindkey '^[[3;5~' kill-word         # Ctl + delete
  bindkey '^[[1~' beginning-of-line   # Home (alternativo)
  bindkey '^[[4~' end-of-line         # End (alternativo)
}
add-zsh-hook precmd _load_deferred

# --- Compila o próprio .zshrc pra bytecode ---
if [[ ! -f ~/.zshrc.zwc || ~/.zshrc -nt ~/.zshrc.zwc ]]; then
  zcompile ~/.zshrc
fi
