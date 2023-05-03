-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- -- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- UI
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'nvim-treesitter/nvim-treesitter-context'}
  use {
      'nvim-telescope/telescope.nvim', tag = '0.1.1',
      -- or                            , branch = '0.1.x',
      requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
  use 'mbbill/undotree'
  use 'onsails/lspkind.nvim'
  use 'nvim-lualine/lualine.nvim'
  use 'kyazdani42/nvim-web-devicons'
  use { 'catppuccin/nvim', as = 'catppuccin'}
  use 'lewis6991/gitsigns.nvim'
  use {'norcalli/nvim-colorizer.lua', config = function() require('colorizer').setup() end}

  -- lsp stuff
  use {
      'VonHeikemen/lsp-zero.nvim',
      branch = 'v1.x',
      requires = {
          -- LSP Support
          {'neovim/nvim-lspconfig'},
          {'williamboman/mason.nvim'},
          {'williamboman/mason-lspconfig.nvim'},

          -- Autocompletion
          {'hrsh7th/nvim-cmp'},
          {'hrsh7th/cmp-buffer'},
          {'hrsh7th/cmp-path'},
          {'saadparwaiz1/cmp_luasnip'},
          {'hrsh7th/cmp-nvim-lsp'},
          {'hrsh7th/cmp-nvim-lua'},

          -- Snippets
          {'L3MON4D3/LuaSnip'},
          {'rafamadriz/friendly-snippets'},
      }
  }
  use 'ollykel/v-vim'
  use {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      event = "InsertEnter",
      config = function()
          require("copilot").setup({
              suggestion = {
                  auto_trigger = true,
                  keymap = {
                      accept = "<C-y>",
                      accept_word = false,
                      accept_line = false,
                  },
              },
              fyletypes = {
                  gitcommit = true,
              },
          })
      end,
  }

  -- Git
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'

  -- Misc
  use 'tpope/vim-commentary'
  use 'tpope/vim-surround'
  use {'JellyApple102/flote.nvim', config = function() require('flote').setup() end}

  -- Bullshit
  use 'eandrju/cellular-automaton.nvim'
  use 'lewis6991/gitsigns.nvim'
end)
