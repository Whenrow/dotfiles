vim.treesitter.start()
vim.keymap.set('n', '<leader>x', ':!python %<CR>')
vim.lsp.enable('ruff')
vim.lsp.enable('basedpyright')

