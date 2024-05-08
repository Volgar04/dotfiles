local wezterm = require("wezterm")
local act = wezterm.action
local module = {}

function module.apply_to_config(config)
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

		-- --- WINDOWS/WORKSPACES ---
		-- Spawn window
		{ key = "C", mods = "CTRL|SHIFT", action = act.SpawnWindow },
		-- Activate window relative
		{ key = "P", mods = "CTRL|SHIFT", action = act.ActivateWindowRelative(-1) },
		{ key = "N", mods = "CTRL|SHIFT", action = act.ActivateWindowRelative(1) },
		-- Fuzzy find workspaces
		{
			key = "S",
			mods = "CTRL|SHIFT",
			action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
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
		-- {
		-- 	key = "h",
		-- 	mods = "CTRL",
		-- 	action = act.ActivatePaneDirection("Left"),
		-- },
		-- {
		-- 	key = "l",
		-- 	mods = "CTRL",
		-- 	action = act.ActivatePaneDirection("Right"),
		-- },
		-- {
		-- 	key = "k",
		-- 	mods = "CTRL",
		-- 	action = act.ActivatePaneDirection("Up"),
		-- },
		-- {
		-- 	key = "j",
		-- 	mods = "CTRL",
		-- 	action = act.ActivatePaneDirection("Down"),
		-- },
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
end

return module
