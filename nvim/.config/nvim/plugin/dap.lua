local dap, dapui = require("dap"), require("dapui")
local wutils = require("whenrow.utils")
dapui.setup()
dap.set_log_level('TRACE')

-- Optional: Set a specific path for the log file
-- By default, it's often in stdpath('cache')/dap.log
dap.adapters.python = function(cb, config)
    local command = os.getenv('HOME') .. '/.pyenv/shims/python'
    local path = config.path or '--addons-path=addons,../enterprise'
    local cwd = os.getenv('HOME') .. '/src/odoo'
    local port = (config.connect or config).port or 5678
    local host = (config.connect or config).host or '127.0.0.1'
    local default_args = {'-m', 'debugpy', '--listen', port, 'odoo-bin', path, '-d', 'test'}
    if config.request == 'attach' then
        cb({
            type = 'server',
            port = assert(port, '`connect.port` is required for a python `attach` configuration'),
            host = host,
            options = {
                source_filetype = 'python',
            },
            executable= {
                command = command,
                args = default_args,
                cwd = cwd,
            },
        })
    end
    if config.request == 'launch' then
        local args = {'-m', 'debugpy.adapter'}
        cb({
            type = 'executable',
            options = {
                source_filetype = 'python',
                cwd = config.cwd or os.getenv('HOME') .. '/src/odoo',
            },
            command = command,
            args = args,
            enrich_config = function(old_config, on_config)
                local test
                local class
                vim.cmd("normal! mT")
                local final_config = vim.deepcopy(old_config)
                local db = vim.b.gitsigns_head
                local additional_args = {path, '--dev=xml', '-d', db}
                if old_config.current_test then
                    test = wutils.get_current_parent_name("function_definition")
                    if test then
                        -- update module
                        local file_path = vim.fn.expand('%:p')
                        local module = ''
                        if file_path:find('odoo/addons/') then
                            module = vim.split(file_path, '/')[7]
                        else
                            module = vim.split(file_path, '/')[6]
                        end
                        table.insert(additional_args, '-u')
                        table.insert(additional_args, module)
                        table.insert(additional_args, '--test-tags')
                        table.insert(additional_args, '.' .. test)
                    end
                end
                if old_config.current_class then
                    class = wutils.get_current_parent_name("class_definition")
                    if class then
                        table.insert(additional_args, '--test-tags')
                        table.insert(additional_args, ':' .. class)
                    end
                end
                if old_config.install then
                    module = vim.fn.input("module(s) to install: ")
                    if module ~= '' then
                        table.insert(additional_args, '-i')
                        table.insert(additional_args, module)
                    end
                end
                final_config.args = additional_args
                on_config(final_config)
                vim.notify('args: ' .. vim.inspect(final_config.args))
            end;
        })
    end
end

local path = '--addons-path=addons,../enterprise'
local db = vim.b.gitsigns_head
local config = {
    {
        type = 'python',
        request = 'launch',
        program = os.getenv('HOME') .. '/src/odoo/odoo-bin',
        args = {path, '-d', db},
        name = "Odoo server",
        console = "integratedTerminal",
    }, {
        type = 'python',
        request = 'launch',
        program = os.getenv('HOME') .. '/src/odoo/odoo-bin',
        args = {path, '-d', db},
        current_test = true,
        name = "This test",
        console = "integratedTerminal",
    },  {
        type = 'python',
        request = 'launch',
        program = os.getenv('HOME') .. '/src/odoo/odoo-bin',
        args = {path, '-d', db},
        current_class = true,
        name = "This class",
        console = "integratedTerminal",
    },  {
        type = 'python',
        request = 'launch',
        program = os.getenv('HOME') .. '/src/odoo/odoo-bin',
        args = {path, '-d', db},
        install = true,
        name = "Odoo install + server",
        console = "integratedTerminal",
    }, {
        type = 'python',
        request = 'launch',
        program = os.getenv('HOME') .. '/src/odoo/odoo-bin',
        args = {path, '-d', db},
        name = "Odoo server (community only)",
        console = "integratedTerminal",
        path = '--addons-path=addons'
    }, {
        type = 'python',
        request = 'launch',
        program = os.getenv('HOME') .. '/src/odoo/odoo-bin',
        args = {path, '-d', db},
        current_test = true,
        name = "This test (community only",
        console = "integratedTerminal",
    },
}
dap.configurations.python = config
dap.configurations.javascript = config
dap.configurations.xml = config
dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = "Attach to running Neovim instance",
  }
}

dap.adapters.nlua = function(callback, config)
  callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
end
dapui.setup({
    element_mappings = {},
    expand_lines = false,
    floating = {
        border = "single",
        mappings = {
            close = { "q", "<Esc>" }
        }
    },
    force_buffers = true,
    icons = {
        collapsed = "",
        current_frame = "",
        expanded = ""
    },
    layouts = { {
        elements = { {
            id = "scopes",
            size = 0.25
          }, {
            id = "breakpoints",
            size = 0.15
          }, {
            id = "stacks",
            size = 0.35
          }, {
            id = "watches",
            size = 0.25
          } },
        position = "left",
        size = 40
      }, {
        elements = { {
            id = "console",
            size = 1
          } },
        position = "bottom",
        size = 12
      } },
    mappings = {
        edit = "e",
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        repl = "r",
        toggle = "t"
    },
    render = {
        indent = 1,
        max_value_lines = 100
    }
})
vim.keymap.set('n', '<F2>', function() dap.run_to_cursor() end)
vim.keymap.set('n', '<F3>', function()
    if dap.session() == nil then
        vim.cmd.w()
    end
    dap.continue()
end)
vim.keymap.set('n', '<F4>', function() dap.step_over() end)
vim.keymap.set('n', '<F5>', function() dap.step_into({askForTargets=true}) end)
vim.keymap.set('n', '<F6>', function() dap.step_out() end)
vim.keymap.set('n', '<F10>', function()
    dap.disconnect({terminateDebuggee=false})
    dapui.close()
end)
vim.keymap.set('n', '<Leader>db', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>dB', function() dap.set_breakpoint(vim.fn.input("Breakpoint condition :")) end)
vim.keymap.set('n', '<Leader>deb', function() dap.set_exception_breakpoints() end)
vim.keymap.set('n', '<Leader>dlp', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set("n", "<Leader>sw", function() dapui.elements.watches.add(vim.fn.expand "<cword>") end)
vim.keymap.set("n", "<Leader>dw", function() dapui.float_element('watches', { enter = true }) end)
vim.keymap.set("n", "<Leader>ds", function() dapui.float_element('scopes', { enter = true }) end)
vim.keymap.set("n", "<Leader>dr", function() dapui.float_element('repl', { width=120, height=40 }) end)
vim.keymap.set("n", "<Leader>dc", function() dapui.float_element('console', { width=200, height=80}) end)
vim.keymap.set("n", "<Leader>d?", function() dapui.eval(nil, { enter = true }) end)
vim.keymap.set("n", "<M-j>", function() dap.up() end)
vim.keymap.set("n", "<M-k>", function() dap.down() end)

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- require("cmp").setup({
--   enabled = function()
--     return vim.api.nvim_get_option_value(0, "buftype") ~= "prompt"
--         or require("cmp_dap").is_dap_buffer()
--   end
-- })
--
-- require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
--   sources = {
--     { name = "dap" },
--   },
-- })

vim.keymap.set('n', '<leader>dl', function()
  require"osv".launch({port = 8086})
end, { noremap = true })
