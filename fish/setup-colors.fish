#!/usr/bin/env fish
# ==============================================================================
# Script de execução única (One-Shot) para salvar as cores e variáveis no Fish
# Grava permanentemente em ~/.config/fish/fish_variables via set -Ux
# ==============================================================================

echo "🎨 Configurando cores do Hydro Prompt, FZF e tema Catppuccin Mocha..."

# Cores Universais e Exportadas do Prompt Hydro
set -Ux hydro_color_pwd       '#89B4FA' # Blue
set -Ux hydro_color_git       '#CBA6F7' # Mauve
set -Ux hydro_color_start     '#A6E3A1' # Green
set -Ux hydro_color_error     '#F38BA8' # Red
set -Ux hydro_color_prompt    '#CBA6F7' # Mauve
set -Ux hydro_color_duration  '#F9E2AF' # Yellow

# Opções do FZF (Universal e Exportada)
set -Ux FZF_DEFAULT_OPTS "\
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

set -Ux FZF_CTRL_T_OPTS \
    "--style full \
    --walker-skip .git,node_modules,target \
    --preview 'bat -n --theme=\"Catppuccin Mocha\" --color=always {}' \
    --bind 'ctrl-/:change-preview-window(down|hidden)'"

# Editor Padrão
set -Ux EDITOR nvim
set -Ux SUDO_EDITOR nvim

# Tema Catppuccin Mocha nativo do Fish
fish_config theme choose "catppuccin-mocha"

echo "✨ Pronto! Todas as variáveis foram salvas permanentemente no seu fish_variables."
