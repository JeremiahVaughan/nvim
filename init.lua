-- Reference: https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
-- Book mark: https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua#L701
--
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


vim.api.nvim_set_keymap('n', "<leader>et", ':TroubleToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<BS>', '<C-w>', { noremap = true, silent = true })
-- vim.keymap.set('c', '<BS>', '<C-w>', { noremap = true, silent = true })
-- the lua version above is not working for some strange reason, but this vim version does
vim.cmd('cnoremap <bs> <C-w>')



vim.g.have_nerd_font = true
vim.opt.showmode = false -- mode is already in the status line

-- -- Color Scheme --
vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#75aaff' })
vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#008518' })
vim.opt.cursorline = true
vim.opt.termguicolors = true -- without this option set to true, alacritty does not show color when nvim is ran over ssh
local ccc = require("ccc")
vim.api.nvim_set_keymap('i', '<C-c>', '<Plug>(ccc-insert)', { noremap = false, silent = true })
vim.api.nvim_set_keymap('v', '<C-s>', '<Plug>(ccc-select-color)', { noremap = false, silent = true })
ccc.setup({
    -- Your preferred settings
    -- Example: enable highlighter
    highlighter = {
        auto_enable = true,
        lsp = true,
    },
})

-- original
-- vim.cmd [[
--     highlight link TermCursor Cursor
--     highlight TermCursorNC guibg=red guifg=white ctermbg=1 ctermfg=15
--     highlight @boolean guifg=#ff00ff gui=bold
--     highlight @constant.builtin guifg=#ff00ff gui=bold
--     highlight @function guifg=#a7e22e
--     highlight @function.builtin guifg=#a7e22e
--     highlight @function.call guifg=#a7e22e
--     highlight @keyword guifg=#ff00ff gui=bold
--     highlight @keyword.conditional.ternary guifg=#a9b7c5
--     highlight @number guifg=#ae81ff
--     highlight @operator guifg=#a9b7c5
--     highlight @property guifg=#cf8823
--     highlight @punctuation.bracket guifg=#a9b7c5
--     highlight @punctuation.delimiter guifg=#a9b7c5
--     highlight @punctuation.special guifg=#a9b7c5
--     highlight @string guifg=#e6db74
--     highlight @tag gui=bold guifg=#28bda4
--     highlight @tag.attribute guifg=#cecece
--     highlight @tag.builtin gui=bold guifg=#e8be69
--     highlight @tag.delimiter guifg=#a9b7c5
--     highlight @type guifg=#66d9ef
--     highlight @type.builtin guifg=#20999d
--     highlight @type.definition guifg=#66d9ef
--     highlight @variable guifg=#cbad96
--     highlight @variable.member guifg=#cf8823
--     highlight cssBackgroundProp guifg=#a9b7c5
--     highlight cssBorderProp guifg=#a9b7c5
--     highlight cssBoxProp guifg=#a9b7c5
--     highlight cssColor guifg=#FD971F
--     highlight cssColorProp guifg=#a9b7c5
--     highlight cssFlexibleBoxAttr guifg=#679342
--     highlight cssFlexibleBoxProp guifg=#a9b7c5
--     highlight cssFontAttr guifg=#679342
--     highlight cssFontProp guifg=#a9b7c5
--     highlight cssMediaProp guifg=#a9b7c5
--     highlight cssMultiColumnAttr guifg=#679342
--     highlight cssPositioningAttr guifg=#679342
--     highlight cssPositioningProp guifg=#a9b7c5
--     highlight cssPseudoClass guifg=#C5BE69 gui=bold
--     highlight cssPseudoClassId guifg=#C5BE69 gui=bold
--     highlight cssTextAttr guifg=#679342
--     highlight cssTextProp guifg=#a9b7c5
--     highlight cssUIAttr guifg=#679342
--     highlight cssUIProp guifg=#a9b7c5
--     highlight cssUnitDecorators guifg=#679342
--     highlight cssValueLength guifg=#ae81ff
--     highlight cssValueNumber guifg=#ae81ff
--     highlight Pmenu guifg=#FFFFFF guibg=#707070
--     highlight PmenuSel guifg=#000000 guibg=#909090
--     highlight sassAmpersand guifg=#C5BE69 gui=bold
--     highlight sassClass guifg=#C5BE69 gui=bold
--     highlight sassDefinition guifg=#a9b7c5
--     highlight sassProperty guifg=#a9b7c5
--     highlight TelescopeSelection gui=bold guibg=White guifg=Black
--     highlight TelescopeSelectionCaret guifg=Re
-- ]]

