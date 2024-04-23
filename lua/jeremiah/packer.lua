local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end
ensure_packer()


require("packer").startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    use {
      'VonHeikemen/lsp-zero.nvim',
      branch = 'v3.x',
      requires = {
        --- Uncomment the two plugins below if you want to manage the language servers from neovim
        {'williamboman/mason.nvim'},
        {'williamboman/mason-lspconfig.nvim'},

        {'neovim/nvim-lspconfig'},
        {'hrsh7th/nvim-cmp'},
        {'hrsh7th/cmp-nvim-lsp'},
        {'L3MON4D3/LuaSnip'},
      }
    }
    use 'tpope/vim-commentary'
--    use 'Mofiqul/dracula.nvim'
    use 'nvim-lua/plenary.nvim'
    -- use 'nvim-lua/popup.nvim'
    -- fuzzy search stuff
    use 'nvim-telescope/telescope.nvim'
    -- Syntax highlight and parsing
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }
    use 'nvim-treesitter/playground'
    use 'mbbill/undotree'
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use 'neovim/nvim-lspconfig'
    use {
        'nvim-tree/nvim-tree.lua',
         requires = {
             'nvim-tree/nvim-web-devicons', -- optional
         },
    }
    -- auto-completion stuff
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'saadparwaiz1/cmp_luasnip'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-nvim-lua'

    use {
        'nvim-lualine/lualine.nvim',
        requires = {
            'nvim-tree/nvim-web-devicons',
            opt = true,
        },
    }
end)
