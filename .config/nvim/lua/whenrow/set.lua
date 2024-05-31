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
vim.cmd([[highlight ColorColumn ctermbg=0 guibg=#313244]])
vim.opt.cc = "100"
-- open terminal mode in insert mode
vim.cmd([[autocmd TermOpen * startinsert]])
--""==================
--"" Tree view
--""==================
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 20
vim.g.unstack_open_tab=0
vim.g.unstack_populate_quickfix=1
