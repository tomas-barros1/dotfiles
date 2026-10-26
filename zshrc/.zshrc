typeset -gi _ui=0
[[ -o zle && -t 0 ]] && _ui=1

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

bindkey -e

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE \
       HIST_REDUCE_BLANKS HIST_VERIFY HIST_FCNTL_LOCK INTERACTIVE_COMMENTS NO_BEEP

typeset -U path fpath
path=(
  $HOME/.dotnet/tools
  $HOME/.cargo/bin
  $HOME/.local/bin
  $HOME/dotfiles/scripts/.local/scripts
  $path
)

export EDITOR=nvim VISUAL=nvim SUDO_EDITOR=nvim
export BAT_THEME="tokyonight_night"

[[ -d $HOME/.cache/zsh ]] || mkdir -p "$HOME/.cache/zsh"

# Se mudar os argumentos de um init, apague ~/.cache/zsh/<nome>.zsh*.
# Não use com `mise activate`: o output embute o PATH atual e o cache o congela.
zsh_cache_eval() {
  local name=$1 cache="$HOME/.cache/zsh/${1}.zsh" bin=${commands[$1]}
  shift
  [[ -n $bin ]] || return
  if [[ ! -s $cache || $bin -nt $cache ]]; then
    "$@" > "$cache" && zcompile "$cache" 2>/dev/null
  fi
  source "$cache"
}

fpath=("$HOME/.zsh/completions"(N/) $fpath)

zstyle ':completion:*' menu no
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings'    format '%F{red}no matches: %d%f'
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$HOME/.cache/zsh"
[[ -n $LS_COLORS ]] && zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:(cd|z):*' fzf-preview 'eza -1 --color=always $realpath'

export FZF_DEFAULT_OPTS="\
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none \
  --color=bg+:#283457 \
  --color=bg:#16161e \
  --color=border:#27a1b9 \
  --color=fg:#c0caf5 \
  --color=gutter:#16161e \
  --color=header:#ff9e64 \
  --color=hl+:#2ac3de \
  --color=hl:#2ac3de \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#2ac3de \
  --color=query:#c0caf5:regular \
  --color=scrollbar:#27a1b9 \
  --color=separator:#ff9e64 \
  --color=spinner:#ff007c"

export FZF_CTRL_T_OPTS="\
--style full \
--walker-skip .git,node_modules,target \
--preview 'bat -n --color=always {}' \
--bind 'ctrl-/:change-preview-window(down|hidden)'"
export FZF_CTRL_R_OPTS='--scheme=history --highlight-line'

# Precisam existir antes do source dos plugins.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=64
ZSH_AUTOSUGGEST_STRATEGY=(history)
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_MAXLENGTH=300

alias ls='eza --group-directories-first --icons=auto'
alias la='ls -a'
alias cat='bat --paging=auto'
alias n=nvim op=opencode t=tmux lg=lazygit ld=lazydocker
alias ys='yay -Ss' pss='paru -Ss' py=python
alias save_mp3='yt-dlp --embed-thumbnail -t mp3'

