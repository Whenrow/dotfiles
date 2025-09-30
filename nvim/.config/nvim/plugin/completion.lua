blink = require("blink.cmp")

blink.setup({
    enabled = function() return vim.tbl_contains({
        "lua",
        "markdown",
        "python",
        "javascript",
        "xml",
    }, vim.bo.filetype) end,
    cmdline = { enabled = false },
    sources = {
        default = { "lsp", "path", "buffer", "snippets" },

    },
    keymap = {
        preset = 'enter',
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'fallback' },
    },
    completion = {
        list = {
            selection = {
                preselect = false,
            },
        },
    },
})
