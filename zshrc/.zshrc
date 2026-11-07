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
  local cache="$HOME/.cache/zsh/${1}.zsh" bin=${commands[$1]}
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

export FZF_CTRL_R_OPTS="\
--scheme=history \
--highlight-line \
--preview 'echo {2..} | bat --color=always -pl bash' \
--preview-window up:3:hidden:wrap \
--bind 'ctrl-/:toggle-preview'"

# Precisam existir antes do source dos plugins.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=64
ZSH_AUTOSUGGEST_STRATEGY=(history)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#565f89'
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_MAXLENGTH=300

alias ls='eza --group-directories-first --icons=auto'
alias la='ls -a'
alias cat='bat --paging=auto'
alias n=nvim op=opencode t=tmux lg=lazygit ld=lazydocker
alias ys='yay -Ss' pss='paru -Ss' py=python
alias save_mp3='yt-dlp --embed-thumbnail -t mp3'

y() { if (( $# == 0 )); then yay; else yay -S "$@"; fi }
p()  { if (( $# == 0 )); then paru; else paru -S "$@"; fi }

fm() {
  local tmp="$(mktemp -t yazi-cwd.XXXXXX)" cwd
  yazi "$@" --cwd-file="$tmp"
  cwd="$(command cat -- "$tmp")"
  [[ -n $cwd && $cwd != "$PWD" && -d $cwd ]] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search edit-command-line
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N edit-command-line

bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[OA' up-line-or-beginning-search
bindkey '^[OB' down-line-or-beginning-search

bindkey '^[[H'  beginning-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[OH'  beginning-of-line
bindkey '^[[F'  end-of-line
bindkey '^[[4~' end-of-line
bindkey '^[OF'  end-of-line

bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word

bindkey '^[[3~'   delete-char
bindkey '^[[3;5~' kill-word
bindkey '^H'      backward-kill-word
bindkey '^[w'     kill-region

bindkey '^[[5~' beginning-of-buffer-or-history
bindkey '^[[6~' end-of-buffer-or-history
bindkey ' '     magic-space
bindkey '^[m'   copy-prev-shell-word
bindkey '^R'    history-incremental-search-backward
bindkey '^X^E'  edit-command-line
bindkey '^[[Z'  reverse-menu-complete

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

# Ordem importa: completions -> compinit -> cdreplay -> fzf/zoxide -> fzf-tab -> autosuggestions -> highlighting (por último).
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

  zinit light Aloxaf/fzf-tab
  zinit light zsh-users/zsh-autosuggestions
  zinit light zsh-users/zsh-syntax-highlighting

  ZSH_HIGHLIGHT_STYLES[command]='fg=#9ece6a'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=#9ece6a'
  ZSH_HIGHLIGHT_STYLES[alias]='fg=#9ece6a'
  ZSH_HIGHLIGHT_STYLES[function]='fg=#9ece6a'
  ZSH_HIGHLIGHT_STYLES[precommand]='fg=#9ece6a,italic'
  ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#bb9af7'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f7768e'
  ZSH_HIGHLIGHT_STYLES[path]='fg=#c0caf5,underline'
  ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#c0caf5'
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#e0af68'
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#e0af68'
  ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#7dcfff'
  ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#bb9af7'
  ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=#bb9af7'
  ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#bb9af7'
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#ff9e64'
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#ff9e64'
  ZSH_HIGHLIGHT_STYLES[assign]='fg=#c0caf5'
  ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#9ece6a,underline'
  ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#7dcfff'
  ZSH_HIGHLIGHT_STYLES[globbing]='fg=#7dcfff'
  ZSH_HIGHLIGHT_STYLES[comment]='fg=#565f89'
  ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#89ddff'
  ZSH_HIGHLIGHT_STYLES[redirection]='fg=#89ddff'
  ZSH_HIGHLIGHT_STYLES[arg0]='fg=#9ece6a'
  ZSH_HIGHLIGHT_STYLES[bracket-error]='fg=#f7768e,bold'
  ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=#7aa2f7'
  ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=#bb9af7'
  ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=#7dcfff'
  ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=#e0af68'
  ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]='bg=#283457'

  bindkey -M menuselect '^[[Z' reverse-menu-complete
}

# mise sem hook de precmd: só reavalia ao mudar de diretório ou ao digitar comando que cita mise/.tool-versions.
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
  (( $+functions[zsh-defer] )) || zsh-defer() { while [[ $1 == [-+]* ]]; do shift; done; "$@" }
  zsh-defer -dmpr _stage_plugins
  zsh-defer -dmpr _stage_mise
else
  zsh_cache_eval zoxide zoxide init zsh
  (( $+functions[z] )) && alias cd=z
fi

if [[ ! -f ~/.zshrc.zwc || ~/.zshrc -nt ~/.zshrc.zwc ]]; then
  zcompile ~/.zshrc
fi
