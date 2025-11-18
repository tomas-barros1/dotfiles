set --export --global POSH_SESSION_ID "8ed82ee3-34f7-4c26-b9a4-6363650f9ab4"
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
alias z="zoxide"
alias cat="bat --theme='Catppuccin Mocha' --paging=never"

~/.local/bin/mise activate fish | source
zoxide init fish | source
source '/home/tom/.cache/oh-my-posh/init.12353866967644111694.fish'
