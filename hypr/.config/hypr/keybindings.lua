local home = os.getenv("HOME")
local mod = "SUPER"
local terminal = "uwsm app -- xdg-terminal-exec"
local launch = "uwsm app -- "

-- Apps
hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd("nc -U /run/user/1000/walker/walker.sock"))
hl.bind(mod .. " + B", hl.dsp.exec_cmd(launch .. "helium-browser"))
hl.bind(mod .. " + E", hl.dsp.exec_cmd(launch .. "nautilus"))
hl.bind(mod .. " + I", hl.dsp.exec_cmd(launch .. home .. "/.local/share/JetBrains/Toolbox/apps/intellij-idea/bin/idea"))
hl.bind(mod .. " + H", hl.dsp.exec_cmd(terminal .. " -- sh -lc 'cd " .. home .. "/.config/hypr && exec nvim'"))
hl.bind(mod .. " + V", hl.dsp.exec_cmd("walker -m clipboard"))
hl.bind(mod .. " + PERIOD", hl.dsp.exec_cmd("walker -m symbols"))
hl.bind(mod .. " + D", hl.dsp.exec_cmd(home .. "/.local/scripts/powermenu.sh"))
hl.bind(mod .. " + SHIFT + W", hl.dsp.exec_cmd("waypaper_rs"))
hl.bind(mod .. " + S", hl.dsp.exec_cmd(launch .. "steam"))
hl.bind(mod .. " + K", hl.dsp.exec_cmd([[sh -c 'pgrep -x sunsetr > /dev/null && pkill sunsetr || sunsetr &']]))
hl.bind(mod .. " + T", hl.dsp.exec_cmd(terminal .. " -- btop"))
hl.bind(mod .. " + Z", hl.dsp.exec_cmd("zeditor"))
hl.bind(mod .. " + N", hl.dsp.exec_cmd(terminal .. " -- nvim"))

-- Screenshots
hl.bind("PRINT", hl.dsp.exec_cmd(launch .. "flameshot gui -p " .. home .. "/Screenshots -c"))
hl.bind(mod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind(
	mod .. " + SHIFT + T",
	hl.dsp.exec_cmd([[sh -c 'grim -g "$(slurp)" - | tesseract stdin stdout -l por | wl-copy']])
)

-- Window management
hl.bind(mod .. " + W", hl.dsp.window.close())
hl.bind(mod .. " + G", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + P", hl.dsp.window.pseudo())

-- View modes
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + F11", hl.dsp.window.fullscreen())

-- Layout
hl.bind(mod .. " + J", hl.dsp.layout("togglesplit"))

-- Toggle layout scrolling/dwindle na workspace atual
local scroll_state = {} -- workspace.id -> true (scrolling) | false/nil (dwindle)

hl.bind(mod .. " + L", function()
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
	hl.exec_cmd(string.format('notify-send "Workspace %d" "Layout: %s"', workspace.id, label))
end)

-- Mouse interactions
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Session control
hl.bind(mod .. " + M", hl.dsp.exit())

-- Focus navigation
hl.bind(mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(mod .. " + SHIFT + left", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mod .. " + SHIFT + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mod .. " + SHIFT + up", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mod .. " + SHIFT + down", hl.dsp.window.swap({ direction = "down" }))

-- Workspaces
for i = 1, 9 do
	hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- Resize
local resize_step = 20
hl.bind(
	mod .. " + equal",
	hl.dsp.window.resize({ x = resize_step, y = resize_step, relative = true }),
	{ repeating = true }
)
hl.bind(
	mod .. " + minus",
	hl.dsp.window.resize({ x = -resize_step, y = -resize_step, relative = true }),
	{ repeating = true }
)
hl.bind(mod .. " + 0", hl.dsp.window.resize({ x = 900, y = 600 }))

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
