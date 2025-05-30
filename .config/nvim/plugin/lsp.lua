local lsp = require("lsp-zero")

lsp.preset({
    name = "recommended",
    manage_nvim_cmp = {
        set_basic_mappings = false,
    },
    set_lsp_keymaps = "preserve_mappings",
})

-- Fix Undefined global 'vim'
lsp.nvim_workspace()


--- HACK: Override `vim.lsp.util.stylize_markdown` to use Treesitter.
---@param bufnr integer
---@param contents string[]
---@param opts table
---@return string[]
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.util.stylize_markdown = function(bufnr, contents, opts)
    contents = vim.lsp.util._normalize_markdown(contents, {
        width = vim.lsp.util._make_floating_popup_size(contents, opts),
    })
    vim.bo[bufnr].filetype = 'markdown'
    vim.treesitter.start(bufnr)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)

    return contents
end

local cmp = require('cmp')

cmp.setup({
    sources = {
        {name = 'nvim_lsp'},
        {name = 'buffer'},
        {name = 'luasnip'}, -- For luasnip users.
    },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    enabled = function()
        return vim.api.nvim_get_option_value("buftype", {}) ~= "prompt"
            or require("cmp_dap").is_dap_buffer()
    end,
})
cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
  sources = {
    { name = "dap" },
  },
})

local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
  ['<CR>'] = cmp.mapping.confirm({ select = true }),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<Tab>'] = cmp.mapping.abort(),
  ['<S-Tab>'] = vim.NIL,
  ['<C-Y>'] = vim.NIL,
  ['<C-y>'] = vim.NIL,
})

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}
  lsp.default_keymaps({
      buffer = bufnr,
      exclude = {'<F2>', '<F3>', '<F4>'},
  })
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
end)

-- lsp.setup()

vim.diagnostic.config({
    virtual_text = true,
    float = {
        source = 'always',
    },
})
