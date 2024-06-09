return {
	"xiyaowong/transparent.nvim",
	lazy = false,
	config = function()
		require("transparent").setup({
			exclude_groups = {
				"NormalFloat",
				"NvimTree",
			},
		})
	end,
}
