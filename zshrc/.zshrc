bindkey -e

# --- Histórico ---
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY
setopt SHARE_HISTORY            # já faz o append incremental
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# --- PATH ---
typeset -U path                 # sem entradas duplicadas
path=(
  $HOME/.dotnet/tools
  $HOME/.cargo/bin
  $HOME/.local/bin
  $HOME/dotfiles/scripts/.local/scripts
  $path
)

# --- Editor padrão ---
export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim
export BAT_THEME="tokyonight_night"

# builtin test em vez de fork do mkdir a cada startup
[[ -d $HOME/.cache/zsh ]] || mkdir -p "$HOME/.cache/zsh"

# --- Completion (antes das integrações, pra elas registrarem o compdef) ---
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

_init_compinit() {
  setopt localoptions extendedglob   # necessário pro qualifier (#q...)
  autoload -Uz compinit
  local dump="$HOME/.cache/zsh/zcompdump"
  # rebuild completo só 1x/dia; nos outros usa o cache (-C)
  if [[ -n $dump(#qN.mh+24) || ! -f $dump ]]; then
    compinit -d "$dump"
  else
    compinit -C -d "$dump"
  fi
  [[ -s $dump && ( ! -s $dump.zwc || $dump -nt $dump.zwc ) ]] && zcompile "$dump"
}
_init_compinit
unfunction _init_compinit

zmodload zsh/complist
bindkey -M menuselect '^[[Z' reverse-menu-complete  # Shift+Tab

# --- Integrações de terceiros (cacheadas em arquivo) ---
# Obs: se mudar os argumentos de um init, apague o cache em ~/.cache/zsh/<nome>.zsh*
# Usa ${commands[...]} (hash interno do zsh) em vez de $(command -v ...), sem fork.
zsh_cache_eval() {
  local name=$1 cache="$HOME/.cache/zsh/${1}.zsh" bin=${commands[$1]}
  shift
  [[ -n $bin ]] || return
  if [[ ! -s $cache || $bin -nt $cache ]]; then
    "$@" > "$cache" && zcompile "$cache" 2>/dev/null
  fi
  source "$cache"
}

# mise: carregado no _load_deferred (abaixo), depois do 1º prompt

# starship: init completo, mas com PROMPT2 fixado no cache. O init original roda
# `starship prompt --continuation` a cada boot (1 fork). Se mudar continuation_prompt
# no starship.toml, apague ~/.cache/zsh/starship.zsh*
() {
  local cache="$HOME/.cache/zsh/starship.zsh" bin=${commands[starship]}
  [[ -n $bin ]] || return
  if [[ ! -s $cache || $bin -nt $cache ]]; then
    {
      "$bin" init zsh --print-full-init | grep -v '^PROMPT2='
      print -r -- "PROMPT2=${(q)$("$bin" prompt --continuation)}"
    } > "$cache" && zcompile "$cache" 2>/dev/null
  fi
  source "$cache"
}

zsh_cache_eval zoxide zoxide init zsh
zsh_cache_eval fzf fzf --zsh

# --- FZF ---
export FZF_DEFAULT_OPTS=" \
--color=bg+:#292E42,bg:#1A1B26,spinner:#BB9AF7,hl:#F7768E \
--color=fg:#C0CAF5,header:#7AA2F7,info:#E0AF68,pointer:#BB9AF7 \
--color=marker:#7DCFFF,fg+:#C0CAF5,prompt:#7AA2F7,hl+:#FF9E64 \
--color=selected-bg:#292E42 \
--color=border:#3B4261,label:#C0CAF5"

export FZF_CTRL_T_OPTS="\
--style full \
--walker-skip .git,node_modules,target \
--preview 'bat -n --color=always {}' \
--bind 'ctrl-/:change-preview-window(down|hidden)'"

# --- Aliases ---
alias ls='eza -lh --group-directories-first --icons=auto'
alias la='ls -a'
alias cat='bat --paging=auto'
alias n="nvim"
alias op="opencode"
alias t="tmux"
alias cd="z"
alias lg="lazygit"
alias ld="lazydocker"

alias ga='git add .'
alias gd='git diff'
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
function ys() { yay -Ss "$@" }
function pss() { paru -Ss "$@" }
function py() { python "$@" }
function save_mp3() { yt-dlp --embed-thumbnail -t mp3 "$@" }

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

  zsh_cache_eval mise mise activate zsh

  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

  export DEJA_CYCLE_KEY='^N'   # tira o picker de alternativas do Tab (fica livre pro fzf/menu select)
  if [[ -r $HOME/.local/share/deja/init.zsh ]]; then
    source $HOME/.local/share/deja/init.zsh
  elif (( $+commands[deja] )); then
    eval "$(deja init zsh)"    # bootstrap: só na 1ª vez, gera o init.zsh
  fi

  local plugins=(
    /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh  # sempre por último
  )
  local f
  for f in $plugins; do
    [[ -f "$f" ]] || continue
    [[ ! -f "$f.zwc" || "$f" -nt "$f.zwc" ]] && zcompile "$f" 2>/dev/null
    source "$f"
  done

  # keybinds que os plugins acima podem sobrescrever
  bindkey '^[[1;3C'  forward-word        # Alt+→
  bindkey '^[[1;3D'  backward-word       # Alt+←
  bindkey '^[[1;5C'  forward-word        # Ctrl+→
  bindkey '^[[1;5D'  backward-word       # Ctrl+←
  bindkey '^H'       backward-kill-word  # Ctrl+Backspace
  bindkey '^[[3;5~'  kill-word           # Ctrl+Delete
  bindkey '^[[3~'    delete-char         # Delete
  bindkey '^[[H'     beginning-of-line   # Home
  bindkey '^[[1~'    beginning-of-line   # Home (alternativo)
  bindkey '^[[F'     end-of-line         # End
  bindkey '^[[4~'    end-of-line         # End (alternativo)
  # seta → não é sobrescrita: move 1 char e o deja aceita a sugestão inteira no fim da linha
  # Ctrl+→ aceita a próxima palavra da sugestão (via forward-word encapsulado pelo deja)
}
add-zsh-hook precmd _load_deferred

# --- Compila o próprio .zshrc pra bytecode ---
if [[ ! -f ~/.zshrc.zwc || ~/.zshrc -nt ~/.zshrc.zwc ]]; then
  zcompile ~/.zshrc
fi
