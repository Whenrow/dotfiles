require("lazy").setup({
    -- UI
    { 'nvim-treesitter/nvim-treesitter', branch='main', build = ':TSUpdate' },
    { 'nvim-treesitter/nvim-treesitter-context', branch='master'},
    { 'nvim-treesitter/nvim-treesitter-locals'},
    { 'nvim-treesitter/nvim-treesitter-textobjects', branch='main'},
    { 'emmanueltouzery/decisive.nvim' },
    {
      "ibhagwan/fzf-lua",
      -- optional for icon support
      dependencies = { "nvim-tree/nvim-web-devicons" },
      -- or if using mini.icons/mini.nvim
      -- dependencies = { "nvim-mini/mini.icons" },
      opts = {}
    },
    'mbbill/undotree',
    'nvim-lualine/lualine.nvim',

    -- Themes
    'rebelot/kanagawa.nvim',
    {'sainnhe/everforest',
        priority = 1000, -- Colorscheme plugin is loaded first before any other plugins
        opts = { }
    },
    {'brenoprata10/nvim-highlight-colors'},
    { 'stevearc/oil.nvim'},
    {
        'saghen/blink.cmp',
        version='1.*',
        -- optional: provides snippets for the snippet source
        dependencies = {
            {'rafamadriz/friendly-snippets'},
            {'rcarriga/cmp-dap'},
            {'saghen/blink.compat'},
        },
    },
    {"github/copilot.vim"},

    -- Git
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',
    'lewis6991/gitsigns.nvim',
    {'pwntester/octo.nvim', dependencies = {
        'nvim-lua/plenary.nvim',
    } },

    -- Misc
    'tpope/vim-surround',
    { 'JellyApple102/flote.nvim', config = function() require('flote').setup() end },
    { 'rmagatti/auto-session'},
    {'ThePrimeagen/refactoring.nvim',
        dependencies = {
            "lewis6991/async.nvim",
      },
    },

    -- Debugging
    { "rcarriga/nvim-dap-ui", dependencies = { {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
        "jbyuki/one-small-step-for-vimkind",
    } } },
    "igorlfs/nvim-dap-view",
    {'mfussenegger/nvim-dap-python'},
    {
        "kristijanhusak/vim-dadbod-completion", dependencies = {
            "tpope/vim-dadbod",
            "kristijanhusak/vim-dadbod-ui",
        },
    },
    -- Bullshit
    'eandrju/cellular-automaton.nvim',
})
