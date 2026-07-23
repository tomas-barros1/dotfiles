-- Apps
hl.bind(MAIN_MOD .. " + RETURN", hl.dsp.exec_cmd(TERMINAL))
hl.bind(MAIN_MOD .. " + SPACE", hl.dsp.exec_cmd(MENU))
hl.bind(MAIN_MOD .. " + B", hl.dsp.exec_cmd(BROWSER))
hl.bind(MAIN_MOD .. " + E", hl.dsp.exec_cmd(FILE_MANAGER))
hl.bind(MAIN_MOD .. " + Z", hl.dsp.exec_cmd("zeditor"))
hl.bind(MAIN_MOD .. " + I", hl.dsp.exec_cmd(HOME_DIR .. "/.local/share/JetBrains/Toolbox/apps/intellij-idea/bin/idea"))
hl.bind(MAIN_MOD .. " + H", hl.dsp.exec_cmd("zeditor ~/dotfiles/hypr/.config/hypr/"))
hl.bind(MAIN_MOD .. " + V", hl.dsp.exec_cmd("walker -m clipboard"))
hl.bind(MAIN_MOD .. " + PERIOD", hl.dsp.exec_cmd("walker -m symbols"))
hl.bind(MAIN_MOD .. " + D", hl.dsp.exec_cmd("~/.local/bin/powermenu.sh"))
hl.bind(MAIN_MOD .. " + " .. SHIFT_MOD .. " + W", hl.dsp.exec_cmd(HOME_DIR .. "/.local/bin/wallpaper-select.sh"))
hl.bind(MAIN_MOD .. " + S", hl.dsp.exec_cmd("steam"))

-- Screenshots
hl.bind("PRINT", hl.dsp.exec_cmd("flameshot gui -p ~/Pictures/Screenshots -c"))
hl.bind(MAIN_MOD .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind(
  MAIN_MOD .. " + " .. SHIFT_MOD .. " + T",
  hl.dsp.exec_cmd([[sh -c 'grim -g "$(slurp)" - | tesseract stdin stdout -l por | wl-copy']])
)

-- Window management
hl.bind(MAIN_MOD .. " + W", hl.dsp.window.close())
hl.bind(MAIN_MOD .. " + G", hl.dsp.window.float({ action = "toggle" }))
hl.bind(MAIN_MOD .. " + P", hl.dsp.window.pseudo())

-- View modes
hl.bind(MAIN_MOD .. " + F", hl.dsp.window.fullscreen())
hl.bind(MAIN_MOD .. " + F11", hl.dsp.window.fullscreen())

-- Layout
hl.bind(MAIN_MOD .. " + J", hl.dsp.layout("togglesplit"))

-- Mouse interactions
hl.bind(MAIN_MOD .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(MAIN_MOD .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Session control
hl.bind(MAIN_MOD .. " + M", hl.dsp.exit())

-- Focus navigation
hl.bind(MAIN_MOD .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(MAIN_MOD .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(MAIN_MOD .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(MAIN_MOD .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(MAIN_MOD .. " + " .. SHIFT_MOD .. " + left", hl.dsp.window.swap({ direction = "left" }))
hl.bind(MAIN_MOD .. " + " .. SHIFT_MOD .. " + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind(MAIN_MOD .. " + " .. SHIFT_MOD .. " + up", hl.dsp.window.swap({ direction = "up" }))
hl.bind(MAIN_MOD .. " + " .. SHIFT_MOD .. " + down", hl.dsp.window.swap({ direction = "down" }))

-- Workspaces
for i = 1, 9 do
  hl.bind(MAIN_MOD .. " + " .. i, hl.dsp.focus({ workspace = i }))
  hl.bind(MAIN_MOD .. " + " .. SHIFT_MOD .. " + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- Resize
hl.bind(MAIN_MOD .. " + equal", hl.dsp.window.resize({ x = 20, y = 20, relative = true }), { repeating = true })
hl.bind(MAIN_MOD .. " + minus", hl.dsp.window.resize({ x = -20, y = -20, relative = true }), { repeating = true })
hl.bind(MAIN_MOD .. " + 0", hl.dsp.window.resize({ x = 900, y = 600 }))

-- Media / Volume
hl.bind(
  "XF86AudioRaiseVolume",
  hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioLowerVolume",
  hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioMute",
  hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"),
  { locked = true, repeating = true }
)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
