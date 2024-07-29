local wezterm = require("wezterm")
local act = wezterm.action
local module = {}

-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
	-- this is set by the plugin, and unset on ExitPre in Neovim
	return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "META" or "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
				}, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

function module.apply_to_config(config)
	config.use_dead_keys = false
	config.leader = { key = "/", mods = "CTRL", timeout_nilliseconds = 1000 }
	config.keys = {
		{
			key = ".",
			mods = "LEADER",
			action = wezterm.action.ActivateCommandPalette,
		},
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
			key = "s",
			mods = "LEADER",
			action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
		},
		-- Prompt for a name to use for a new workspace and switch to it.
		{
			key = "w",
			mods = "LEADER",
			action = act.PromptInputLine({
				description = wezterm.format({
					{ Attribute = { Intensity = "Bold" } },
					{ Foreground = { AnsiColor = "Fuchsia" } },
					{ Text = "Enter name for new workspace" },
				}),
				action = wezterm.action_callback(function(window, pane, line)
					-- line will be `nil` if they hit escape without entering anything
					-- An empty string if they just hit enter
					-- Or the actual line of text they wrote
					if line then
						window:perform_action(
							act.SwitchToWorkspace({
								name = line,
							}),
							pane
						)
					end
				end),
			}),
		},

		-- --- PANES ---
		-- Split vertical
		{
			key = "-",
			mods = "LEADER",
			action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		-- Split horizontal
		{
			key = "|",
			mods = "LEADER",
			action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		-- move between split panes
		split_nav("move", "h"),
		split_nav("move", "j"),
		split_nav("move", "k"),
		split_nav("move", "l"),
		-- resize panes
		split_nav("resize", "h"),
		split_nav("resize", "j"),
		split_nav("resize", "k"),
		split_nav("resize", "l"),
		-- Maximize pane
		{
			key = "m",
			mods = "LEADER",
			action = act.TogglePaneZoomState,
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
