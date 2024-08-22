return {
	"ThePrimeagen/harpoon",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("harpoon").setup({})

		local mark = require("harpoon.mark")
		local ui = require("harpoon.ui")

		vim.keymap.set("n", "<Leader>vh", function()
			mark.add_file()
		end)
		vim.keymap.set("n", "<Leader>vv", function()
			ui.toggle_quick_menu()
		end)
		vim.keymap.set("n", "<Leader>vj", function()
			ui.nav_next()
		end)
		vim.keymap.set("n", "<Leader>vk", function()
			ui.nav_prev()
		end)
		vim.keymap.set("n", "<Leader>1", function()
			ui.nav_file(1)
		end)
		vim.keymap.set("n", "<Leader>2", function()
			ui.nav_file(2)
		end)
		vim.keymap.set("n", "<Leader>3", function()
			ui.nav_file(3)
		end)
		vim.keymap.set("n", "<Leader>4", function()
			ui.nav_file(4)
		end)
	end,
}
