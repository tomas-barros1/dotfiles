-- xdg-desktop-portal-gtk: sempre flutuante e centralizada
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

-- Classes de jogos (fonte única de verdade, usada nas regras e no DND)
local GAME_CLASSES = {
	"^dota2$",
	"^cs2$",
	"^osu!$",
	"^gamescope$",
	"^Lunar Client",
	"^Minecraft",
	"^steam_app_",
}

local function matches_any(str, patterns)
	if not str then
		return false
	end
	for _, pattern in ipairs(patterns) do
		if str:match(pattern) then
			return true
		end
	end
	return false
end

-- Regra de fullscreen para jogos
for _, class in ipairs(GAME_CLASSES) do
	hl.window_rule({
		match = { class = class },
		fullscreen = true,
		immediate = true,
	})
end

-- Auto Do Not Disturb: suprime notificações do Noctalia em fullscreen e em janelas de jogo
local dnd_active = false

local function set_dnd(on)
	if on == dnd_active then
		return
	end
	dnd_active = on
	hl.exec_cmd(NOCTALIA .. "notification-dnd-set " .. (on and "on" or "off"))
end

local function should_dnd(window)
	if not window then
		return false
	end
	return matches_any(window.class, GAME_CLASSES)
end

local function update_dnd(window)
	set_dnd(should_dnd(window))
end

hl.on("window.fullscreen", update_dnd)
hl.on("window.active", update_dnd)

-- Workspaces 1-5 persistentes (sempre visíveis no Noctalia)
for i = 1, 5 do
	hl.workspace_rule({
		workspace = tostring(i),
		monitor = "DP-1",
		persistent = true,
	})
end
