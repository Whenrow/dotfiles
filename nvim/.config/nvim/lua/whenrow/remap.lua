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
    local target_win_id = nil
    for _, win_id in ipairs(vim.api.nvim_list_wins()) do
        local buf_id = vim.api.nvim_win_get_buf(win_id)
        local ft = vim.api.nvim_buf_get_option(buf_id, 'filetype')
        local buftype = vim.api.nvim_buf_get_option(buf_id, 'buftype')

        if buftype == '' and ft == 'python' then
          target_win_id = win_id
          break
        end
    end

    local new_buf_id = vim.fn.bufadd(file)
    -- 2. Load the buffer's content into memory (if it's not already)
    vim.fn.bufload(new_buf_id)

    -- 3. Set the target window to display our new buffer
    vim.api.nvim_win_set_buf(target_win_id, new_buf_id)
    if vim.api.nvim_get_current_win() ~= target_win_id then
        vim.api.nvim_win_close(0, false)
    end
    if line then
        local pos = {tonumber(line), 0}
        vim.api.nvim_win_set_cursor(target_win_id, pos)
    end
end)
-- Search and replace current word
vim.keymap.set("n", "grp", function()
    local old_name = vim.fn.expand("<cword>")
    local new_name = vim.fn.input("New name: ", old_name)
    vim.cmd(":%s/" .. old_name .. "/".. new_name .. "/g")
end)
-- source current file
vim.keymap.set("n", "<F5>", vim.cmd.source)
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv")
-- Actions to system clipboard
vim.keymap.set({"n","v"}, "<leader>y", [["+y]])
vim.keymap.set({"n","v"}, "<leader>d", [["+d]])
