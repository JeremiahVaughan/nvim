-- Reference: https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
-- Book mark: https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua#L701
--
-- if you don't specify the leader remaps first then any keybinds mapped before this remap will use the default leader key
local leader_keymap = " "
local maplocalleader = "\\"           -- Local Leader key is set to '\'
vim.g.mapleader = leader_keymap       -- Setting space as the leader key
vim.g.maplocalleader = maplocalleader -- Same for `maplocalleader`

require("jeremiah")

local undo_tree = '<leader>ut'
local next_error = '<F8>'
local previous_error = '<F7>'
local open_reference_window = '<C-w>r'
local close_reference_window = '<C-w>q'
local find_files_keymap = '<leader>sf' -- Leader followed by 'ff' triggers finding files
local grep_files_keymap = '<leader>sg' -- grep through files to find files by text
local grep_string_keymap = '<leader>ss'
local search_buffers_keymap = '<leader>sb'
local search_registers_keymap = '<leader>sr'
local shortcut_init_selection = "gnn"
local shortcut_node_incremental = "grn"
local shortcut_node_decremental = "grm"
local toggle_trouble = "<leader>tt"

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
vim.api.nvim_set_keymap('i', '<S-CR>', '<CR>', { noremap = true, silent = true })
-- Visual Mode
vim.api.nvim_set_keymap('v', '<CR>', '<Esc>', { noremap = true, silent = true })
-- Replace mode
vim.api.nvim_set_keymap('!', '<CR>', '<Esc>', { noremap = true, silent = true })

-- Remap <Enter> in terminal mode to exit to normal mode
vim.api.nvim_set_keymap('t', '<Enter>', [[<C-\><C-n>]], { noremap = true, silent = true })

-- Remap <S-Enter> in terminal mode to act as the default <Enter>
vim.api.nvim_set_keymap('t', '<S-Enter>', '<Enter>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Enter>', 'i<CR>', { noremap = true, silent = true })


-- Easy exit terminal mode
-- todo problem with pressing escape twice is that I sometimes actually want to press it a few times quickly in the program itself like when navigating in k9s
-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

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


vim.api.nvim_set_keymap('n', toggle_trouble, ':TroubleToggle<CR>', { noremap = true, silent = true })
-- Disabling backspace so I use control + h instead since its closer
-- Disable <Backspace> in Normal mode
vim.api.nvim_set_keymap('i', '<Backspace>', '<Nop>', { noremap = true, silent = true })
-- Disable <Backspace> in Command-Line mode
vim.api.nvim_set_keymap('c', '<Backspace>', '<Nop>', { noremap = true, silent = true })


vim.g.have_nerd_font = true
vim.opt.showmode = false -- mode is already in the status line

