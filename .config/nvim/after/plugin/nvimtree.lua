-- vim.keymap.set('n', '-', '<cmd>NvimTreeToggle<CR>', { desc = 'Open nvim tree' })

local function on_attach(bufnr)
  local api = require 'nvim-tree.api'

  local function opts(desc)
    return { desc = 'Nvim-Tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', '<C-c>', '<cmd>NvimTreeClose<CR>', opts('Close'))
end

require("nvim-tree").setup {
  on_attach = on_attach,
  disable_netrw = true,
  hijack_netrw = true,
  respect_buf_cwd = true,
  sync_root_with_cwd = true,
  git = {
    enable = true,
    ignore = true,
  },
  renderer = {
    highlight_git = true,
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = false,
      },
    },
  },
}
