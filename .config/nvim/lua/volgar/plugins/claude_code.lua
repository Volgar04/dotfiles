return {
	"greggh/claude-code.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim", -- Required for git operations
	},
	config = function()
		require("claude-code").setup({
			-- Terminal window settings
			window = {
				split_ratio = 0.4, -- Percentage of screen for the terminal window (height for horizontal, width for vertical splits)
				position = "vertical", -- Position of the window: "botright", "topleft", "vertical", "float", etc.
			},
			-- Keymaps
			keymaps = {
				toggle = {
					normal = "<leader>cc", -- Normal mode keymap for toggling Claude Code, false to disable
					terminal = "<leader>cc", -- Terminal mode keymap for toggling Claude Code, false to disable
					variants = {
						continue = "<leader>cC", -- Normal mode keymap for Claude Code with continue flag
						verbose = "<leader>cV", -- Normal mode keymap for Claude Code with verbose flag
					},
				},
			},
		})

		-- vim.keymap.set("n", "<leader>cc", "<cmd>ClaudeCode<CR>", { desc = "Toggle Claude Code" })
	end,
}
