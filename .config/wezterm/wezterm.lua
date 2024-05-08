local wezterm = require("wezterm")
local act = wezterm.action
local config = {}

config.font = wezterm.font("JetBrains Mono", { weight = "Bold" })
config.font_size = 12.3
config.adjust_window_size_when_changing_font_size = false

config.window_padding = {
	left = 7,
	right = 0,
	top = 7,
	bottom = 0,
}

config.colors = require("theme")

local tab_bar = require("tab_bar")
tab_bar.apply_to_config(config)

local keybinds = require("keybinds")
keybinds.apply_to_config(config)

local multiplexing = require("multiplexing")
multiplexing.apply_to_config(config)

wezterm.on("update-right-status", function(window, _)
	window:set_right_status(window:active_workspace())
end)

wezterm.on("augment-command-palette", function(_, _)
	return {
		{
			brief = "Rename tab",
			icon = "md_rename_box",

			action = act.PromptInputLine({
				description = "Enter new name for tab",
				action = wezterm.action_callback(function(window, _, line)
					if line then
						window:active_tab():set_title(line)
					end
				end),
			}),
		},
	}
end)

return config
