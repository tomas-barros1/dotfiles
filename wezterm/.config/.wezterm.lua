local wezterm = require("wezterm")

local function file_exists(path)
    local f = io.open(path, "r")
    if f ~= nil then io.close(f) return true else return false end
end

local config = {
    audible_bell = "Disabled",
    check_for_updates = false,
    color_scheme = "catppuccin-mocha",
    inactive_pane_hsb = {
        hue = 1.0,
        saturation = 1.0,
        brightness = 1.0,
    },
    font = wezterm.font("Hack Nerd Font"),
    font_size = 12.0,
    launch_menu = {},
    leader = { key = "a", mods = "CTRL" },
    disable_default_key_bindings = true,
    keys = {
        { key = "a", mods = "LEADER|CTRL",  action = wezterm.action{ SendString = "\x01" }},
        { key = "-", mods = "LEADER",       action = wezterm.action{ SplitVertical = { domain = "CurrentPaneDomain" }}},
        { key = "\\", mods = "LEADER",      action = wezterm.action{ SplitHorizontal = { domain = "CurrentPaneDomain" }}},
        { key = "z", mods = "LEADER",       action = "TogglePaneZoomState" },
        { key = "c", mods = "LEADER",       action = wezterm.action{ SpawnTab = "CurrentPaneDomain" }},
        { key = "h", mods = "LEADER",       action = wezterm.action{ ActivatePaneDirection = "Left" }},
        { key = "j", mods = "LEADER",       action = wezterm.action{ ActivatePaneDirection = "Down" }},
        { key = "k", mods = "LEADER",       action = wezterm.action{ ActivatePaneDirection = "Up" }},
        { key = "l", mods = "LEADER",       action = wezterm.action{ ActivatePaneDirection = "Right" }},
        { key = "H", mods = "LEADER|SHIFT", action = wezterm.action{ AdjustPaneSize = { "Left", 5 }}},
        { key = "J", mods = "LEADER|SHIFT", action = wezterm.action{ AdjustPaneSize = { "Down", 5 }}},
        { key = "K", mods = "LEADER|SHIFT", action = wezterm.action{ AdjustPaneSize = { "Up", 5 }}},
        { key = "L", mods = "LEADER|SHIFT", action = wezterm.action{ AdjustPaneSize = { "Right", 5 }}},
        { key = "1", mods = "LEADER",       action = wezterm.action{ ActivateTab = 0 }},
        { key = "2", mods = "LEADER",       action = wezterm.action{ ActivateTab = 1 }},
        { key = "3", mods = "LEADER",       action = wezterm.action{ ActivateTab = 2 }},
        { key = "4", mods = "LEADER",       action = wezterm.action{ ActivateTab = 3 }},
        { key = "5", mods = "LEADER",       action = wezterm.action{ ActivateTab = 4 }},
        { key = "6", mods = "LEADER",       action = wezterm.action{ ActivateTab = 5 }},
        { key = "7", mods = "LEADER",       action = wezterm.action{ ActivateTab = 6 }},
        { key = "8", mods = "LEADER",       action = wezterm.action{ ActivateTab = 7 }},
        { key = "9", mods = "LEADER",       action = wezterm.action{ ActivateTab = 8 }},
        { key = "&", mods = "LEADER|SHIFT", action = wezterm.action{ CloseCurrentTab = { confirm = true }}},
        { key = "x", mods = "LEADER",       action = wezterm.action{ CloseCurrentPane = { confirm = true }}},
        { key = "n", mods = "SHIFT|CTRL",   action = "ToggleFullScreen" },
        { key = "v", mods = "SHIFT|CTRL",   action = wezterm.action.PasteFrom 'Clipboard' },
        { key = "c", mods = "SHIFT|CTRL",   action = wezterm.action.CopyTo 'Clipboard' },
        { key = "+", mods = "SHIFT|CTRL",   action = "IncreaseFontSize" },
        { key = "-", mods = "SHIFT|CTRL",   action = "DecreaseFontSize" },
        { key = "0", mods = "SHIFT|CTRL",   action = "ResetFontSize" },
        { key = "LeftArrow",  mods = "CTRL", action = wezterm.action.AdjustPaneSize { "Left", 5 },  repeatable = true },
        { key = "RightArrow", mods = "CTRL", action = wezterm.action.AdjustPaneSize { "Right", 5 }, repeatable = true },
        { key = "UpArrow",    mods = "CTRL", action = wezterm.action.AdjustPaneSize { "Up", 5 },    repeatable = true },
        { key = "DownArrow",  mods = "CTRL", action = wezterm.action.AdjustPaneSize { "Down", 5 },  repeatable = true },
    },
    set_environment_variables = {},
}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    -- Define PowerShell 7 como shell padrão
    config.default_prog = { "C:\\Program Files\\PowerShell\\7\\pwsh.exe" }

    -- Adiciona PowerShell 7 ao menu de inicialização
    table.insert(config.launch_menu, {
        label = "PowerShell 7",
        args = { "C:\\Program Files\\PowerShell\\7\\pwsh.exe" },
    })

    -- Adiciona também o PowerShell legado (opcional)
    table.insert(config.launch_menu, {
        label = "PowerShell (Legacy)",
        args = { "powershell.exe", "-NoLogo" },
    })

    -- Detecta VS Tools e adiciona ao menu
    for _, vsvers in ipairs(wezterm.glob("Microsoft Visual Studio/20*", "C:/Program Files (x86)")) do
        local year = vsvers:gsub("Microsoft Visual Studio/", "")
        table.insert(config.launch_menu, {
            label = "x64 Native Tools VS " .. year,
            args = {
                "cmd.exe",
                "/k",
                "C:/Program Files (x86)/" .. vsvers .. "/BuildTools/VC/Auxiliary/Build/vcvars64.bat"
            },
        })
    end
else
    local fish_bin_path = "/bin/fish"
    if file_exists("/opt/homebrew/bin/fish") then
        fish_bin_path = "/opt/homebrew/bin/fish"
        config.default_prog = { '/opt/homebrew/bin/fish', '-l' }
    else
        config.default_prog = { '/bin/bash', '-l' }
    end
    table.insert(config.launch_menu, { label = "fish", args = { fish_bin_path, "-l" } })
    table.insert(config.launch_menu, { label = "bash", args = { "bash", "-l" } })
end

return config
