-- System
hl.window_rule({
  name = "xdg-desktop-portal-gtk",
  match = { class = "^(xdg-desktop-portal-gtk)$" },
  float = true,
  center = true,
  size = "1200 800",
})

-- Games
for _, class in ipairs({ "^dota2$", "^osu!$", "^Lunar Client"
}) do
  hl.window_rule({
    match = { class = class },
    fullscreen = true,
    immediate = true,
  })
end
