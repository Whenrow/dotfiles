require('oil').setup({
    default_file_explorer = false,
})
vim.keymap.set("n", "-", vim.cmd.Oil)
