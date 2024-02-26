vim.keymap.set('n', '<leader>tu', vim.cmd.UndotreeToggle, { desc = "[T]oggle [U]ndotree" })

-- Change undotree layout
vim.g.undotree_WindowLayout = 2
-- Increase split layout width
vim.g.undotree_SplitWidth = 40
-- Increase diff layout height
vim.g.undotree_DiffpanelHeight = 25