yy() { if (( $# == 0 )); then yay; else yay -S "$@"; fi }
p()  { if (( $# == 0 )); then paru; else paru -S "$@"; fi }

y() {
  local tmp="$(mktemp -t yazi-cwd.XXXXXX)" cwd
  yazi "$@" --cwd-file="$tmp"
  cwd="$(command cat -- "$tmp")"
  # builtin: o alias cd=z não pode interceptar
  [[ -n $cwd && $cwd != "$PWD" && -d $cwd ]] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search edit-command-line
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N edit-command-line
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^X^E' edit-command-line

ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

if (( _ui )); then
  if [[ ! -d $ZINIT_HOME ]]; then
    command mkdir -p "${ZINIT_HOME:h}" \
      && command git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
  fi

  if [[ -r $ZINIT_HOME/zinit.zsh ]]; then
    source "$ZINIT_HOME/zinit.zsh"
    zinit ice depth=1
    zinit light romkatv/powerlevel10k
    zinit light romkatv/zsh-defer
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
  fi
fi

# Roda depois do 1º prompt (zsh-defer). Ordem importa:
# completions/snippets -> compinit -> cdreplay -> fzf/zoxide -> fzf-tab -> autosuggestions -> highlighting
_stage_plugins() {
  (( $+functions[zinit] )) || return

  zinit light zsh-users/zsh-completions

  zinit snippet OMZL::git.zsh
  zinit snippet OMZP::git
  zinit snippet OMZP::sudo
  zinit snippet OMZP::archlinux
  zinit snippet OMZP::command-not-found

  setopt localoptions extendedglob
  zmodload zsh/complist
  autoload -Uz compinit
  local dump="$HOME/.cache/zsh/zcompdump"
  # rebuild completo 1x/dia; nos outros usa o cache (-C)
  if [[ -n $dump(#qN.mh+24) || ! -f $dump ]]; then
    compinit -d "$dump"
  else
    compinit -C -d "$dump"
  fi
  [[ -s $dump && ( ! -s $dump.zwc || $dump -nt $dump.zwc ) ]] && zcompile "$dump"
  zinit cdreplay -q

  zsh_cache_eval zoxide zoxide init zsh
  zsh_cache_eval fzf fzf --zsh
  (( $+functions[z] )) && alias cd=z

  # fzf-tab vem depois do compinit e do `fzf --zsh` (que também mexe no Tab),
  # mas antes dos plugins que embrulham widgets.
  zinit light Aloxaf/fzf-tab
  zinit light zsh-users/zsh-autosuggestions
  zinit light zsh-users/zsh-syntax-highlighting

  _git_aliases

  bindkey -M menuselect '^[[Z' reverse-menu-complete
  bindkey '^[w'      kill-region         # Alt+W
  bindkey '^[[1;3C'  forward-word        # Alt+→
  bindkey '^[[1;3D'  backward-word       # Alt+←
  bindkey '^[[1;5C'  forward-word        # Ctrl+→
  bindkey '^[[1;5D'  backward-word       # Ctrl+←
  bindkey '^H'       backward-kill-word  # Ctrl+Backspace
  bindkey '^[[3;5~'  kill-word           # Ctrl+Delete
  bindkey '^[[3~'    delete-char         # Delete
  bindkey '^[[H'     beginning-of-line   # Home
  bindkey '^[[1~'    beginning-of-line
  bindkey '^[[F'     end-of-line         # End
  bindkey '^[[4~'    end-of-line
}

# mise sem o hook de precmd (fork a cada prompt): só reavalia ao mudar de
# diretório (chpwd do próprio mise) ou ao digitar um comando que cita mise/.tool-versions.
# Pra voltar ao padrão, apague tudo que vem depois do `eval` nesta função.
_stage_mise() {
  (( $+commands[mise] )) || return
  eval "$(mise activate zsh)"
  precmd_functions=(${precmd_functions:#_mise_hook*})
  typeset -gi _mise_dirty=0
  _mise_preexec() { [[ $1 == *mise* || $1 == *tool-versions* ]] && _mise_dirty=1 }
  _mise_precmd()  { (( _mise_dirty )) || return 0; _mise_dirty=0; _mise_hook }
  add-zsh-hook preexec _mise_preexec
  add-zsh-hook precmd  _mise_precmd
  _mise_hook
}

if (( _ui )); then
  # Fallback síncrono se o clone do zsh-defer falhar (offline / 1ª vez).
  (( $+functions[zsh-defer] )) || zsh-defer() { while [[ $1 == [-+]* ]]; do shift; done; "$@" }
  zsh-defer -dmpr _stage_plugins
  zsh-defer -dmpr _stage_mise
else
  # Scripts via `zsh -i -c` continuam funcionando com cd=z.
  zsh_cache_eval zoxide zoxide init zsh
  (( $+functions[z] )) && alias cd=z
fi

if [[ ! -f ~/.zshrc.zwc || ~/.zshrc -nt ~/.zshrc.zwc ]]; then
  zcompile ~/.zshrc
fi
