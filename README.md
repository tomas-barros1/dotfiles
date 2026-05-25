# Dotfiles

Personal dotfiles for configuring a Linux/Windows development environment. Managed with [GNU Stow](https://www.gnu.org/software/stow/) for easy symlink management.

## What's Included

| Category | Tools |
|----------|-------|
| **Window Manager** | Hyprland |
| **Terminals** | Alacritty, Kitty, WezTerm, Foot, Windows Terminal |
| **Shells** | Zsh, Fish, PowerShell |
| **Editors** | Neovim (AstroNvim, NvChad, LazyVim), Lite XL, Zed, VS Code |
| **Launchers** | Rofi, Wofi, Walker |
| **Bar / Notifications** | Waybar, Swaync |
| **Utilities** | Btop, Tmux, Yazi, Eza, Starship, Oh My Posh |

## Setup

```bash
sudo pacman -S stow
stow <module>
```

Example:
```bash
stow hypr
stow nvim
stow zellij
stow zed
stow swaync
stow wofi
stow wezterm
```

## Themes

Most configs use the [Catppuccin Mocha](https://github.com/catppuccin/catppuccin) color scheme.
