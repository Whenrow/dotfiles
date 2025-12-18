require('whenrow.set')
require('whenrow.remap')
require('whenrow.lazy')
require('whenrow.lualine')

local autocmd = vim.api.nvim_create_autocmd
-- Remove trailing whitespace on save
autocmd({"BufWritePre"}, {
    pattern = "*",
    command = [[%s/\s\+$//e]],
})


if vim.env.ODOO == 'true' then
    vim.lsp.enable('odools')
end

RELOAD = function(module)
  return require("plenary.reload").reload_module(module)
end

R = function(module)
  RELOAD(module)
  return require(module)
end
P = function(v)
  print(vim.inspect(v))
  return v
end
