-- Open all apps on the workspace they were launched from
hl.window_rule({
  match = { class = ".*" },
  workspace = "unset",
})

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
  "^dota2$", "^osu!$", "^Lunar Client",
  "^steam_app_", "^gamescope$",
}) do
  hl.window_rule({
    match = { class = class },
    fullscreen = true,
    immediate = true,
  })
end
