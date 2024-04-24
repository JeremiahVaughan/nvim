require("jeremiah")

local undo_tree = '<leader>ut'
local next_error = '<F8>'
local previous_error = '<F7>'
local open_reference_window = '<C-w>r'
local close_reference_window = '<C-w>q'
local leader_keymap = " "
local maplocalleader = " "             -- Local Leader key is set to '\'
local find_files_keymap = '<leader>ff' -- Leader followed by 'ff' triggers finding files
local grep_files_keymap = '<leader>g'  -- grep through files to find files by text
local grep_string_keymap = '<leader>fs'
local search_buffers_keymap = '<leader>b'
local nvim_tree_toggle_keymap = '<leader>n' -- Leader n will toggle the file explorer
local shortcut_init_selection = "gnn"
local shortcut_node_incremental = "grn"
local shortcut_node_decremental = "grm"
-- Built in Comment/Uncomment --> normal mode gcgc --> visual mode gc

-- Remap esc to enter
-- Disable <Esc> in Insert mode
vim.api.nvim_set_keymap('i', '<Esc>', '<Nop>', { noremap = true, silent = true })
-- Disable <Esc> in Normal mode
vim.api.nvim_set_keymap('n', '<Esc>', '<Nop>', { noremap = true, silent = true })
-- Disable <Esc> in Visual mode
vim.api.nvim_set_keymap('v', '<Esc>', '<Nop>', { noremap = true, silent = true })
-- Disable <Esc> in Replace mode
vim.api.nvim_set_keymap('!', '<Esc>', '<Nop>', { noremap = true, silent = true })
-- Insert mode
vim.api.nvim_set_keymap('i', '<CR>', '<Esc>', { noremap = true, silent = true })
-- Visual Mode
vim.api.nvim_set_keymap('v', '<CR>', '<Esc>', { noremap = true, silent = true })
-- Replace mode
vim.api.nvim_set_keymap('!', '<CR>', '<Esc>', { noremap = true, silent = true })

-- Disabling backspace so I use control + h instead since its closer
-- Disable <Backspace> in Normal mode
vim.api.nvim_set_keymap('i', '<Backspace>', '<Nop>', { noremap = true, silent = true })
-- Disable <Backspace> in Command-Line mode
vim.api.nvim_set_keymap('c', '<Backspace>', '<Nop>', { noremap = true, silent = true })

-- startup and go strait to telescope find files
-- vim.cmd [[
--   autocmd VimEnter * silent! lua require('telescope.builtin').find_files()
-- ]]


