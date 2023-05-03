local builtin = require("telescope.builtin")

vim.keymap.set("n", "<C-b>", builtin.buffers)
vim.keymap.set("n", "<C-p>", builtin.find_files)
-- vim.keymap.set("n", "<C-p>", function()
-- 	if system("git status") then
-- 		return builtin.git_files
-- 	else
-- 		return builtin.find_file
-- 	end
-- end)
vim.keymap.set("n", "<leader>t", builtin.tags)
vim.keymap.set("n", "<leader>r", builtin.current_buffer_tags)
vim.keymap.set("n", "<leader>T", vim.cmd.Telescope)
vim.keymap.set("n", "<leader>gf", builtin.grep_string)
vim.keymap.set("n", "<leader>/", function()
    builtin.grep_string({search = vim.fn.input("Grep : "), use_regex=true})
end)
-- open .config/ folder in Telescope
vim.keymap.set("n", "<leader>cc", function()
    builtin.find_files({search_dirs={'~/.config/'},hidden=true})
end)
-- All lines of open files (great to find debuggers to be removed)
vim.keymap.set("n", "<leader>l", function()
    builtin.live_grep({grep_open_files = true})
end)
-- Remap spell suggestion to the Telescope one
vim.keymap.set("n", "z=", function()
    builtin.spell_suggest()
end)
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
