require('whenrow.lualine')
require('whenrow.packer')
require('whenrow.remap')
require('whenrow.set')
require('whenrow.telescope')

local autocmd = vim.api.nvim_create_autocmd
autocmd({"BufWritePre"}, {
    pattern = "*",
    command = [[%s/\s\+$//e]],
})


-- If vim is opened inside /src/ dir, move up to take all dire into account
-- (for tags and fuzzy finder)
if vim.fn['expand']('%:p:h:h') == '/home/whe/src' then
    vim.cmd.cd("..")
end

vim.cmd([[au BufNewFile,BufRead *.v set filetype=vlang]])
