vim.keymap.set('n', '<leader>x', vim.cmd.source)
vim.keymap.set('v', '<leader>x', ':lua<CR>')
vim.lsp.enable('lua_ls')
