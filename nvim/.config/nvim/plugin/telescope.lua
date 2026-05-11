local utils = require('whenrow.utils')
local status_ok, fzf = pcall(require, "fzf-lua")
if not status_ok then
  return
end

local previewers = require "fzf-lua.previewer"

vim.keymap.set("n", "<C-b>", fzf.buffers)
vim.keymap.set("n", "<C-p>", fzf.files)
vim.keymap.set("n", "<leader>t", fzf.tags)
vim.keymap.set("n", "<leader>r", fzf.treesitter)
vim.keymap.set("n", "<leader>T", vim.cmd.FzfLua)
vim.keymap.set("n", "<leader><BS>", fzf.resume)
vim.keymap.set({"n", "v"}, "<leader>gf", fzf.grep_cword)
vim.keymap.set("n", "<leader>/", function()
    fzf.grep({input_prompt = "Grep : "})
end)
vim.keymap.set("n", "<leader>?", function()
    fzf.grep({input_prompt = "eGrep : ", no_esc=true, rg_opts="--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -U"})
end)
-- open .config/ folder in Telescope
vim.keymap.set("n", "<leader>cc", function()
    fzf.files({cwd='~/.config/',follow=true,hidden=true})
end)
vim.keymap.set("n", "<leader>cl", function()
    fzf.files({cwd='~/.local/',follow=true,hidden=true})
end)
-- Edit nvim config
vim.keymap.set("n", "<leader>ce", function()
    fzf.files({cwd='~/.config/nvim/',hidden=true})
end)
-- Command history
vim.keymap.set("n", "<leader>R", fzf.command_history)
-- Remap spell suggestion to the Telescope one
vim.keymap.set("n", "z=", fzf.spell_suggest)
vim.keymap.set('n', '<leader>vh', fzf.helptags)
-- LSP overrides
vim.keymap.set('n', 'gd', fzf.lsp_definitions)
-- Git overrides
vim.keymap.set('n', '<leader>go', function()
    print(utils.get_file_repo())
    fzf.git_branches({cmd = 'git branch', cwd=utils.get_file_repo(), preview=false})
end)

local function fzf_tjump(query, exact)
    local tags = {}
    vim.bo.tagfunc = ""

    if exact then
        tags = vim.fn.taglist("^" .. query .. "$")
    else
        tags = vim.fn.taglist(query)
    end

    if #tags == 0 then
        print("No tags found for query: " .. query)
        return
    elseif #tags == 1 then
        vim.cmd.tjump(tags[1].name)
        return
    end

    -- Format tags and build a lookup map to retrieve tag data upon selection
    local entries = {}
    local tag_lookup = {}

    for _, tag in ipairs(tags) do
        local class_str = tag.class and tag.class or ""
        -- Adding the index (i) ensures duplicate names/files don't overwrite the lookup table
        local display = string.format("%-30s\t%s\t%s", class_str, tag.filename, tag.cmd)

        table.insert(entries, display)
        tag_lookup[display] = {
            filename = tag.filename,
            scode = tag.cmd:gsub("^/", ""):gsub("/$", "") -- remove start and end slashes
        }
    end

    -- Use fzf-lua to show the tags
    fzf.fzf_exec(entries, {
        prompt = query .. " > ",
        previewer = previewers.builtin.tags,
        winopts = {
            height = 0.90,
            width = 0.80,
            row = 0.50,
            col = 0.50,
        },
        fzf_opts = {
            ["--layout"] = "reverse", -- Matches Telescope's prompt_position = 'bottom' behavior visually
        },
        actions = {
            ["default"] = function(selected)
                if not selected or #selected == 0 then
                    return
                end

                local selection_str = selected[1]
                local tag_data = tag_lookup[selection_str]

                if not tag_data then return end

                -- Open the file
                vim.cmd("edit " .. vim.fn.fnameescape(tag_data.filename))

                -- Execute the search code to jump to the right line/definition
                if tag_data.scode then
                    -- Un-escape / then escape required special chars for vim.fn.search()
                    local scode = tag_data.scode:gsub([[\/]], "/"):gsub("[%]~*]", function(x)
                        return "\\" .. x
                    end)

                    vim.cmd("keepjumps norm! gg")
                    vim.fn.search(scode)
                    vim.cmd("norm! zz")
                end
            end
        }
    })
end

-- exact match or partial match
-- user_id
fzf = require("fzf-lua")
vim.keymap.set('n', "<C-]>", function()
    fzf.tags_grep_cword({
        fzf_opts = {
            ["--tiebreak"] = "begin",
            ["--with-nth"] = "1,2",
            ["--exact"] = true,
        }
    }
)
end)
vim.cmd.FzfLua("register_ui_select")
-- vim.keymap.set('n', "g<C-]>", function() fzf_tjump(vim.fn.expand('<cword>')) end)
-- vim.keymap.set('n', "<C-]>", function() fzf_tjump(vim.fn.expand('<cword>'), true) end)
-- vim.keymap.set('n', "g<C-]>", function() fzf_tjump(vim.fn.expand('<cword>')) end)