-- Color Scheme --
vim.opt.cursorline = true
vim.cmd [[
  highlight CursorLine cterm=NONE ctermbg=236 ctermfg=NONE guibg=#414141
  highlight Normal guibg=#2c2c2c
  highlight Pmenu guifg=#FFFFFF guibg=#707070
  highlight PmenuSel guifg=#000000 guibg=#909090
  highlight TelescopeSelection gui=bold guibg=White guifg=Black
  highlight TelescopeSelectionCaret guifg=Re
  highlight @variable.member guifg=#cf8823
  highlight Function guifg=#a7e22e
  highlight @function.builtin guifg=#a7e22e
  highlight @keyword guifg=#ff00ff gui=bold
  highlight @boolean guifg=#ff00ff gui=bold
  highlight @constant.builtin guifg=#ff00ff gui=bold
  highlight @operator guifg=#a9b7c5
  highlight @tag.delimiter guifg=#a9b7c5
  highlight @punctuation.delimiter guifg=#a9b7c5
  highlight @punctuation.special guifg=#a9b7c5
  highlight @keyword.conditional.ternary guifg=#a9b7c5
  highlight @punctuation.bracket guifg=#a9b7c5
  highlight @string guifg=#e6db74
  highlight @number guifg=#ae81ff
  highlight @variable guifg=#cbad96
  highlight @comment guifg=#808080
  highlight @type guifg=#66d9ef
  highlight @type.definition guifg=#66d9ef
  highlight @type.builtin guifg=#20999d
  highlight @property guifg=#cf8823
  highlight @tag.builtin gui=bold guifg=#e8be69
  highlight @tag gui=bold guifg=#28bda4
  highlight @tag.attribute guifg=#cecece
  highlight sassClass guifg=#C5BE69 gui=bold
  highlight sassAmpersand guifg=#C5BE69 gui=bold
  highlight cssPseudoClass guifg=#C5BE69 gui=bold
  highlight cssPseudoClassId guifg=#C5BE69 gui=bold
  highlight sassDefinition guifg=#a9b7c5
  highlight sassProperty guifg=#a9b7c5
  highlight cssBorderProp guifg=#a9b7c5
  highlight cssBoxProp guifg=#a9b7c5
  highlight cssFontProp guifg=#a9b7c5
  highlight cssMediaProp guifg=#a9b7c5
  highlight cssBackgroundProp guifg=#a9b7c5
  highlight cssPositioningProp guifg=#a9b7c5
  highlight cssTextProp guifg=#a9b7c5
  highlight cssFlexibleBoxProp guifg=#a9b7c5
  highlight cssUIProp guifg=#a9b7c5
  highlight cssValueLength guifg=#ae81ff
  highlight cssValueNumber guifg=#ae81ff
  highlight cssUnitDecorators guifg=#679342
  highlight cssPositioningAttr guifg=#679342
  highlight cssColor guifg=#FD971F
  highlight cssColorProp guifg=#a9b7c5
  highlight cssUIAttr guifg=#679342
  highlight cssFontAttr guifg=#679342
  highlight cssTextAttr guifg=#679342
  highlight cssFlexibleBoxAttr guifg=#679342
  highlight cssMultiColumnAttr guifg=#679342
]]

-- disabled for nvim tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.o.number = true         -- Line numbers
vim.o.relativenumber = true -- Shows relative line numbers to your cursor so I can jump up or down easier
vim.o.tabstop = 4           -- Number of spaces a tab counts for
vim.o.shiftwidth = 4        -- Size of an indent
vim.o.expandtab = true      -- expands tab to spaces
vim.o.hlsearch = true       -- Highlight search results
vim.o.incsearch = true      -- Shows the match while typing

--[[ vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir" ]]
vim.o.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.o.wrap = false
vim.cmd('syntax enable')              -- Enables syntax highlighting
vim.g.mapleader = leader_keymap       -- Setting space as the leader key
vim.g.maplocalleader = maplocalleader -- Same for `maplocalleader`
vim.api.nvim_set_keymap('n', find_files_keymap, ':Telescope find_files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', grep_files_keymap, ':Telescope live_grep<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', grep_string_keymap, ':Telescope grep_string<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', search_buffers_keymap, ':Telescope buffers<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', open_reference_window, ':copen<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', close_reference_window, ':cclose<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', next_error, ':cnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', previous_error, ':cprev<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', undo_tree, ':UndotreeToggle<CR>', { noremap = true, silent = true })

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


-- Telescope Setup
require('telescope').setup {
    defaults = {
        file_ignore_patterns = {
            "node_modules",
            "%.jpg",
            "%.png" }
    },
}


-- Treesitter setup
require('nvim-treesitter.configs').setup {
    ensure_installed = { "go", "python", "lua", "typescript", "tsx", "javascript", "vim", "vimdoc", "query" }, -- Install parsers for Go and Python only
    highlight = {
        enable = true,                                                                                         -- Enable syntax highlighting
        additional_vim_regex_highlighting = false                                                              -- Disable regex based highlighting
    },
    incremental_selection = {
        enable = true,
        init_selection = shortcut_init_selection,
        node_incremental = shortcut_node_incremental,
        node_decremental = shortcut_node_decremental
    },
    indent = { enable = true } -- Enable indentation
}

-- nvim tree setup
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 30,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
})
vim.api.nvim_set_keymap('n', nvim_tree_toggle_keymap, ':NvimTreeToggle<CR>', { noremap = true, silent = true })
