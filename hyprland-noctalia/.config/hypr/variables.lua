TERMINAL = "footclient"
FILE_MANAGER = "nautilus"
BROWSER = "helium-browser"
SYS_MONITOR = "btop"
EDITOR = TERMINAL .. " -e /home/tom/.local/share/mise/installs/neovim/0.11/bin/nvim"
MAIN_MOD = "SUPER"
SHIFT_MOD = "SHIFT"
HOME_DIR = os.getenv("HOME")

-- Noctalia replaces walker, flameshot, waybar, swaync and the old scripts
NOCTALIA = "noctalia msg "
LAUNCH = "uwsm app -- " -- uwsm-managed launches (as in the old config)
MENU = NOCTALIA .. "panel-toggle launcher"
MENU_EMOJI = NOCTALIA .. "panel-toggle launcher /emo"
MENU_CLIPBOARD = NOCTALIA .. "panel-toggle clipboard"
MENU_POWER = NOCTALIA .. "panel-toggle session"
MENU_WALLPAPER = NOCTALIA .. "panel-toggle wallpaper"
