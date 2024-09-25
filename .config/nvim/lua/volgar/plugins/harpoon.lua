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
		end, { desc = "Add file" })
		vim.keymap.set("n", "<Leader>vv", function()
			ui.toggle_quick_menu()
		end, { desc = "Toggle quick menu" })
		vim.keymap.set("n", "<Leader>vj", function()
			ui.nav_next()
		end, { desc = "Navigate next" })
		vim.keymap.set("n", "<Leader>vk", function()
			ui.nav_prev()
		end, { desc = "Navigate previous" })
		vim.keymap.set("n", "<Leader>1", function()
			ui.nav_file(1)
		end, { desc = "Harpoon: First buffer" })
		vim.keymap.set("n", "<Leader>2", function()
			ui.nav_file(2)
		end, { desc = "Harpoon: Second buffer" })
		vim.keymap.set("n", "<Leader>3", function()
			ui.nav_file(3)
		end, { desc = "Harpoon: Third buffer" })
		vim.keymap.set("n", "<Leader>4", function()
			ui.nav_file(4)
		end, { desc = "Harpoon: Fourth buffer" })
	end,
}
