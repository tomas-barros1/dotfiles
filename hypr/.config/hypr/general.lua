local colors = require("catppuccin-mocha")

hl.config({
  general = {
    border_size = 3,
    resize_on_border = true,
    gaps_in = 4,
    gaps_out = 8,
    layout = "dwindle",
    allow_tearing = true,
    col = {
      active_border = {
        colors = { colors.mauve, colors.lavender },
        angle = 45
      },
      inactive_border = colors.surface1,
    }
  },
  misc = {
    disable_hyprland_logo = true,
    mouse_move_enables_dpms = false,
  },
})