-- Color Scheme --
vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#75aaff' })
vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#008518' })
vim.opt.cursorline = true
vim.opt.termguicolors = true -- without this option set to true, alacritty does not show color when nvim is ran over ssh
vim.cmd [[
    highlight link TermCursor Cursor
    highlight TermCursorNC guibg=red guifg=white ctermbg=1 ctermfg=15
    highlight @boolean guifg=#ff00ff gui=bold
    highlight @comment guifg=#808080
    highlight @constant.builtin guifg=#ff00ff gui=bold
    highlight @function guifg=#a7e22e
    highlight @function.builtin guifg=#a7e22e
    highlight @function.call guifg=#a7e22e
    highlight @keyword guifg=#ff00ff gui=bold
    highlight @keyword.conditional.ternary guifg=#a9b7c5
    highlight @number guifg=#ae81ff
    highlight @operator guifg=#a9b7c5
    highlight @property guifg=#cf8823
    highlight @punctuation.bracket guifg=#a9b7c5
    highlight @punctuation.delimiter guifg=#a9b7c5
    highlight @punctuation.special guifg=#a9b7c5
    highlight @string guifg=#e6db74
    highlight @tag gui=bold guifg=#28bda4
    highlight @tag.attribute guifg=#cecece
    highlight @tag.builtin gui=bold guifg=#e8be69
    highlight @tag.delimiter guifg=#a9b7c5
    highlight @type guifg=#66d9ef
    highlight @type.builtin guifg=#20999d
    highlight @type.definition guifg=#66d9ef
    highlight @variable guifg=#cbad96
    highlight @variable.member guifg=#cf8823
    highlight cssBackgroundProp guifg=#a9b7c5
    highlight cssBorderProp guifg=#a9b7c5
    highlight cssBoxProp guifg=#a9b7c5
    highlight cssColor guifg=#FD971F
    highlight cssColorProp guifg=#a9b7c5
    highlight cssFlexibleBoxAttr guifg=#679342
    highlight cssFlexibleBoxProp guifg=#a9b7c5
    highlight cssFontAttr guifg=#679342
    highlight cssFontProp guifg=#a9b7c5
    highlight cssMediaProp guifg=#a9b7c5
    highlight cssMultiColumnAttr guifg=#679342
    highlight cssPositioningAttr guifg=#679342
    highlight cssPositioningProp guifg=#a9b7c5
    highlight cssPseudoClass guifg=#C5BE69 gui=bold
    highlight cssPseudoClassId guifg=#C5BE69 gui=bold
    highlight cssTextAttr guifg=#679342
    highlight cssTextProp guifg=#a9b7c5
    highlight cssUIAttr guifg=#679342
    highlight cssUIProp guifg=#a9b7c5
    highlight cssUnitDecorators guifg=#679342
    highlight cssValueLength guifg=#ae81ff
    highlight cssValueNumber guifg=#ae81ff
    highlight CursorLine cterm=NONE ctermbg=236 ctermfg=NONE guibg=#2a3359
    highlight Normal guibg=#1d233d
    highlight Pmenu guifg=#FFFFFF guibg=#707070
    highlight PmenuSel guifg=#000000 guibg=#909090
    highlight sassAmpersand guifg=#C5BE69 gui=bold
    highlight sassClass guifg=#C5BE69 gui=bold
    highlight sassDefinition guifg=#a9b7c5
    highlight sassProperty guifg=#a9b7c5
    highlight TelescopeSelection gui=bold guibg=White guifg=Black
    highlight TelescopeSelectionCaret guifg=Re
]]

-- white space visuals
vim.opt.list = true
vim.opt.listchars = { tab = '» ', nbsp = '␣' }


vim.o.number = true         -- Line numbers
vim.o.relativenumber = true -- Shows relative line numbers to your cursor so I can jump up or down easier
vim.o.tabstop = 4           -- Number of spaces a tab counts for
vim.o.shiftwidth = 4        -- Size of an indent

vim.o.autoindent = true
vim.o.smartindent = true

-- vim.o.expandtab = true
vim.o.expandtab = false -- using tab chars because they are required in makefiles, and I also like how the placeholder char forms a line, so I can see scope much easier


vim.o.hlsearch = true  -- Highlight search results
vim.o.incsearch = true -- Shows the match while typing

