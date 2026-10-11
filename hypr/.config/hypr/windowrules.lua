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

-- Celluloid
hl.window_rule({
	match = { class = "^(io.github.celluloid_player.Celluloid)$" },
	fullscreen = false,
	float = false,
	suppress_event = "maximize fullscreen",
})
