local wezterm = require("wezterm")
local module = {}

function module.apply_to_config(config)
	config.window_frame = {
		font = wezterm.font({ family = "Roboto", weight = "Bold" }),
		font_size = 12.3,
		active_titlebar_bg = "#000000",
	}

	config.use_fancy_tab_bar = false
	config.tab_bar_at_bottom = false
end

return module
