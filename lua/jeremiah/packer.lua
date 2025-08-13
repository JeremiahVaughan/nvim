local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup({
    {
        "trixnz/sops.nvim",
        lazy = false
    },
    { 'kmonad/kmonad-vim' },
    -- Color Picker
    { 'uga-rosa/ccc.nvim' },
    {
        'tpope/vim-dadbod',
        dependencies = {
            { 'kristijanhusak/vim-dadbod-completion' },
            { 'kristijanhusak/vim-dadbod-ui' },
        },
    },
    {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {},
        -- Optional dependencies
        dependencies = { { "echasnovski/mini.icons", opts = {} } },
        -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
    },
    { -- Used for keeping only one instance of Nvim, noticable when opening a file within lazygit with 'e'
        "willothy/flatten.nvim",
        config = true,
        -- or pass configuration with
        --     -- opts = {  }
        --         -- Ensure that it runs first to minimize delay when opening file from terminal
        lazy = false,
        priority = 1001,
    },
    'tpope/vim-commentary',
    {
        'nvim-telescope/telescope.nvim',
        event = 'VimEnter',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { -- If encountering errors, see telescope-fzf-native README for installation instructions
                'nvim-telescope/telescope-fzf-native.nvim',

                -- `build` is used to run some command when the plugin is installed/updated.
                -- This is only run then, not every time Neovim starts up.
                build = 'make',

                -- `cond` is a condition used to determine whether this plugin should be
                -- installed and loaded.
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
            { 'nvim-telescope/telescope-ui-select.nvim' },

            -- Useful for getting pretty icons, but requires a Nerd Font.
            {
                'nvim-tree/nvim-web-devicons',
                enabled = vim.g.have_nerd_font
            },
        }
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },
    'nvim-treesitter/playground',
    'mbbill/undotree',
    -- auto-completion stuff
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    -- 'saadparwaiz1/cmp_luasnip',
    -- 'hrsh7th/cmp-nvim-lsp',
    -- 'hrsh7th/cmp-nvim-lua',
    -- 'L3MON4D3/LuaSnip',
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            opt = true,
        },
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {}, -- for default options, refer to the configuration section for custom setup.
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" }
    }
},
{
    rocks = {
        -- Disable Lua dependency stuff since external dependencies are not needed right now and hopefully won't be
        -- Installing these was a HUGE pain in past experience and I'm not looking to become a Lua ecosystem expert
        enabled = false,
        hererocks = false,
    },
}
)
