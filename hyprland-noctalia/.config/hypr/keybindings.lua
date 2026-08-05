-- Apps
hl.bind(MAIN_MOD .. " + RETURN", hl.dsp.exec_cmd(LAUNCH .. TERMINAL))
hl.bind(MAIN_MOD .. " + SPACE", hl.dsp.exec_cmd(MENU))
hl.bind(MAIN_MOD .. " + B", hl.dsp.exec_cmd(LAUNCH .. BROWSER))
hl.bind(MAIN_MOD .. " + E", hl.dsp.exec_cmd(LAUNCH .. FILE_MANAGER))
hl.bind(MAIN_MOD .. " + Z", hl.dsp.exec_cmd(LAUNCH .. "zeditor"))
hl.bind(MAIN_MOD .. " + N", hl.dsp.exec_cmd(LAUNCH .. EDITOR))
hl.bind(MAIN_MOD .. " + T", hl.dsp.exec_cmd(LAUNCH .. TERMINAL .. " -e " .. SYS_MONITOR))
hl.bind(
	MAIN_MOD .. " + I",
	hl.dsp.exec_cmd(LAUNCH .. HOME_DIR .. "/.local/share/JetBrains/Toolbox/apps/intellij-idea/bin/idea")
)
hl.bind(MAIN_MOD .. " + H", hl.dsp.exec_cmd(LAUNCH .. EDITOR .. " ~/dotfiles/hyprland-noctalia/.config/hypr/"))
hl.bind(MAIN_MOD .. " + V", hl.dsp.exec_cmd(MENU_CLIPBOARD))
hl.bind(MAIN_MOD .. " + PERIOD", hl.dsp.exec_cmd(MENU_EMOJI))
hl.bind(MAIN_MOD .. " + D", hl.dsp.exec_cmd(MENU_POWER))
hl.bind(MAIN_MOD .. " + " .. SHIFT_MOD .. " + W", hl.dsp.exec_cmd(MENU_WALLPAPER))
hl.bind(MAIN_MOD .. " + S", hl.dsp.exec_cmd(LAUNCH .. "steam"))

-- Toggle night light
hl.bind(MAIN_MOD .. " + K", hl.dsp.exec_cmd("noctalia msg nightlight-toggle"))

-- Text extractor
hl.bind(
	MAIN_MOD .. " + " .. SHIFT_MOD .. " + T",
	hl.dsp.exec_cmd([[sh -c 'grim -g "$(slurp)" - | tesseract stdin stdout -l por | wl-copy']])
)

-- Screenshots
hl.bind("PRINT", hl.dsp.exec_cmd(NOCTALIA .. "screenshot-region"))
hl.bind(MAIN_MOD .. " + PRINT", hl.dsp.exec_cmd(NOCTALIA .. "screenshot-fullscreen pick"))

-- Window management
hl.bind(MAIN_MOD .. " + W", hl.dsp.window.close())
hl.bind(MAIN_MOD .. " + G", hl.dsp.window.float({ action = "toggle" }))
hl.bind(MAIN_MOD .. " + P", hl.dsp.window.pseudo())

-- View modes
hl.bind(MAIN_MOD .. " + F", hl.dsp.window.fullscreen())
hl.bind(MAIN_MOD .. " + F11", hl.dsp.window.fullscreen())

-- Toggle layout scrolling/dwindle na workspace atual
local scroll_state = {} -- workspace.id -> true (scrolling) | false/nil (dwindle)

hl.bind(MAIN_MOD .. " + L", function()
	local workspace = hl.get_active_workspace()
	if not workspace then
		return
	end

	local using_scrolling = not scroll_state[workspace.id]
	scroll_state[workspace.id] = using_scrolling

	hl.workspace_rule({
		workspace = tostring(workspace.id),
		layout = using_scrolling and "scrolling" or "dwindle",
	})

	local label = using_scrolling and "Scrolling" or "Dwindle"
	hl.exec_cmd(NOCTALIA .. 'notification-show "Layout: ' .. label .. " (ws " .. workspace.id .. ')"')
end)

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

-- Media / Volume (via Noctalia)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(NOCTALIA .. "volume-up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(NOCTALIA .. "volume-down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(NOCTALIA .. "volume-mute"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(NOCTALIA .. "media next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(NOCTALIA .. "media toggle"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(NOCTALIA .. "media toggle"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(NOCTALIA .. "media previous"), { locked = true })
