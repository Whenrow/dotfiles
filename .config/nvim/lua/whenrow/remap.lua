vim.g.mapleader = " "
--close buffer
vim.keymap.set("n", "<leader>w", vim.cmd.bd)
--clear previous search highlight
vim.keymap.set("n", "<C-l>", vim.cmd.noh)
--save file
vim.keymap.set("", "<Esc><Esc>", vim.cmd.w)
-- Quickfix list
vim.keymap.set("n", "]c", ":cnext<CR>zz", {silent = true})
vim.keymap.set("n", "[c", ":cprevious<CR>zz", {silent = true})
-- split line at cursor
vim.keymap.set("n", "K", ":i<CR><esc>")
-- Center next highlighted word
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "-", vim.cmd.Vex, {silent = true})
-- Edit nvim config
vim.keymap.set("n", "<leader>ce", function() vim.cmd.Vexplore("~/.config/nvim/lua/whenrow") end)
-- Edit lua config
vim.keymap.set("n", "<leader>cl", function() vim.cmd.edit("~/.config/nvim/lua/whenrow/init.lua") end)
-- open zshrc
vim.keymap.set("n", "<leader>cz", function() vim.cmd.edit("~/.zshrc") end)
-- Python debugging made easy
vim.cmd.iabbrev("pudb", "import pudb;pudb.set_trace()")
-- Set current file's directory the working one
vim.keymap.set("n", "<leader>sd", function() vim.cmd.cd("%:p:h") end)
-- Copy current file path to clipboard
vim.keymap.set("n", "<leader>cp", function() vim.cmd.let("@+ = expand('%:p')") end)





--""open .config/ folder in FZF
--"nmap <leader>cc :lua require'telescope.builtin'.find_files({search_dirs={'~/.config/'},hidden=true})<cr>
--""
--
--
--
--
-- -- Trailing whitespace at save
-- autocmd BufWritePre * %s/\s\+$//e




--""==================
--"" Tree view
--""==================
--"let g:netrw_banner = 0
--"let g:netrw_liststyle = 3
--"let g:netrw_browse_split = 4
--"let g:netrw_altv = 1
--"let g:netrw_winsize = 20
--"let g:netrw_list_hide= '.*\.pyc$,_pycache__'

--""==================
--"" Greper
--""===================
--"nnoremap <Leader>/ :Telescope live_grep<CR>
--"nnoremap <Leader>gf :Telescope grep_string<CR>

--""==================
--"" Snippets
--""===================
--""" Use <C-l> for trigger snippet expand.
--"" imap <silent> <C-l> <Plug>(coc-snippets-expand)

