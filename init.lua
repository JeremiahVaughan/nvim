-- Reference: https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
-- Book mark: https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua#L701

-- if you don't specify the leader remaps first then any keybinds mapped before this remap will use the default leader key
vim.g.mapleader = " "       -- Setting space as the leader key
vim.g.maplocalleader = "\\" -- Same for `maplocalleader`

require("jeremiah")

-- Built in Comment/Uncomment --> normal mode gcgc --> visual mode gc

-- Windows is touchy here so going with c-q
-- Terminal mode: <C-q> escapes to normal
vim.keymap.set('t', '<C-q>', [[<C-\><C-n>]], { noremap = true, silent = true })

-- Normal mode: disable <C-q>
vim.keymap.set('n', '<C-q>', '<Nop>', { noremap = true, silent = true })


vim.api.nvim_create_user_command("M", function()
    jeremiah.utils.SaveAll()
    vim.cmd("compiler make") -- reset makeprg/errorformat before running :make
    vim.cmd("make")
end, { desc = "Save buffers and run make" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Visual feedback when yanking text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_set_keymap('i', '<BS>', '<C-w>', { noremap = false, silent = true })

vim.g.have_nerd_font = true
vim.opt.showmode = false -- mode is already in the status line


vim.opt.list = true
vim.opt.listchars = { tab = '» ', nbsp = '␣' }


vim.opt.number = true         -- Line numbers
vim.opt.relativenumber = true -- Shows relative line numbers to your cursor so I can jump up or down easier
vim.opt.tabstop = 4           -- Number of spaces a tab counts for
vim.opt.shiftwidth = 4        -- Size of an indent

vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.expandtab = true
-- vim.opt.expandtab = false -- using tab chars because they are required in makefiles, and I also like how the placeholder char forms a line, so I can see scope much easier


vim.opt.hlsearch = true  -- Highlight search results
vim.opt.incsearch = true -- Shows the match while typing

--[[ vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir" ]]
vim.opt.undofile = true
vim.g.undotree_SplitWidth = 60

vim.opt.splitright = true -- Open vertical splits to the right

-- make auto save to swap file more frequent
vim.opt.updatetime = 250
vim.opt.signcolumn = 'yes'

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

vim.opt.inccommand = 'split'

vim.opt.timeoutlen = 500
vim.opt.ignorecase = false
vim.opt.smartcase = false
-- vim.opt.infercase = true
vim.opt.wrap = false
vim.cmd('syntax enable') -- Enables syntax highlighting

-- Use system clipboard by default todo trying this out disabled to see if I like it better
-- vim.opt.clipboard = "unnamedplus"


-- Telescope configuration lives in lua/jeremiah/telescope.lua
vim.api.nvim_set_keymap('n', '<C-w>r', ':copen<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-w>q', ':cclose<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F8>', ':cnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F7>', ':cprev<CR>', { noremap = true, silent = true })

-- todo this hasn't worked a couple of times, so thinking of just not trusting it and ensuring I always save myself
-- Auto-save function when Neovim loses focus or files are changed
local group = vim.api.nvim_create_augroup('Autosave', { clear = true })
vim.api.nvim_create_autocmd({ "FocusLost", "WinLeave" }, {
    group = group,
    pattern = '*',
    command = 'silent! wa'
})

-- Define the 'Help' command that opens the help menu in a vertical split on the right
vim.api.nvim_create_user_command(
    'Help',                        -- Command name
    'rightbelow vert help <args>', -- Execute 'rightbelow vert help' with additional arguments
    { nargs = '+' }                -- This command requires at least one argument
)

-- Remap to enable pasting from registers to terminal
vim.keymap.set('t', '<c-r>', function()
    local next_char_code = vim.fn.getchar()
    local next_char = vim.fn.nr2char(next_char_code)
    return '<C-\\><C-N>"' .. next_char .. 'pi'
end, { expr = true })

-- Set insert mode to default when opening a new terminal
vim.api.nvim_create_augroup('TerminalAutocmd', { clear = true })
vim.api.nvim_create_autocmd('TermOpen', {
    group = 'TerminalAutocmd',
    pattern = '*',
    command = 'startinsert',
})

-- Clear current pattern
vim.api.nvim_set_keymap('n', '<leader>/', ':nohlsearch<CR>', { noremap = true, silent = true })

-- no mouse
vim.opt.mouse = ""
