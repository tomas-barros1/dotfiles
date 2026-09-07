function foot-font --description 'Escolhe e aplica a fonte do Foot com fzf'
    set -l config "$HOME/.config/foot/foot.ini"

    if not type -q fzf
        printf '\e[31mErro:\e[0m fzf não está instalado.\n' >&2
        printf 'Instale com: sudo pacman -S fzf\n' >&2
        return 127
    end

    if not type -q fc-list
        printf '\e[31mErro:\e[0m fontconfig (fc-list) não está disponível.\n' >&2
        return 127
    end

    if not test -f "$config"
        printf '\e[31mErro:\e[0m arquivo não encontrado: %s\n' "$config" >&2
        printf 'Crie-o ou ajuste a variável config dentro da função.\n' >&2
        return 1
    end

    set -l current_size (awk '
        BEGIN { IGNORECASE = 1 }
        /^[[:space:]]*font[[:space:]]*=/ {
            value = $0
            sub(/^[^=]*=[[:space:]]*/, "", value)
            sub(/[[:space:]]*#.*/, "", value)
            if (match(value, /(^|:)size=[0-9.]+/)) {
                size = substr(value, RSTART, RLENGTH)
                sub(/^.*size=/, "", size)
                print size
            } else print "12"
            exit
        }
    ' "$config")
    if test -z "$current_size"
        set current_size 12
    end

    set -l font_list (fc-list --format '%{family}\n' 2>/dev/null | string split ',' | string trim | string match -v '' | sort -fu)
    if test (count $font_list) -eq 0
        printf '\e[31mErro:\e[0m nenhuma família de fonte foi encontrada.\n' >&2
        return 1
    end

    # fzf não consegue alterar a fonte das próprias células do terminal;
    # este preview textual mostra os caracteres e a resolução do fontconfig.
    set -lx FOOT_FONT_SIZE "$current_size"
    set -l selected (printf '%s\n' $font_list | fzf \
        --ansi \
        --border=rounded \
        --border-label='  FOOT FONT  ' \
        --border-label-pos=2 \
        --height='85%' \
        --layout=reverse \
        --margin=1 \
        --padding=1 \
        --prompt='  Fonte > ' \
        --pointer='▌' \
        --marker='┃' \
        --header='ENTER aplica  •  ESC cancela' \
        --header-first \
        --info=inline \
        --preview-window='right,60%,border-left,wrap' \
        --preview='sh -c '\''
            font="$1"
            size="${FOOT_FONT_SIZE:-12}"
            printf "\\033[1;36m%s\\033[0m\\n\\n" "$font"
            printf "\\033[2mTamanho atual no Foot: %sp\\033[0m\\n\\n" "$size"
            printf "\\033[1;33mAa Bb Çç Áá 0123456789\\033[0m\\n"
            printf "Português: ação, coração, maçã, pingüim.\\n"
            printf "ABCDEFGHIJKLMNOPQRSTUVWXYZ\\n"
            printf "abcdefghijklmnopqrstuvwxyz\\n"
            printf "! @ # $ %% ^ & * ( ) [ ] { } < > / \\\\ | ~ + = - _\\n\\n"
            printf "\\033[2mFontconfig resolve para:\\033[0m "
            fc-match -f "%{family} — %{style}\\n" "$font" 2>/dev/null | head -n 1
        '\'' _ {}'
    )

    if test $status -ne 0; or test -z "$selected"
        printf '\e[33mSeleção cancelada; nada foi alterado.\e[0m\n'
        return 130
    end
    set selected (string collect -- $selected | string trim)

    set -l font_size
    read --prompt-str='  Tamanho da fonte [12]: ' font_size
    if test -z "$font_size"
        set font_size 12
    end
    if not string match -rq '^[0-9]+([.][0-9]+)?$' -- "$font_size"
        printf '\e[31mErro:\e[0m tamanho inválido: %s\n' "$font_size" >&2
        return 1
    end

    set -l temporary (mktemp "$config.XXXXXX")
    if test $status -ne 0; or test -z "$temporary"
        printf '\e[31mErro:\e[0m não foi possível criar arquivo temporário.\n' >&2
        return 1
    end

    set -lx FOOT_SELECTED_FONT "$selected"
    set -lx FOOT_FONT_SIZE "$font_size"
    awk '
        BEGIN { IGNORECASE = 1; replaced = 0 }
        /^[[:space:]]*font[[:space:]]*=/ && !replaced {
            match($0, /^[[:space:]]*/)
            indent = substr($0, RSTART, RLENGTH)
            print indent "font=" ENVIRON["FOOT_SELECTED_FONT"] ":size=" ENVIRON["FOOT_FONT_SIZE"]
            replaced = 1
            next
        }
        { print }
    ' "$config" >"$temporary"

    if test $status -ne 0; or not mv "$temporary" "$config"
        rm -f "$temporary"
        printf '\e[31mErro:\e[0m não foi possível atualizar %s\n' "$config" >&2
        return 1
    end

    set -l restarted 1
    # killall foot também encerra o terminal onde a função está sendo
    # executada. Por isso a sequência fica em um processo desacoplado.
    nohup fish -c '
        sleep 0.2
        killall footclient 2>/dev/null
        killall foot 2>/dev/null
        sleep 0.2
        nohup foot --server >/dev/null 2>&1 &
    ' >/dev/null 2>&1 &
    disown

    printf '\e[32m✓ Fonte aplicada:\e[0m %s (%sp)\n' "$selected" "$font_size"
    if test $restarted -eq 1
        printf '\e[32m✓ Foot server reiniciado com foot --server.\e[0m\n'
    else
        printf '\e[33m! Não foi possível iniciar foot --server automaticamente.\e[0m\n'
    end
end
