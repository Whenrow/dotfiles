local dap, dapui = require("dap"), require("dapui")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
dapui.setup()
dap.adapters.python = function(cb, config)
    if config.request == 'attach' then
        local port = (config.connect or config).port
        local host = (config.connect or config).host or '127.0.0.1'
        local db = config.database or 'test'
        local test = config.test or '.test_rr_with_dependance_between_bom'
        local path = '--addons-path=addons,../enterprise'
        cb({
            type = 'server',
            port = assert(port, '`connect.port` is required for a python `attach` configuration'),
            host = host,
            options = {
                source_filetype = 'python',
            },
            executable= {
                command = os.getenv('HOME') .. '/.pyenv/shims/python',
                args = {'-m', 'debugpy', '--listen', port, 'odoo-bin', path, '-d', db, '--test-tags', test},
                cwd = os.getenv('HOME') .. '/src/odoo',
            },
        })
    end
end

dap.configurations.python = {
    {
        type = 'python';
        request = 'attach';
        port = 5678,
        name = "Launch Test";
        program = "${file}";
        database = function()
            return coroutine.create(function(coro)
            local opts = {}
            pickers.new(opts, {
                prompt_title = "Path to executable",
                finder = finders.new_oneshot_job({"echo", "test\nvalo"}, {}),
                sorter = conf.generic_sorter(opts),
                attach_mappings = function(buffer_number)
                    actions.select_default:replace(function()
                        actions.close(buffer_number)
                        coroutine.resume(coro, action_state.get_selected_entry()[1])
                    end)
                    return true
                end,
            }):find()
        end)
        end,
        test = function()
            return false
        end;
    }, {
        type = 'python';
        request = 'attach';
        program = "${file}";
        pythonPath = function()
            return os.getenv('HOME') .. '/.pyenv/shims/python';
        end;
        name = "Attach to process",
        pid = function() require("dap.utils").pick_process({ filter = "odoo" })end,
        port = 5678,

        args = {},
    },
}
dapui.setup({
    controls = {
        element = "repl",
        enabled = true,
        icons = {
            disconnect = "",
            pause = "",
            play = "",
            run_last = "",
            step_back = "",
            step_into = "",
            step_out = "",
            step_over = "",
            terminate = ""
        }
    },
    element_mappings = {},
    expand_lines = true,
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
    layouts = {
        {
            elements = {
                { id = "scopes", size = 0.25 },
                { id = "breakpoints", size = 0.25 },
                { id = "stacks", size = 0.25 },
                { id = "watches", size = 0.25 },
            },
            position = "left",
            size = 70,
        },
    },
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
vim.keymap.set('n', '<F3>', function() require('dap').continue() end)
vim.keymap.set('n', '<F4>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F5>', function()
    -- Get the word under the cursor
    local word = vim.fn.expand("<cword>")

    if word == "" then
        require('dap').step_into()
        return
    end
    local cmd = "lua require'dap'.step_into(" .. word .. ")"
    local success = pcall(cmd)

    if not success then
        require('dap').step_into()
    end
end)
vim.keymap.set('n', '<F6>', function() require('dap').step_out() end)
vim.keymap.set('n', '<F10>', function() require('dap').disconnect({terminateDebuggee=false}) end)
vim.keymap.set('n', '<Leader>db', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>dB', function() require('dap').set_breakpoint(vim.fn.input("Breakpoint condition :")) end)
vim.keymap.set('n', '<Leader>deb', function() require('dap').set_exception_breakpoints() end)
vim.keymap.set('n', '<Leader>dlp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set("n", "<Leader>sw", function() require('dapui').elements.watches.add(vim.fn.expand "<cword>") end)
vim.keymap.set("n", "<Leader>dw", function() require('dapui').float_element('watches', { enter = true }) end)
vim.keymap.set("n", "<Leader>ds", function() require('dapui').float_element('scopes', { enter = true }) end)
vim.keymap.set("n", "<Leader>dr", function() require('dapui').float_element('repl', { enter = true }) end)

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
