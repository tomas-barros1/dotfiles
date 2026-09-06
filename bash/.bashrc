if [ -z "$PS1" ]; then
    export PAGER=cat
    export GIT_PAGER=cat
    export GIT_TERMINAL_PROMPT=0
    export CI=1
    export NO_COLOR=1
    export PATH="$HOME/.local/bin:$PATH"
fi 

PS1='\[\e[01;32m\]\u@\h\[\e[00m\]:\[\e[01;34m\]\w\[\e[00m\]\$ '
export EDITOR='nvim'
export VISUAL='nvim'
export SUDO_EDITOR='nvim'

export PATH=~/.cargo/bin/:$PATH
export OLLAMA_API_BASE=http://127.0.0.1:11434
. "$HOME/.local/share/../bin/env"
