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


-- If vim is opened inside /src/ dir, move up to take all dire into account
-- (for tags and fuzzy finder)
if vim.fn['expand']('%:p:h:h') == '/home/whe/src' then
    vim.cmd.cd("..")
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
