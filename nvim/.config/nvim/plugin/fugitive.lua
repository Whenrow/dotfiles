--open git log
vim.keymap.set("n", "<leader><leader>", ":Gtabe:<CR>")
vim.keymap.set("n", "<leader>gl", function()
    if vim.bo.ft ~= "fugitive" then
        vim.cmd.Gclog("-n 25 %")
    else
        vim.cmd.Git("log --oneline -n 100")
    end
end)
vim.keymap.set("n", "<leader>b", function() vim.cmd.Git("blame") end)


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
            vim.cmd.Git('commit -C ORIG_HEAD')
        end, opts)
    end,
})

