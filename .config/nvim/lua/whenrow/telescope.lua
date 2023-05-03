local os = require "os"
-- You dont need to set any of these options. These are the default ones. Only
-- the loading is important
local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

local actions = require "telescope.actions"

local function get_root_dir()
    if vim.fn.getcwd() == (os.getenv("HOME") .. "/src") then
        local root_dir = vim.fn.getcwd() .. vim.fn.finddir('.git', '.;')
        print(root_dir)
        return root_dir
    else
        return false
    end
end
local function use_root_dir()
    print("use_root_dir")
    if get_root_dir() then
        return false
    else
        return true
    end
end



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
      }
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
          additional_args = {'-g', '!*.po', '-g', '!tags', '-g', '!*.json'},
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
          fname_width = 100,
      },
      git_commits = {
          use_file_path = true,
      },
      git_bcommits = {
          use_file_path = true,
      },
  }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
telescope.load_extension('fzf')
