return {
	"m00qek/baleia.nvim",
	version = "*",
	config = function()
		vim.g.baleia = require("baleia").setup({})

		-- Command to colorize the current buffer
		vim.api.nvim_create_user_command("BaleiaColorize", function()
			vim.g.baleia.once(vim.api.nvim_get_current_buf())
		end, { bang = true })

		-- Command to show logs
		vim.api.nvim_create_user_command("BaleiaLogs", vim.g.baleia.logger.show, { bang = true })

		-- vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
		-- 	pattern = "*.txt",
		-- 	callback = function()
		-- 		vim.g.baleia.automatically(vim.api.nvim_get_current_buf())
		-- 	end,
		-- })
		-- local baleia = require("baleia").setup({ line_starts_at = 6 })
		-- vim.api.nvim_create_autocmd("BufWinEnter", {
		-- 	pattern = "__FLUTTER_DEV_LOG__",
		-- 	callback = function()
		-- 		vim.o.modifiable = true
		-- 		baleia.automatically(vim.fn.bufnr(vim.fn.expand("%")))
		-- 		vim.cmd([[%s/\v\e\[[0-9;]*[a-zA-Z]//g]])
		-- 		vim.o.modifiable = false
		-- 	end,
		-- })
	end,
}
