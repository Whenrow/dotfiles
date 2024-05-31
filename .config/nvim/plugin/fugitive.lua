--open Tig blame
vim.keymap.set("n", "<leader>b", function() vim.cmd.Git("blame") end)
--open git log
vim.keymap.set("n", "<leader>gl", function() vim.cmd.Gclog("-n 25 %") end)
--close buffer
vim.keymap.set("n", "<leader><leader>", ":Gtabe:<CR>")

local whenrow_Fugitive = vim.api.nvim_create_augroup("whenrow_Fugitive", {})

local autocmd = vim.api.nvim_create_autocmd
autocmd("BufWinEnter", {
    group = whenrow_Fugitive,
    pattern = "*",
    callback = function()
        if vim.bo.ft ~= "fugitive" then
            return
        end

        local bufnr = vim.api.nvim_get_current_buf()
        local opts = {buffer = bufnr, remap = false}
        vim.keymap.set("n", "<leader>go", function()
            vim.cmd.Git('commit -c ORIG_HEAD')
        end, opts)
    end,
})