-- Color Scheme 2 -- 
-- Set base background
vim.api.nvim_set_hl(0, 'Normal', { bg = '#002b36', fg = '#839496' })
vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#073642' })
vim.api.nvim_set_hl(0, 'Comment', { fg = '#586e75', italic = true })

-- -- Syntax groups
vim.api.nvim_set_hl(0, '@type', { fg = '#2aa198' })
vim.api.nvim_set_hl(0, '@function', { fg = '#268bd2' })
vim.api.nvim_set_hl(0, '@variable', { fg = '#839496' })
vim.api.nvim_set_hl(0, '@string', { fg = '#859900' })
vim.api.nvim_set_hl(0, '@number', { fg = '#b58900' })
vim.api.nvim_set_hl(0, '@constant', { fg = '#cb4b16' })
vim.api.nvim_set_hl(0, '@boolean', { fg = '#b58900', bold = true })

-- -- UI elements
vim.api.nvim_set_hl(0, 'StatusLine', { bg = '#073642', fg = '#93a1a1' })
vim.api.nvim_set_hl(0, 'Visual', { bg = '#586e75' })

vim.api.nvim_set_hl(0, 'TermCursor', { link = 'Cursor' })
vim.api.nvim_set_hl(0, 'TermCursorNC', { bg = '#d33682', fg = '#fdf6e3' }) -- magenta on light

