local wezterm = require("wezterm")
local act = wezterm.action
local config = {}

-- Colors
config.colors = {
	background = "#0d1117",
	tab_bar = {
		active_tab = {
			bg_color = "#0d1117",
			fg_color = "#c9d1d9",
			intensity = "Bold",
			italic = true,
		},
		inactive_tab = {
			bg_color = "#000000",
			fg_color = "#6A7179",
		},
		new_tab = {
			bg_color = "#0d1117",
			fg_color = "#c9d1d9",
		},
	},
}
-- Font
config.font = wezterm.font("JetBrains Mono", {})
config.font_size = 12.3
-- Window
config.window_frame = {
	font = wezterm.font({ family = "Roboto", weight = "Bold" }),
	font_size = 12.3,
	active_titlebar_bg = "#000000",
}
-- Keys
config.use_dead_keys = false
config.leader = { key = "a", mods = "CTRL", timeout_nilliseconds = 1000 }
config.keys = {
	-- ---------- TABS ----------
	-- Spawn tab
	{
		key = "c",
		mods = "LEADER",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	-- Activate tab relative
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },

	-- ---------- WINDOWS ----------
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

	-- ---------- PANES ----------
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
