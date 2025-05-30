local odools = require('odools')
local h = os.getenv('HOME')
odools.setup({
    odoo_path = h .. "/src/odoo",
    python_path = h .. "/.pyenv/shims/python3",
    addons = {h .. "/src/enterprise"},
    -- addons = {},
    -- server_path = h .. "/src/odools/odoo_ls_server",
    -- additional_stubs = {h .. "/src/odools/additional_stubs/", h .. "/src/odools/typeshed/stubs"},
    root_dir = h .. "/src/",
})
