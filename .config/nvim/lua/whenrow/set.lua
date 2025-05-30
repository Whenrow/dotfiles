vim.api.nvim_create_augroup("Random", {clear = true})
vim.opt.autoread = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.expandtab = true
vim.opt.hidden = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.shiftwidth=4
vim.opt.softtabstop=4
vim.opt.spell = true
vim.opt.swapfile = false
vim.opt.tags = ".tags"
vim.opt.termguicolors = true
vim.opt.textwidth = 100
vim.opt.undofile = true
vim.cmd([[highlight ColorColumn ctermbg=0 guibg=#313244]])
vim.opt.cc = "100"
-- open terminal mode in insert mode
vim.cmd([[autocmd TermOpen * startinsert]])
vim.api.nvim_create_autocmd("TermOpen", {
    group = "Random",
    command = "setlocal nonumber norelativenumber signcolumn=no"
})
