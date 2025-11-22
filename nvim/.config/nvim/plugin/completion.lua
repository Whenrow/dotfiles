local blink = require("blink.cmp")

blink.setup({
    enabled = function()
        return vim.bo.buftype ~= "prompt"
            or vim.tbl_contains({
                "lua",
                "markdown",
                "python",
                "javascript",
                "xml",
                "dap-repl",
            }, vim.bo.filetype)
            or require("cmp_dap").is_dap_buffer()
    end,
    cmdline = { enabled = false },
    sources = {
        default = { "lsp", "path", "buffer", "snippets", "dap" },
        per_filetype = {
            ["dap-repl"] = { "dap" },
        },
        providers = {
            dap = {
                name = "dap",
                module = "blink.compat.source",
                -- Only enable this source when it is actually available
                enabled = function() return vim.bo.filetype == "dap-repl" end,
            },
        },
    },
    keymap = {
        preset = 'enter',
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'fallback' },
    },
    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
        },
        list = {
            selection = {
                preselect = false,
            },
        },
    },
})
