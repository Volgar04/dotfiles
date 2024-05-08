local wezterm = require("wezterm")
local mux = wezterm.mux
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
local workspaces = require("workspaces")

wezterm.on("gui-startup", function()
	workspaces.loadWorkspaces()
end)

wezterm.on("save-workspaces", function()
	local activeWorkspace = mux.get_active_workspace()
	print(mux.all_windows())
	for _, window in ipairs(mux.all_windows()) do
		if window:get_workspace() == activeWorkspace then
			window:gui_window():toast_notification("(Workspaces)", "Saving workspaces...", nil, 5000)
		end
	end
	workspaces.saveWorkspaces()
end)

return config