-- Treesitter core
vim.api.nvim_set_hl(0, '@constant.builtin', { fg = '#cb4b16', bold = true }) -- like @constant, emphasized
vim.api.nvim_set_hl(0, '@function.builtin', { fg = '#268bd2' })
vim.api.nvim_set_hl(0, '@function.call',    { fg = '#268bd2' })
vim.api.nvim_set_hl(0, '@keyword',          { fg = '#d33682', bold = true }) 
vim.api.nvim_set_hl(0, '@keyword.conditional.ternary', { fg = '#93a1a1' })   -- neutral gray
vim.api.nvim_set_hl(0, '@operator', { fg = '#93a1a1' })                      -- already set above, safe repeat
vim.api.nvim_set_hl(0, '@property', { fg = '#cb4b16' })                      -- orange for props
vim.api.nvim_set_hl(0, '@punctuation.bracket',   { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, '@punctuation.delimiter', { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, '@punctuation.special',   { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, '@tag',           { fg = '#2aa198', bold = true })    -- cyan, emphasized
vim.api.nvim_set_hl(0, '@tag.attribute', { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, '@tag.builtin',   { fg = '#b58900', bold = true })    -- yellow, emphasized
vim.api.nvim_set_hl(0, '@tag.delimiter', { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, '@type.builtin',  { fg = '#2aa198' })
vim.api.nvim_set_hl(0, '@type.definition',{ fg = '#2aa198' })
vim.api.nvim_set_hl(0, '@variable.member',{ fg = '#cb4b16' })                -- member/field = orange

-- CSS (mapped roughly: props=gray, attrs=green, numbers=yellow, colors=orange)
vim.api.nvim_set_hl(0, 'cssBackgroundProp',   { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, 'cssBorderProp',       { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, 'cssBoxProp',          { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, 'cssColor',            { fg = '#cb4b16' }) -- “color” keyword values
vim.api.nvim_set_hl(0, 'cssColorProp',        { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, 'cssFlexibleBoxAttr',  { fg = '#859900' })
vim.api.nvim_set_hl(0, 'cssFlexibleBoxProp',  { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, 'cssFontAttr',         { fg = '#859900' })
vim.api.nvim_set_hl(0, 'cssFontProp',         { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, 'cssMediaProp',        { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, 'cssMultiColumnAttr',  { fg = '#859900' })
vim.api.nvim_set_hl(0, 'cssPositioningAttr',  { fg = '#859900' })
vim.api.nvim_set_hl(0, 'cssPositioningProp',  { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, 'cssPseudoClass',      { fg = '#b58900', bold = true })
vim.api.nvim_set_hl(0, 'cssPseudoClassId',    { fg = '#b58900', bold = true })
vim.api.nvim_set_hl(0, 'cssTextAttr',         { fg = '#859900' })
vim.api.nvim_set_hl(0, 'cssTextProp',         { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, 'cssUIAttr',           { fg = '#859900' })
vim.api.nvim_set_hl(0, 'cssUIProp',           { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, 'cssUnitDecorators',   { fg = '#859900' })
vim.api.nvim_set_hl(0, 'cssValueLength',      { fg = '#b58900' }) -- numbers/units
vim.api.nvim_set_hl(0, 'cssValueNumber',      { fg = '#b58900' })

-- Popup menu (already set in your scheme; included here only if you need the legacy Vim groups)
vim.api.nvim_set_hl(0, 'Pmenu',    { bg = '#073642', fg = '#93a1a1' })
vim.api.nvim_set_hl(0, 'PmenuSel', { bg = '#586e75', fg = '#fdf6e3' })

-- Sass
vim.api.nvim_set_hl(0, 'sassAmpersand', { fg = '#b58900', bold = true })
vim.api.nvim_set_hl(0, 'sassClass',     { fg = '#b58900', bold = true })
vim.api.nvim_set_hl(0, 'sassDefinition',{ fg = '#93a1a1' })
vim.api.nvim_set_hl(0, 'sassProperty',  { fg = '#93a1a1' })

-- Telescope (Caret already defined in your scheme; fixing the old typo)
vim.api.nvim_set_hl(0, 'TelescopeSelection',      { bg = '#073642', fg = '#93a1a1', bold = true })
vim.api.nvim_set_hl(0, 'TelescopeSelectionCaret', { fg = '#d33682' })

-- white space visuals
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


-- Function to search for the current visually selected text
local function search_visual_selection()
    local previous_selection = vim.fn.getreg('"')
    vim.cmd('normal! "vy')
    local selected_text = vim.fn.getreg('"')
    vim.fn.setreg('"', previous_selection)
    require('telescope.builtin').live_grep({
        default_text = selected_text,
    })
end

vim.api.nvim_set_keymap('n', '<leader>sf', ':Telescope find_files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sg', ':Telescope live_grep<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ss', ':Telescope grep_string<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sb', ':Telescope buffers<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sr', ':Telescope registers<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sc', ':Telescope command_history<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sqf', ':Telescope quickfix<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sqh', ':Telescope quickfixhistory<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sp', ':Telescope search_history<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>sk', ':Telescope keymaps<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>sd', ':Telescope diagnostics<CR>', { noremap = true, silent = true })
vim.keymap.set("v", "<leader>s", search_visual_selection)
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


-- Status bar setup
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'wombat',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = {
            {
                'filename',
                path = 1,
            },
        },
        lualine_x = {},
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = { 'location', 'encoding', 'fileformat', 'filetype' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}



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


-- basic telescope configuration
-- local conf = require("telescope.config").values
-- local function toggle_telescope(harpoon_files)
-- 	local file_paths = {}
-- 	for _, item in ipairs(harpoon_files.items) do
-- 		table.insert(file_paths, item.value)
-- 	end

-- 	require("telescope.pickers").new({}, {
-- 		prompt_title = "Harpoon",
-- 		finder = require("telescope.finders").new_table({
-- 			results = file_paths,
-- 		}),
-- 		previewer = conf.file_previewer({}),
-- 		sorter = conf.generic_sorter({}),
-- 	}):find()
-- end

-- vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end, { desc = "Open harpoon window" })

-- Telescope Setup
local actions = require('telescope.actions')
local teleBuiltin = require 'telescope.builtin'
require('telescope').setup {
    defaults = {
        -- this mapping appears to be required if you are using custom pickers
        mappings = {
            i = {
                ["<C-c>"] = actions.close, -- Map Ctrl+C to close action
            },
        },
        -- todo figure out how to make this fuzzy refine thing work
        -- mappings = {
        --     i = { ['<C-s>'] = 'to_fuzzy_refine' },
        -- },
        find_command = { 'rg', '--files', '--hidden', '--glob', '!.git/*' },
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden', -- Add this line to include hidden files
            '--glob',
            '!.git/*'   -- Optionally exclude .git directory
        },
        file_ignore_patterns = {
            "node_modules",
            "%.jpg",
            "%.png",
            "%.git\\", -- Windows
            "%.git/",  -- other
            -- 'grpc',
            "debug",   -- debug bin
        },
        layout_strategy = 'flex',
        layout_config = {
            flex = {
                flip_columns = 120 -- Adjust this value based on your preference
            },
            width = 0.95,          -- Percentage of the screen width
            height = 0.95,         -- Percentage of the screen height
            preview_cutoff = 120,  -- When to start showing the preview pane
        }
    },
    pickers = {
        find_files = {
            hidden = true
        }
    }
}

-- Enable Telescope extensions if they are installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')

-- Shortcut for searching your Neovim configuration files
vim.keymap.set('n', '<leader>sn', function()
    teleBuiltin.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[S]earch [N]eovim files' })

-- Finding templates
vim.keymap.set('n', '<leader>st', function()
    teleBuiltin.find_files { cwd = vim.fn.stdpath('config') .. '/lua/jeremiah/templates' }
end, { desc = '[S]earch [T]emplate files' })

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

-- if (os.getenv('SSH_TTY') == nil) then
-- 	vim.opt.shell = "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe"
-- end



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
    vim.o.shell = "zsh"
end

vim.api.nvim_create_user_command("CopyAbsolutePath", function()
    local absolutePath = vim.fn.expand("%:p") -- Get absolute path of the current buffer
    if absolutePath == "" then
        print("No file name")
        return
    end


    -- Copy to the system clipboard (works on most systems)
    vim.fn.setreg("+", absolutePath) -- Uses `+` register (system clipboard)
    vim.fn.setreg("*", absolutePath) -- Also supports primary clipboard (Linux/X11)

    print("Copied path: " .. absolutePath)
end, {})

local function insert_todo_log()
  local chars = {}
  for _ = 1, 5 do
    local n = math.random(1, 52)
    local c = string.char(n <= 26 and (n + 64) or (n + 70)) -- A-Z (65–90), a-z (97–122)
    table.insert(chars, c)
  end
  local random_str = table.concat(chars)
  local line = 'log.Printf("todo remove ' .. random_str .. '")'
  vim.api.nvim_put({line}, 'c', true, true)
end

local function insert_random_string()
  local chars = {}
  for _ = 1, 5 do
    local n = math.random(1, 52)
    local c = string.char(n <= 26 and (n + 64) or (n + 70)) -- A-Z (65–90), a-z (97–122)
    table.insert(chars, c)
  end
  local random_str = table.concat(chars)
  vim.api.nvim_put({random_str}, 'c', true, true)
end


-- Map it to <leader>t
vim.keymap.set('n', '<leader>i', insert_todo_log, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>r', insert_random_string, { noremap = true, silent = true })

local function transform_visual_selection(cmd)
    local previous_selection = vim.fn.getreg('"')

    -- Yank visual selection into "v register
    vim.cmd('normal! "vy')

    local selected_text = vim.fn.getreg('v')

    -- Run the provided command
    local decoded = vim.fn.system(cmd, selected_text)

    -- Trim trailing newline if present
    decoded = decoded:gsub("\n$", "")

    -- Replace the visual selection with the result
    vim.cmd('normal! gv')
    vim.cmd("normal! c" .. decoded)

    -- Restore previous unnamed register
    vim.fn.setreg('"', previous_selection)
end
vim.keymap.set('v', '<leader>dtodo', function()
    transform_visual_selection("base64 --decode")
end, { noremap = true, silent = true })
vim.keymap.set('v', '<leader>etodo', function()
    transform_visual_selection("base64")
end, { noremap = true, silent = true })

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
