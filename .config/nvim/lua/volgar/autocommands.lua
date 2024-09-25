-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- vim.api.nvim_create_autocmd("BufWritePost", {
-- 	desc = "Stop Go LSP when saving a templ file",
-- 	pattern = "*.templ",
-- 	command = "LspStop gopls",
-- })

vim.api.nvim_create_user_command("MyTroubleLikeSplit", function(opts)
	-- local current_win = vim.api.nvim_get_current_win()
	vim.cmd("botright 18split")
	vim.cmd("edit " .. opts.args)
	vim.cmd("setlocal winfixheight")
	vim.cmd("setlocal nonumber norelativenumber")
	vim.cmd("setlocal signcolumn=no")
	vim.wo.winhl = "Normal:StatusLine"
	-- vim.api.nvim_set_current_win(current_win)
end, { nargs = 1 })
