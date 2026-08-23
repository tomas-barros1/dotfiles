-- Apps
hl.bind(MAIN_MOD .. " + RETURN", hl.dsp.exec_cmd(TERMINAL))
hl.bind(MAIN_MOD .. " + SPACE", hl.dsp.exec_cmd(MENU))
hl.bind(MAIN_MOD .. " + B", hl.dsp.exec_cmd(LAUNCH .. BROWSER))
hl.bind(MAIN_MOD .. " + E", hl.dsp.exec_cmd(LAUNCH .. FILE_MANAGER))
hl.bind(MAIN_MOD .. " + I", hl.dsp.exec_cmd(LAUNCH .. IDE))
hl.bind(MAIN_MOD .. " + H", hl.dsp.exec_cmd(TERMINAL .. " -- sh -lc 'cd " .. HYPR_DIR .. " && exec nvim'"))
hl.bind(MAIN_MOD .. " + V", hl.dsp.exec_cmd(CLIPBOARD))
hl.bind(MAIN_MOD .. " + PERIOD", hl.dsp.exec_cmd(SYMBOLS))
hl.bind(MAIN_MOD .. " + D", hl.dsp.exec_cmd(POWERMENU))
hl.bind(MAIN_MOD .. " + " .. SHIFT_MOD .. " + W", hl.dsp.exec_cmd(WALLPAPER_SELECT))
hl.bind(MAIN_MOD .. " + S", hl.dsp.exec_cmd(LAUNCH .. STEAM))
hl.bind(MAIN_MOD .. " + K", hl.dsp.exec_cmd(SUNSETR_TOGGLE))
hl.bind(MAIN_MOD .. " + T", hl.dsp.exec_cmd(SYSTEM_MONITOR))
hl.bind(MAIN_MOD .. " + Z", hl.dsp.exec_cmd(ZED_EDITOR))
hl.bind(MAIN_MOD .. " + N", hl.dsp.exec_cmd(NVIM))

-- Screenshots
hl.bind("PRINT", hl.dsp.exec_cmd(LAUNCH .. SCREENSHOT_GUI))
hl.bind(MAIN_MOD .. " + PRINT", hl.dsp.exec_cmd(SCREENSHOT_WINDOW))
hl.bind(MAIN_MOD .. " + " .. SHIFT_MOD .. " + T", hl.dsp.exec_cmd(SCREENSHOT_OCR))

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
hl.bind(
	MAIN_MOD .. " + equal",
	hl.dsp.window.resize({ x = RESIZE_STEP, y = RESIZE_STEP, relative = true }),
	{ repeating = true }
)
hl.bind(
	MAIN_MOD .. " + minus",
	hl.dsp.window.resize({ x = -RESIZE_STEP, y = -RESIZE_STEP, relative = true }),
	{ repeating = true }
)
hl.bind(MAIN_MOD .. " + 0", hl.dsp.window.resize(RESIZE_RESET))

-- Media / Volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(VOLUME_UP), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(VOLUME_DOWN), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(VOLUME_MUTE), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(PLAYERCTL_NEXT), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(PLAYERCTL_PLAY_PAUSE), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(PLAYERCTL_PLAY_PAUSE), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(PLAYERCTL_PREV), { locked = true })
