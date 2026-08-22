if [ -z "$PS1" ]; then
    # 1 & 2. Evita travamentos com paginadores interativos (less, more, delta)
    export PAGER=cat
    export GIT_PAGER=cat

    # 3. Fail-fast caso comandos do Git tentem solicitar credenciais interativas
    export GIT_TERMINAL_PROMPT=0

    # 4. Desativa spinners animados e barras de progresso repetitivas
    export CI=1

    # 5. Desativa códigos brutos de cores ANSI para economia de tokens
    export NO_COLOR=1

    # Garante acesso imediato ao rtk e ferramentas locais
    export PATH="$HOME/.local/bin:$PATH"
fi 

PS1='\[\e[01;32m\]\u@\h\[\e[00m\]:\[\e[01;34m\]\w\[\e[00m\]\$ '

export EDITOR='nvim'
export VISUAL='nvim'

export SUDO_EDITOR='nvim'
