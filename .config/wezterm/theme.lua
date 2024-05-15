local colors = {}

colors.background = "#1f1f28"
colors.tab_bar = {
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
}
colors.ansi = {
	"#1f1f28",
	"#c84053",
	"#cf894e",
	"#77713f",
	"#4d699b",
	"#b35b79",
	"#597b75",
	"#545464",
}

return colors
