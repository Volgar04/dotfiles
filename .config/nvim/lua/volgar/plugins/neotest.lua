return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"sidlatau/neotest-dart",
	},
	opts = function()
		return {
			adapters = {
				require("neotest-dart")({
					command = "flutter",
					use_lsp = true,
					custom_test_method_names = {},
				}),
			},
		}
	end,
	config = function(_, opts)
		require("neotest").setup(opts)

		vim.keymap.set("n", "<Leader>Tr", function()
			require("neotest").run.run()
		end, { desc = "Run closest test" })
		vim.keymap.set("n", "<Leader>Ta", function()
			require("neotest").run.run({ suite = true })
		end, { desc = "Run all test" })
		vim.keymap.set("n", "<Leader>To", function()
			require("neotest").summary.toggle()
		end, { desc = "Toggle test summary" })
	end,
}
