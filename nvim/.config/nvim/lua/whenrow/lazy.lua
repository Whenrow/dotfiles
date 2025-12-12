require("lazy").setup({
    -- UI
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    { 'nvim-treesitter/nvim-treesitter-context' },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    { 'emmanueltouzery/decisive.nvim' },
    {
      "ibhagwan/fzf-lua",
      -- optional for icon support
      dependencies = { "nvim-tree/nvim-web-devicons" },
      -- or if using mini.icons/mini.nvim
      -- dependencies = { "nvim-mini/mini.icons" },
      opts = {}
    },
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

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    },
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
    {"supermaven-inc/supermaven-nvim"},

    -- Git
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',

    -- Misc
    'tpope/vim-surround',
    { 'JellyApple102/flote.nvim', config = function() require('flote').setup() end },
    { 'rmagatti/auto-session'},
    {'ThePrimeagen/refactoring.nvim'},

    -- Debugging
    { "rcarriga/nvim-dap-ui", dependencies = { {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
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
