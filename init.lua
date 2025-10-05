-- Reference: https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
-- Book mark: https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua#L701

-- if you don't specify the leader remaps first then any keybinds mapped before this remap will use the default leader key
vim.g.mapleader = " "       -- Setting space as the leader key
vim.g.maplocalleader = "\\" -- Same for `maplocalleader`

require("jeremiah")

-- Built in Comment/Uncomment --> normal mode gcgc --> visual mode gc

-- Remap esc to enter
-- Disable <Esc> in Insert mode
-- vim.api.nvim_set_keymap('i', '<Esc>', '<Nop>', { noremap = true, silent = true })
-- Disable <Esc> in Normal mode
-- vim.api.nvim_set_keymap('n', '<Esc>', '<Nop>', { noremap = true, silent = true })
-- Disable <Esc> in Visual mode
-- vim.api.nvim_set_keymap('v', '<Esc>', '<Nop>', { noremap = true, silent = true })
-- Disable <Esc> in Replace mode
-- vim.api.nvim_set_keymap('!', '<Esc>', '<Nop>', { noremap = true, silent = true })
-- Insert mode
-- vim.api.nvim_set_keymap('i', '<CR>', '<Esc>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('i', '<S-CR>', '<CR>', { noremap = true, silent = true })
-- Visual Mode
-- vim.api.nvim_set_keymap('v', '<CR>', '<Esc>', { noremap = true, silent = true })
-- Replace mode
-- vim.api.nvim_set_keymap('!', '<CR>', '<Esc>', { noremap = true, silent = true })

-- Windows is touchy here so going with c-q
-- Terminal mode: <C-q> escapes to normal
vim.keymap.set('t', '<C-q>', [[<C-\><C-n>]], { noremap = true, silent = true })

-- Normal mode: disable <C-q>
vim.keymap.set('n', '<C-q>', '<Nop>', { noremap = true, silent = true })




-- Remap <S-Enter> in terminal mode to act as the default <Enter>
-- vim.api.nvim_set_keymap('t', '<S-Enter>', '<Enter>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<S-Enter>', 'i<CR>', { noremap = true, silent = true })


-- Easy exit terminal mode
-- todo problem with pressing escape twice is that I sometimes actually want to press it a few times quickly in the program itself like when navigating in k9s
-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Saves the file then executes make
vim.cmd('command! M write | make')

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

-- Keybinds to make split navigation easier.
-- --  Use CTRL+<hjkl> to switch between windows
-- --
-- --  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })


vim.api.nvim_set_keymap('i', '<BS>', '<C-w>', { noremap = true, silent = true })
-- vim.keymap.set('c', '<BS>', '<C-w>', { noremap = true, silent = true })
-- the lua version above is not working for some strange reason, but this vim version does
vim.cmd('cnoremap <bs> <C-w>')



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
vim.api.nvim_set_keymap('n', '<leader>ut', ':UndotreeToggle<CR>', { noremap = true, silent = true })

-- todo this hasn't worked a couple of times, so thinking of just not trusting it and ensuring I always save myself
-- Auto-save function when Neovim loses focus or files are changed
local group = vim.api.nvim_create_augroup('Autosave', { clear = true })
vim.api.nvim_create_autocmd({ "FocusLost", "WinLeave" }, {
    group = group,
    pattern = '*',
    command = 'silent! wa'
})


local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)


-- vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end, { desc = "Open harpoon window" })

-- Define the 'Help' command that opens the help menu in a vertical split on the right
vim.api.nvim_create_user_command(
    'Help',                        -- Command name
    'rightbelow vert help <args>', -- Execute 'rightbelow vert help' with additional arguments
    { nargs = '+' }                -- This command requires at least one argument
)

-- Map <Leader>h to the 'Help' command
-- vim.api.nvim_set_keymap('n', '<Leader>h', ':Help ', { noremap = true, silent = true })

-- Create a custom command 'Make' that saves the buffer and runs 'make'
vim.api.nvim_create_user_command(
    'M', -- Command name
    function()
        jeremiah.utils.SaveAll()
        vim.cmd('make')                   -- Run make
    end,
    { desc = "Save buffer and run make" } -- Description for the command
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

-- Use wezterm
if (os.getenv('SSH_TTY') ~= nil) then
    vim.g.clipboard = {
        name = 'OSC 52',
        copy = {
            ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
            ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
        },
        paste = {
            ["+"] = require('vim.ui.clipboard.osc52').paste('+'),
            ["*"] = require('vim.ui.clipboard.osc52').paste('*'),
        },
    }
end

local function load_env_vars(file_path)
    local env_vars = {}
    local file = io.open(file_path, "r")
    if not file then
        print("Could not open env file: " .. file_path)
        return env_vars
    end
    for line in file:lines() do
        -- Trim leading and trailing whitespace
        line = line:match("^%s*(.-)%s*$")
        -- Split the line into key and value
        local delimiter_pos = line:find("=")
        if delimiter_pos then
            local key = line:sub(1, delimiter_pos - 1)
            local value = line:sub(delimiter_pos + 1)
            env_vars[key] = value
        end
    end
    file:close()
    return env_vars
end


-- Clear current pattern
vim.api.nvim_set_keymap('n', '<leader>/', ':nohlsearch<CR>', { noremap = true, silent = true })

-- no mouse
vim.opt.mouse = ""
-- oil
require("oil").setup({
    view_options = {
        show_hidden = true,
    },
    keymaps = {
        ["<C-h>"] = false,
    },
    columns = { "icon" },
})

-- Open parent directory in current window
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Open parent directory in floating window
vim.keymap.set("n", "<space>-", require("oil").toggle_float)

if vim.fn.has("win64") == 0 then
    vim.g.clipboard = "osc52"                                             
    vim.o.shell = "bash"
end

require("jeremiah.copy_absolute_path").setup()

local function toggle_diff_mode()
  local win1 = vim.fn.win_getid(1)
  local win2 = vim.fn.win_getid(2)

  -- Check if both windows are in diff mode
  local is_diff = vim.api.nvim_win_get_option(win1, 'diff') and vim.api.nvim_win_get_option(win2, 'diff')

  if is_diff then
    vim.api.nvim_win_call(win1, function() vim.cmd('diffoff') end)
    vim.api.nvim_win_call(win2, function() vim.cmd('diffoff') end)
  else
    vim.api.nvim_win_call(win1, function() vim.cmd('diffthis') end)
    vim.api.nvim_win_call(win2, function() vim.cmd('diffthis') end)
  end
end

vim.keymap.set('n', '<leader>d', toggle_diff_mode, { desc = 'Toggle diff mode for 2 vertical splits' })
