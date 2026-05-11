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
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("DisableLspOnFugitive", { clear = true }),
  desc = "Detach LSP from fugitive buffers",
  callback = function(args)
    local bufnr = args.buf
    local client_id = args.data.client_id
    local bufname = vim.api.nvim_buf_get_name(bufnr)

    -- Check if the buffer name starts with the fugitive URI scheme
    if vim.startswith(bufname, "fugitive://") then
      vim.lsp.buf_detach_client(bufnr, client_id)
    end
  end,
})

