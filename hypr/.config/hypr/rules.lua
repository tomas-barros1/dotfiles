hl.config({
  misc = {
    disable_hyprland_logo = true,
    vrr = 1,
  },
})

hl.window_rule({
  name = "dota-fullscreen",
  match = { title = "^(DotA)$" },
  fullscreen = true,
})