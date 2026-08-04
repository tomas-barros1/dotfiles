-- System
hl.window_rule({
  name = "xdg-desktop-portal-gtk",
  match = { class = "^(xdg-desktop-portal-gtk)$" },
  float = true,
  center = true,
  size = "1200 800",
})

-- Polkit agent
hl.window_rule({
  match = { class = "^(polkit-gnome-authentication-agent-1)$" },
  workspace = "unset",
})

-- Games
for _, class in ipairs({
  "^dota2$",
  "^cs2$",
  "^osu!$",
  "^gamescope$",
  "^Lunar Client",
  "^steam_app_",
}) do
  hl.window_rule({
    match = { class = class },
    fullscreen = true,
    immediate = true,
  })
end
