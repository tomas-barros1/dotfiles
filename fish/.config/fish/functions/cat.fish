function cat --wraps bat --description 'alias cat=bat'
    command bat --theme='Catppuccin Mocha' --paging=auto --color=always $argv
end