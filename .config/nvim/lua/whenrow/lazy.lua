require("lazy").setup({
    -- UI
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    { 'nvim-treesitter/nvim-treesitter-context' },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    { 'nvim-treesitter/nvim-treesitter-refactor' },
    { 'emmanueltouzery/decisive.nvim' },
    {
        'nvim-telescope/telescope.nvim',
        event = 'VimEnter',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',

                -- `build` is used to run some command when the plugin is installed/updated.
                -- This is only run then, not every time Neovim starts up.
                build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',

                -- `cond` is a condition used to determine whether this plugin should be
                -- installed and loaded.
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
            { 'nvim-telescope/telescope-ui-select.nvim' },
        },
    },
    'mbbill/undotree',
    'onsails/lspkind.nvim',
    'nvim-lualine/lualine.nvim',
    {'sainnhe/everforest',
        priority = 1000, -- Colorscheme plugin is loaded first before any other plugins
        opts = { }
    },
    {'brenoprata10/nvim-highlight-colors'},
    { 'stevearc/oil.nvim'},

    -- lsp stuff
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    },
    {"zbirenbaum/copilot.lua"},
    {"supermaven-inc/supermaven-nvim"},
    {
        "odoo/odoo-ls",
        dir = "~/src/ols_wip",
        config = function(plugin)
            vim.opt.rtp:append(plugin.dir .. "/nvim")
            require("lazy.core.loader").packadd(plugin.dir .. "/nvim")
        end,
        init = function(plugin)
            require("lazy.core.loader").ftdetect(plugin.dir .. "/nvim")
        end,
    },

    -- {'whenrow/odoo-ls.nvim', dev = true, dir="~/Programming/odoo-ls.nvim"},
    -- {'whenrow/odoo-ls.nvim'},

    -- Git
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',

    -- Misc
    'tpope/vim-surround',
    { 'JellyApple102/flote.nvim', config = function() require('flote').setup() end },
    { 'rmagatti/auto-session'},

    -- Debugging
    { "rcarriga/nvim-dap-ui", dependencies = { {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
        "rcarriga/cmp-dap",
        "jbyuki/one-small-step-for-vimkind",
    } } },
    {
        "kristijanhusak/vim-dadbod-completion", dependencies = {
            "tpope/vim-dadbod",
            "kristijanhusak/vim-dadbod-ui",
        },
    },
    -- Bullshit
    'eandrju/cellular-automaton.nvim',
    'lewis6991/gitsigns.nvim',
})
