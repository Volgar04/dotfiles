return {
	"akinsho/flutter-tools.nvim",
	ft = "dart",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"stevearc/dressing.nvim", -- optional for vim.ui.select
	},
	config = function()
		require("flutter-tools").setup({
			dev_tools = {
				autostart = true,
				auto_open_browser = true,
			},
			dev_log = {
				-- enabled = false,
				-- open_cmd = "MyTroubleLikeSplit",
			},
			lsp = {
				settings = {
					lineLength = 120,
				},
			},
		})

		vim.keymap.set("n", "<leader>ff", "<cmd>Telescope flutter commands<CR>", { desc = "Flutter commands" })
		-- vim.keymap.set(
		-- 	"n",
		-- 	"<leader>fr",
		-- 	'<cmd>1TermExec direction=horizontal name=flutter cmd="flutter run"<CR>',
		-- 	{ desc = "Flutter run" }
		-- )
		vim.keymap.set("n", "<leader>fr", "<cmd>FlutterRun<CR>", { desc = "Flutter run" })
		vim.keymap.set("n", "<leader>ft", "<cmd>FlutterRestart<CR>", { desc = "Flutter restart" })
		vim.keymap.set("n", "<leader>fd", "<cmd>FlutterReload<CR>", { desc = "Flutter reload" })
		vim.keymap.set("n", "<leader>fq", "<cmd>FlutterQuit<CR>", { desc = "Flutter quit" })
		-- vim.keymap.set("n", "<leader>fq", '<cmd>1TermExec cmd="<C-c>exit"<CR>', { desc = "Flutter quit" })
		vim.keymap.set("n", "<leader>fe", "<cmd>FlutterEmulators<CR>", { desc = "Flutter quit" })
	end,
}
