local wezterm = require("wezterm")
local module = {}

function module.apply_to_config(config)
	config.window_padding = {
		left = 7,
		right = 0,
		top = 7,
		bottom = 0,
	}

	config.color_scheme = "terafox"
	config.window_background_opacity = 0.95
	config.macos_window_background_blur = 30
	config.window_decorations = "RESIZE"
	config.use_dead_keys = false
	config.window_close_confirmation = "AlwaysPrompt"
	config.scrollback_lines = 3000
	config.default_workspace = "main"
end

return module
