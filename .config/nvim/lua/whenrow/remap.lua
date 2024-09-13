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
-- Tab navigation
vim.keymap.set("n", "]t", ":tabNext<CR>", {silent = true})
vim.keymap.set("n", "[t", ":tabprevious<CR>", {silent = true})
-- split line at cursor
-- vim.keymap.set("n", "K", "i<CR><esc>")
-- Center next highlighted word
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
-- open zshrc
vim.keymap.set("n", "<leader>cz", function() vim.cmd.edit("~/.zshrc") end)
-- Python debugging made easy
vim.cmd.iabbrev("pudb", "import pudb;pudb.set_trace()")
-- Set current file's directory the working one
vim.keymap.set("n", "<leader>sd", function() vim.cmd.cd("%:p:h") end)
-- Copy current file path to clipboard
vim.keymap.set("n", "<leader>cp", function() vim.cmd.let("@+ = expand('%:p')") end)
-- Open stack trace line
vim.keymap.set("n", "<leader>s", function ()
    local stack_line = vim.api.nvim_get_current_line()
    local file, line = string.match(stack_line, 'File "([%w./-_]+)", line (%d+), in')
    if file and line then
        vim.api.nvim_command("e +" .. line .. " " .. file)
    end
end)
-- source current file
vim.keymap.set("n", "<F5>", vim.cmd.source)
