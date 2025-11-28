local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end
local status_ok, fzf = pcall(require, "fzf-lua")
if not status_ok then
  return
end

local actions = require "telescope.actions"
local sorters = require "telescope.sorters"
local previewers = require "telescope.previewers"
local action_set = require "telescope.actions.set"
local action_state = require "telescope.actions.state"
local entry_display = require "telescope.pickers.entry_display"

telescope.setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  },
  defaults = {
      sorting_strategy = 'ascending',
      prompt_title = false,
      layout_config = {
          prompt_position = 'top',
          height = 0.5,
      },
      prompt_prefix = " ",
      mappings = {
          i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<Esc>"] = actions.close,
          },
          n = {
              ["<Esc>"] = actions.close,
          }
      },
      vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--multiline",
        },
  },
  pickers = {
      find_files = {
          find_command = {'rg', '--files', '--smart-case', '-g', '!*.po', '-g', '!*.pot'},
          -- previewer = false,
      },
      live_grep = {
          glob_pattern = {'!*.po', '!*.pot', '!tags', '!sysadmin_dns_training', '!*.json'},
          layout_strategy = 'vertical',
          layout_config = {height = 0.9, mirror = true, prompt_position = 'top'},
      },
      grep_string = {
        additional_args = {'-g', '!*.po', '-g', '!tags', '-g', '!*.json', '-g', '!odools'},
          layout_strategy = 'vertical',
          layout_config = {height = 0.9, mirror = true, prompt_position = 'top'},
      },
      buffers = {
          layout_strategy = 'vertical',
          layout_config = {height = 0.9, mirror = true, prompt_position = 'top'},
          sort_mru = true,
      },
      tags = {
          layout_strategy = 'vertical',
          layout_config = {height = 0.9, mirror = true, prompt_position = 'bottom'},
          show_kind = false,
          fname_width = 70,
      },
      git_commits = {
          use_file_path = true,
      },
      git_bcommits = {
          use_file_path = true,
      },
      git_status = {
          use_file_path = true,
      },
      git_branches = {
          use_file_path = true,
      },
      git_bcommits_range = {
          use_file_path = true,
      },
      lsp_document_symbols = {
          ignore_symbols = {'File', 'Module', 'Namespace', 'Variable', 'Package'},
          show_line = true,
      },
      planets = {
          previewer = require('telescope.config').values.cat_previewer
      },
  }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
-- telescope.load_extension('fzf')
telescope.load_extension('ui-select')

local builtin = require("telescope.builtin")

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
    builtin.grep_cword({search = vim.fn.input("eGrep : "), use_regex=true})
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

-- Jump to tag or list in telescope if multiple possibilities
local function telescope_tjump(query, exact)
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

    -- Format tags into the expected format for Telescope
    local entries = {}
    for _, tag in ipairs(tags) do
        table.insert(entries, {
            display = tag.filename .. ": " .. (tag.class or "") .. ": " .. tag.name,
            tag = tag.name,
            class = tag.class,
            filename = tag.filename,
            scode = tag.cmd:gsub("^/", ""):gsub("/$", "") -- remove start and end slashes
        })
    end

    -- Use Telescope to show the tags
    require('telescope.pickers').new({}, {
        prompt_title = "choose Tags",
        finder = require('telescope.finders').new_table {
            results = entries,
            entry_maker = function(entry)
                local display_items = {
                    {width = 70},
                    {remaining = true},
                }
                local displayer = entry_display.create {
                    separator = " │ ",
                    items = display_items,
                }
                local make_display = function(lentry)
                    return displayer {
                        lentry.filename,
                        lentry.class,
                    }
                end
                return {
                    ordinal = entry.display,
                    display = make_display,
                    scode = entry.scode,
                    tag = entry.tag,
                    filename = entry.filename,
                    class = entry.class,
                    col = 1,
                    lnum = 1,
                }
            end,
        },
        sorter = sorters.get_fuzzy_file(),
        layout_strategy = 'vertical',
        layout_config = {height = 0.9, mirror = true, prompt_position = 'bottom'},
        previewer = previewers.ctags.new({}),
        attach_mappings = function()
            action_set.select:enhance {
              post = function()
                local selection = action_state.get_selected_entry()
                if not selection then
                  return
                end

                if selection.scode then
                  -- un-escape / then escape required
                  -- special chars for vim.fn.search()
                  -- ] ~ *
                  local scode = selection.scode:gsub([[\/]], "/"):gsub("[%]~*]", function(x)
                    return "\\" .. x
                  end)

                  vim.cmd "keepjumps norm! gg"
                  vim.fn.search(scode)
                  vim.cmd "norm! zz"
                end
              end,
            }
            return true
      end,
    }):find()
end

-- exact match or partial match
vim.keymap.set('n', "<C-]>", function() telescope_tjump(vim.fn.expand('<cword>'), true) end)
vim.keymap.set('n', "g<C-]>", function() telescope_tjump(vim.fn.expand('<cword>')) end)

