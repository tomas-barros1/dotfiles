# Prompt / UI
starship init fish | source

# Environment
set -x EDITOR nvim
set -x SUDO_EDITOR $EDITOR

# fzf: options for ctrl-t (use in other tools that read this variable)
set -x FZF_CTRL_T_OPTS "\
  --style full\
  --walker-skip .git,node_modules,target\
  --preview 'bat -n --color=always {}'\
  --bind 'ctrl-/:change-preview-window(down|hidden)'"

# Functions
function convert
    set input $argv[1]
    set output (string replace -r '\.mp4$' '.mkv' $input)
    ffmpeg -i $input $output
end

function fastconvert
    set input $argv[1]
    set output (string replace -r '\.[^.]+$' '.mkv' $input)
    ffmpeg -i $input -c copy $output
end

# Aliases
alias l="ls -la"
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias cat="bat --theme='CatppuccinMocha' --paging=never"

if status is-interactive 
  mise activate fish | source 
else 
  mise activate fish --shims | source 
end
