local openOdoo = function()
    vim.cmd.tabnew()
    vim.cmd.terminal("pwd")
    -- print("coucou odoo")
end
vim.api.nvim_create_user_command('Odoo', openOdoo, {})
-- vim.keymap.set("n", "<leader>o", vim.cmd.Odoo)

