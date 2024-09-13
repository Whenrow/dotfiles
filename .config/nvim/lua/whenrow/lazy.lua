require("lazy").setup({
    -- UI
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    { 'nvim-treesitter/nvim-treesitter-context' },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    { 'emmanueltouzery/decisive.nvim' },
    {
        'nvim-telescope/telescope.nvim',
        event = 'VimEnter',
        target = '0.1.6',
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

            -- Useful for getting pretty icons, but requires a Nerd Font.
            { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
        },
    },
    'mbbill/undotree',
    'onsails/lspkind.nvim',
    'nvim-lualine/lualine.nvim',
    {'catppuccin/nvim', name = 'catppuccin'},
    { 'norcalli/nvim-colorizer.lua', config = function() require('colorizer').setup({'css', 'html', '!TelescopeResults'}) end },
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
    { dir = '/home/whe/src/ols/nvim'},
    'ollykel/v-vim',
    {'Exafunction/codeium.vim',
        enabled = true,
        version = "1.8.37",
        config = function ()
            -- Change '<C-g>' here to any keycode you like.
            vim.g.codeium_format = {'python', 'javascript'}
            vim.keymap.set('i', '<C-y>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
            vim.keymap.set('i', '<C-l>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
            vim.keymap.set('i', '<C-h>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
            vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
            vim.keymap.set('n', 'Leader<c-c>', function() return vim.fn['codeium#Chat']() end, { expr = true, silent = true })
        end,
    },

	-- Git
	'tpope/vim-fugitive',
	'tpope/vim-rhubarb',

	-- Misc
	'tpope/vim-surround',
	{ 'JellyApple102/flote.nvim', config = function() require('flote').setup() end },

	-- Debugging
        { "rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"}},

	-- Bullshit
	'eandrju/cellular-automaton.nvim',
	'lewis6991/gitsigns.nvim',
    })
