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


local cmp = require('cmp')
cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
    {name = 'buffer'},
  },
})
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
  ['<CR>'] = cmp.mapping.confirm({ select = true }),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<Tab>'] = vim.NIL,
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
  -- vim.keymap.set("n", "<leader>gd", function() vim.lsp.buf.definition() end, opts)
  -- vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  -- vim.keymap.set("n", "<leader>e", function() vim.diagnostic.open_float() end, opts)
  -- vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  -- vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  -- vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  -- vim.keymap.set("n", "<leader>ih", function() vim.lsp.buf.inlay_hint(0) end, opts)
  -- vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})

require'lspconfig'.pylsp.setup{
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    enabled = false
                },
                pyflakes = {
                    enabled = false
                }
            }
        }
    }
}
