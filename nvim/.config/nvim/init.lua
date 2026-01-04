local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.cmd("filetype plugin indent on")
-- If vim is opened inside /src/ dir, move up to take all dire into account
-- (for tags and fuzzy finder)
if vim.fn['expand']('%:p:h:h') == '/home/whe/src' then
    vim.cmd.cd("..")
    vim.g.odoo_env = true
end
vim.lsp.enable('ruff')
require("whenrow")
