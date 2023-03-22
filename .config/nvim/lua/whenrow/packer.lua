-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- -- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.0',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }
--  use { 'nvim-telescope/telescope-fzf-native.nvim', do = 'make' }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'onsails/lspkind.nvim'
  use 'nvim-lualine/lualine.nvim'
  use 'kyazdani42/nvim-web-devicons'
  use 'tpope/vim-commentary'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'tpope/vim-surround'
  use 'neovim/nvim-lspconfig'
  use 'lewis6991/spellsitter.nvim'
  use { 'catppuccin/nvim', as = 'catppuccin'}
  use 'norcalli/nvim-colorizer.lua'
  use 'mbbill/undotree'
  use 'eandrju/cellular-automaton.nvim'
  use 'github/copilot.vim'
  use 'ollykel/v-vim'
  use 'lewis6991/gitsigns.nvim'
end)
