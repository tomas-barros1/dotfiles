starship init fish | source

set -x EDITOR nvim
set -x SUDO_EDITOR $EDITOR

set -x FZF_CTRL_T_OPTS "\
  --style full\
  --walker-skip .git,node_modules,target\
  --preview 'bat -n --color=always {}'\
  --bind 'ctrl-/:change-preview-window(down|hidden)'"

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

alias l="ls -la"
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias cat="bat --theme='CatppuccinMocha' --paging=never"
~/.local/bin/mise activate fish | source
