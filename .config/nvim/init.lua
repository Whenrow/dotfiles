local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("whenrow")
local start_odoo_ls = function()
    local client_id = vim.lsp.get_clients({name='odools'})
    local odooConfig = {
        addons = {},
        odooPath = "/home/whe/src/odoo",
    }
    local client
    P(client_id)
    if next(client_id) == nil then
        print('liste vide')
        client = vim.lsp.start({
            name = 'odools',
            cmd = vim.lsp.rpc.connect('127.0.0.1', 2087),
            -- cmd = {'/home/whe/src/odools/odoo_ls_server'},
            root_dir = "/home/whe/src/",
            -- root_dir = function () return "/home/whe/src/" end,
            -- root_dir = vim.fs.dirname(vim.fs.find({'pyproject.toml', 'setup.py'}, { upward = true })[1]),
            handlers = {
                -- ['Odoo/loadingStatusUpdate'] = function(status)
                --     print(status)
                -- end,
                ['Odoo/getPythonPath'] = function()
                    return {pythonPath = "/home/whe/.pyenv/shims/python3"}
                end,
                -- ['Odoo/displayCrashNotification'] = function(content)
                --     print(vim.inspect(content["crashInfo"]))
                -- end,
            },
            settings = {
                Odoo = {
                    autoRefresh = true,
                    autoRefreshDelay = nil,
                    diagMissingImportLevel = "None",
                    configurations = { mainConfig = odooConfig },
                    selectedConfiguration = "mainConfig",
                },
            },
        })
    else
        client = client_id[1].id
        vim.lsp.buf_detach_client(0, client)
    end
    print(client)
    vim.lsp.buf_attach_client(0, client)
end
-- create commande
vim.api.nvim_create_user_command('Odools', start_odoo_ls, {})
vim.keymap.set("n", "<leader>o", vim.cmd.Odools)
