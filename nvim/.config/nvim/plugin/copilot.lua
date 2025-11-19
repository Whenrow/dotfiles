vim.keymap.set('i', '<C-y>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})
vim.g.copilot_no_tab_map = true
-- require("copilot").setup({
    -- panel = {
    --     enabled = true,
    -- },
    -- suggestion = {
    --     auto_trigger = true,
    --     keymap = {
    --         accept = "<C-y>",
    --         accept_word = false,
    --         accept_line = false,
    --     },
    -- },
    -- fyletypes = {
    --     gitcommit = true,
    -- },
-- })
-- require("supermaven-nvim").setup({
--   keymaps = {
--     accept_suggestion = "<C-y>",
--     clear_suggestion = "<C-]>",
--     accept_word = "<C-j>",
--   },
--   ignore_filetypes = { cpp = true }, -- or { "cpp", }
--   color = {
--     suggestion_color = "#808080",
--     cterm = 244,
--   },
--   log_level = "info", -- set to "off" to disable logging completely
--   disable_inline_completion = false, -- disables inline completion for use with cmp
--   disable_keymaps = false, -- disables built in keymaps for more manual control
--   condition = function()
--     return false
--   end -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
-- })
