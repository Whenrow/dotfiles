local lsp_config = require('lspconfig.configs')
local odooConfig = {
    id = 1,
    name = "config 1",
    addons = {"/home/whe/src/odoo/addons", "/home/whe/src/enterprise"},
    odooPath = "/home/whe/src/odoo/",
    pythonPath = "/home/whe/.pyenv/shims/python3",
}
lsp_config.odools = {
    default_config = {
        name = 'odools',
        cmd = vim.lsp.rpc.connect('127.0.0.1', 2087),
        -- cmd = {'/home/whe/src/odools/odoo_ls_server'},
        root_dir = "/home/whe/src/odoo/",
        handlers = {
            ['Odoo/getPythonPath'] = function()
                return {pythonPath = "/home/whe/.pyenv/shims/python3"}
            end,
        },
        settings = {
            Odoo = {
                autoRefresh = true,
                autoRefreshDelay = nil,
                diagMissingImportLevel = "none",
                configurations = { mainConfig = odooConfig },
                selectedConfiguration = "mainConfig",
            },
        },
        capabilities = {
            textDocument = {
                workspace = {
                    symbol = {
                        dynamicRegistration = true,
                    },
                },
            },
        },
    },
}
lsp_config.odools.setup{}
