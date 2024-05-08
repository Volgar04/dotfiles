local module = {}

function module.apply_to_config(config)
	config.unix_domains = {
		{
			name = "main",
		},
	}
	config.default_gui_startup_args = { "connect", "main" }
end

return module