--[[ vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir" ]]
vim.o.undofile = true
vim.g.undotree_SplitWidth = 60

-- make auto save to swap file more frequent
vim.o.updatetime = 250
vim.o.signcolumn = 'yes'

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

vim.opt.inccommand = 'split'

vim.o.timeoutlen = 500
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.o.infercase = true
vim.o.wrap = false
vim.cmd('syntax enable') -- Enables syntax highlighting

-- Use system clipboard by default todo trying this out disabled to see if I like it better
-- vim.opt.clipboard = "unnamedplus"

vim.api.nvim_set_keymap('n', find_files_keymap, ':Telescope find_files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', grep_files_keymap, ':Telescope live_grep<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', grep_string_keymap, ':Telescope grep_string<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', search_buffers_keymap, ':Telescope buffers<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', search_registers_keymap, ':Telescope registers<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>sk', ':Telescope keymaps<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', open_reference_window, ':copen<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', close_reference_window, ':cclose<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', next_error, ':cnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', previous_error, ':cprev<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', undo_tree, ':UndotreeToggle<CR>', { noremap = true, silent = true })

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

-- In case grep is used in the command line, ensuring it is set to ripgrep
vim.opt.grepprg = 'rg -n $*'
vim.opt.grepformat = '%f:%l:%m,%f:%l%m,%f %l%m'

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
			'--glob', '!.git/*' -- Optionally exclude .git directory
		},
		file_ignore_patterns = {
			"node_modules",
			"%.jpg",
			"%.png",
			"%.git\\", -- Windows
			"%.git/", -- other
			"__debug_bin%", -- debug binary
		},
		layout_strategy = 'flex',
		layout_config = {
			flex = {
				flip_columns = 120 -- Adjust this value based on your preference
			},
			width = 0.95, -- Percentage of the screen width
			height = 0.95, -- Percentage of the screen height
			preview_cutoff = 120, -- When to start showing the preview pane
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

-- Treesitter setup
require('nvim-treesitter.configs').setup {
	ensure_installed = { "go", "python", "lua", "typescript", "tsx", "javascript", "vim", "vimdoc", "query", "http" }, -- Install parsers for Go and Python only
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	incremental_selection = {
		enable = true,
		init_selection = shortcut_init_selection,
		node_incremental = shortcut_node_incremental,
		node_decremental = shortcut_node_decremental
	},
	-- this was causing some strange behavor where the indent of a new line was not being respected.
	-- It was always placing my cursor at the beginning of the line regardless of indents of the current line.
	-- indent = { enable = true } -- Enable indentation
}


-- Define the 'Help' command that opens the help menu in a vertical split on the right
vim.api.nvim_create_user_command(
	'Help',                     -- Command name
	'rightbelow vert help <args>', -- Execute 'rightbelow vert help' with additional arguments
	{ nargs = '+' }             -- This command requires at least one argument
)

-- Map <Leader>h to the 'Help' command
-- vim.api.nvim_set_keymap('n', '<Leader>h', ':Help ', { noremap = true, silent = true })

-- Create a custom command 'Make' that saves the buffer and runs 'make'
vim.api.nvim_create_user_command(
	'M', -- Command name
	function()
		jeremiah.utils.SaveAll()
		vim.cmd('make')                -- Run make
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

-- Use alacritty or iterm2
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
-- 	vim.o.shell = "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe"
-- end

vim.api.nvim_set_keymap('n', '<leader>c', ':ChatGPT<CR>', { noremap = true, silent = true })


-- Debugger stuff
local dap, dapui, dapGo = require('dap'), require('dapui'), require('dap-go')
dapui.setup()
require('nvim-dap-virtual-text').setup()
dapGo.setup {
	-- Additional dap configurations can be added.
	-- dap_configurations accepts a list of tables where each entry
	-- represents a dap configuration. For more details do:
	-- :help dap-configuration
	-- dap_configurations = {
	-- 	{
	-- 		-- Must be "go" or it will be ignored by the plugin
	-- 		type = "go",
	-- 		name = "Attach remote",
	-- 		request = "launch",
	-- 		env = {      -- Set environment variables here
	-- 			TEST_MODE = "false", -- unit tests run by default
	-- 		},
	-- 	},
	-- },
	-- dap_configurations = {
	-- 	type = "go",
	-- 	name = "Debug package",
	-- 	request = "launch",
	-- 	env = load_env_vars(vim.fn.getcwd() .. "/.env.local"),
	-- 	program = "${workspaceFolder}", -- Debug the whole package/project
	-- },
	-- delve configurations
	delve = {
		-- the path to the executable dlv which will be used for debugging.
		-- by default, this is the "dlv" executable on your PATH.
		path = "dlv",
		-- time to wait for delve to initialize the debug session.
		-- default to 20 seconds
		initialize_timeout_sec = 20,
		-- a string that defines the port to start delve debugger.
		-- default to string "${port}" which instructs nvim-dap
		-- to start the process in a random available port.
		-- if you set a port in your debug configuration, its value will be
		-- assigned dynamically.
		port = "${port}",
		-- additional args to pass to dlv
		args = {},
		-- the build flags that are passed to delve.
		-- defaults to empty string, but can be used to provide flags
		-- such as "-tags=unit" to make sure the test suite is
		-- compiled during debugging, for example.
		-- passing build flags using args is ineffective, as those are
		-- ignored by delve in dap mode.
		-- avaliable ui interactive function to prompt for arguments get_arguments
		build_flags = {},
		-- whether the dlv process to be created detached or not. there is
		-- an issue on Windows where this needs to be set to false
		-- otherwise the dlv server creation will fail.
		-- avaliable ui interactive function to prompt for build flags: get_build_flags
		detached = vim.fn.has("win32") == 0,
		-- the current working directory to run dlv from, if other than
		-- the current working directory.
		cwd = nil,
	},
	-- options related to running closest test
	tests = {
		-- enables verbosity when running the test.
		verbose = false,
	},
}

-- -- These are nice but I am going to try and just use the popups since this UI takes up so much room and isn't easy to navigate with
-- open and close UI automatically when debugging starts
-- dap.listeners.after.event_initialized["dapui_config"] = function()
-- 	dapui.open()
-- end
-- dap.listeners.before.event_terminated["dapui_config"] = function()
-- 	dapui.close()
-- end
-- dap.listeners.before.event_exited["dapui_config"] = function()
-- 	dapui.close()
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

dap.configurations.go = {
	-- 	-- {
	-- 	--   type = "go",  -- Use the 'go' adapter (requires 'delve' support)
	-- 	--   name = "Debug main.go",  -- Name for your configuration
	-- 	--   request = "launch",  -- Request type: 'launch' or 'attach'
	-- 	--   program = "${file}",  -- Path to the current file being debugged
	-- 	-- },
	{
		type = "go",
		name = "Debug package",
		request = "launch",
		env = load_env_vars(vim.fn.getcwd() .. "/.env.local"),
		program = "${workspaceFolder}", -- Debug the whole package/project
	},
	-- 	-- {
	-- 	--   type = "go",
	-- 	--   name = "Attach to running process",
	-- 	--   request = "attach",
	-- 	--   processId = require'dap.utils'.pick_process,  -- Attach to a running process by ID
	-- 	-- },
}


vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '🟢', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '🟡', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '🚫', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapLogPoint', { text = '🪵', texthl = '', linehl = '', numhl = '' })

vim.api.nvim_set_keymap("n", "<Leader>du", ":lua require('dapui').toggle()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>db", ":DapToggleBreakpoint<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>dv", ":lua require('dapui').float_element('scopes', {})<CR>",
	{ noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>dw", ":lua require('dapui').float_element('watches', {})<CR>",
	{ noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>ds", ":lua require('dapui').float_element('stacks', {})<CR>",
	{ noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>dl", ":lua require('dapui').float_element('repl', {})<CR>",
	{ noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>dp", ":lua require('dapui').float_element('breakpoints', {})<CR>",
	{ noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>de", ":lua require('dapui').eval()<CR>",
	{ noremap = true, silent = true })
-- this one isn't working for some reason
-- vim.api.nvim_set_keymap("v", "<Leader>de", ":lua require('dapui').eval()<CR>",
-- 	{ noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>dl', ":lua require'dap'.set_breakpoint(nil, nil, 'Log message Hit!')<CR>",
-- 	{ noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<Leader>dB',
	':lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>dj", ":DapStepOver<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>di", ":DapStepInto<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>do", ":DapStepOut<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>dc", function()
	jeremiah.utils.SaveAll()
	vim.notify("debug continue", vim.log.levels.INFO, nil)
	dap.continue()
end)
vim.keymap.set("n", "<Leader>dr", function()
	jeremiah.utils.SaveAll()
	vim.notify("restarting last debug session", vim.log.levels.INFO, nil)
	dap.restart()
end)
vim.keymap.set("n", "<Leader>dt", function()
	jeremiah.utils.SaveAll()
	dapGo.debug_test()
end)
-- vim.api.nvim_set_keymap('n', '<Leader>dt', ':lua require("dap-go").debug_test()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>dR", ":lua require('dapui').open({reset = true})<CR>",
	{ noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dq', ':DapTerminate<CR>', { noremap = true, silent = true })

-- vim.api.nvim_set_keymap('n', '<Leader>lp',
-- -- Read inspect variable values
-- -- vim.api.nvim_set_keymap('n', '<Leader>R', ':lua require("dap").repl.open()<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<Leader>R', function() require('dap').repl.open() end)


-- vim.api.nvim_set_keymap('n', '<Leader>rt', ':lua require("dap").run_last()<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<Leader>hr', ':Rest run<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>hl', ':Rest last<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>hc', ':Rest cookies<CR>', { noremap = true, silent = true })


-- Clear current pattern
vim.api.nvim_set_keymap('n', '<leader>/', ':nohlsearch<CR>', { noremap = true, silent = true })
