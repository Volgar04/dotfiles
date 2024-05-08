local wezterm = require("wezterm")
local act = wezterm.action
local config = {}

-- ---------------------- COLORS ----------------------
config.use_fancy_tab_bar = false
config.colors = {
	background = "#f2ecbc",
	tab_bar = {
		background = "black",
		active_tab = {
			bg_color = "#545465",
			fg_color = "#f2ecbc",
			intensity = "Bold",
			italic = true,
		},
		inactive_tab = {
			bg_color = "#D7CE9E",
			fg_color = "#a09cac",
		},
		inactive_tab_hover = {
			bg_color = "#545465",
			fg_color = "#f2ecbc",
			intensity = "Bold",
		},
		new_tab = {
			bg_color = "#f2ecbc",
			fg_color = "#545465",
		},
		new_tab_hover = {
			bg_color = "#f2ecbc",
			fg_color = "#545465",
			intensity = "Bold",
		},
	},
	ansi = {
		"#1f1f28",
		"#c84053",
		"#cf894e",
		"#77713f",
		"#4d699b",
		"#b35b79",
		"#597b75",
		"#545464",
	},
}

-- ---------------------- FONT ----------------------
config.font = wezterm.font("JetBrains Mono", { weight = "Bold" })
config.font_size = 12.3

-- ---------------------- WINDOW ----------------------
config.window_frame = {
	font = wezterm.font({ family = "Roboto", weight = "Bold" }),
	font_size = 12.3,
	active_titlebar_bg = "#000000",
}

-- ---------------------- KEYS ----------------------
config.use_dead_keys = false
config.leader = { key = "a", mods = "CTRL", timeout_nilliseconds = 1000 }
config.keys = {
	-- --- TABS ---
	-- Spawn tab
	{
		key = "c",
		mods = "LEADER",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	-- Activate tab relative
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },

	-- --- WINDOWS ---
	-- Spawn window
	{ key = "C", mods = "CTRL|SHIFT", action = act.SpawnWindow },
	-- Activate window relative
	{ key = "P", mods = "CTRL|SHIFT", action = act.ActivateWindowRelative(-1) },
	{ key = "N", mods = "CTRL|SHIFT", action = act.ActivateWindowRelative(1) },
	-- Toggle full screen
	{
		key = "F",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ToggleFullScreen,
	},

	-- --- PANES ---
	-- Resize pane
	{
		key = "H",
		mods = "ALT|SHIFT",
		action = act.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "L",
		mods = "ALT|SHIFT",
		action = act.AdjustPaneSize({ "Right", 5 }),
	},
	{
		key = "J",
		mods = "ALT|SHIFT",
		action = act.AdjustPaneSize({ "Down", 5 }),
	},
	{
		key = "K",
		mods = "ALT|SHIFT",
		action = act.AdjustPaneSize({ "Up", 5 }),
	},
	-- Activate pane direction
	{
		key = "h",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "k",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "j",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Down"),
	},
	-- Split vertical
	{
		key = "_",
		mods = "ALT|SHIFT",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	-- Split horizontal
	{
		key = "|",
		mods = "ALT|SHIFT",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
}
-- Activate tab by index
for i = 1, 8 do
	-- CTRL+ALT + number to activate that tab
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})
	-- F1 through F8 to activate that tab
	table.insert(config.keys, {
		key = "F" .. tostring(i),
		action = act.ActivateTab(i - 1),
	})
end

return config
