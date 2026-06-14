hl.curve("linear", { type = "bezier", points = { { 0.0, 0.0 }, { 1, 1 } } })

hl.animation({ leaf = "borderangle", enabled = true, speed = 50, bezier = "linear", style = "loop" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 0.5, bezier = "default" })
hl.animation({ leaf = "windows", enabled = false, speed = 0.1, bezier = "default" })
hl.animation({ leaf = "fade", enabled = false, speed = 0.1, bezier = "default" })
