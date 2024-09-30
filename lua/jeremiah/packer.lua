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
		"rest-nvim/rest.nvim",
	},
	{
		"leoluz/nvim-dap-go",
		dependencies = {
			-- delv must be installed (see README.md)
			"mfussenegger/nvim-dap",
		},
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio"
		},
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
	},
	{
		"jackMort/ChatGPT.nvim",
		event = "VeryLazy",
		config = function()
			require("chatgpt").setup({
				-- this config assumes you have OPENAI_API_KEY environment variable set
				show_line_numbers = true,
				chat = {
					welcome_message = "",
					keymaps = {
						close = "<C-c>",
						yank_last = "<C-y>",
						yank_last_code = "<C-k>",
						scroll_up = "<C-u>",
						scroll_down = "<C-d>",
						new_session = "<C-n>",
						cycle_windows = "<Tab>",
						cycle_modes = "<C-f>",
						next_message = "<C-j>",
						prev_message = "<C-k>",
						select_session = "<Space>",
						rename_session = "r",
						delete_session = "d",
						draft_message = "<C-z>",
						edit_message = "e",
						delete_message = "d",
						toggle_settings = "<C-o>",
						toggle_sessions = "<C-p>",
						toggle_help = "<C-b>",
						toggle_message_role = "<C-z>",
						toggle_system_role_open = "<C-s>",
						stop_generating = "<C-x>",
					},
				},
				popup_window = {
					border = {
						highlight = "Normal",
						style = "rounded",
						text = {
							top = "",
						},
					},
				},
				popup_input = {
					prompt = "  ",
					border = {
						highlight = "Normal",
						style = "rounded",
						text = {
							top_align = "center",
							top = "",
						},
					},
					win_options = {
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
					},
					submit = "<C-Enter>",
					submit_n = "<Enter>",
					max_visible_lines = 20,
				},
				popup_layout = {
					default = "right",
					center = {
						width = "40%",
						height = "100%",
					},
					right = {
						width = "30%",
						width_settings_open = "50%",
					},
				},
				openai_params = {
					-- NOTE: model can be a function returning the model name
					-- this is useful if you want to change the model on the fly
					-- using commands
					-- Example:
					-- model = function()
					--     if some_condition() then
					--         return "gpt-4-1106-preview"
					--     else
					--         return "gpt-3.5-turbo"
					--     end
					-- end,
					max_tokens = 4095,
					model = "gpt-4o-mini",
				}
			})
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim"
		}
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
	{ -- Autoformat that is smarter and more effecient than the lsp formatters
		'stevearc/conform.nvim',
		lazy = false,
		keys = {
			{
				'<leader>f',
				function()
					require('conform').format { async = true, lsp_fallback = true }
				end,
				mode = '',
				desc = '[F]ormat buffer',
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = { c = true, cpp = true }
				return {
					timeout_ms = 500,
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				}
			end,
			formatters_by_ft = {
				lua = { 'stylua' },
				-- Conform can also run multiple formatters sequentially
				python = { "isort", "black" },
				--
				-- You can use a sub-list to tell conform to run *until* a formatter
				-- is found.
				javascript = { { "prettierd", "prettier" } },
			},
		},
	},
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		dependencies = {
			--- Uncomment the two plugins below if you want to manage the language servers from neovim
			{ 'williamboman/mason.nvim' },
			{ 'williamboman/mason-lspconfig.nvim' },

			{ 'neovim/nvim-lspconfig' },
			{ 'hrsh7th/nvim-cmp' },
			{ 'hrsh7th/cmp-nvim-lsp' },
			{ 'L3MON4D3/LuaSnip' },
		}
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
		'nvim-treesitter/nvim-treesitter',
	},
	'nvim-treesitter/playground',
	'mbbill/undotree',
	'williamboman/mason.nvim',
	'williamboman/mason-lspconfig.nvim',
	'neovim/nvim-lspconfig',
	-- auto-completion stuff
	'hrsh7th/nvim-cmp',
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-path',
	'saadparwaiz1/cmp_luasnip',
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-nvim-lua',
	'L3MON4D3/LuaSnip',
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
	-- leet code stuff
	{
		"kawre/leetcode.nvim",
		build = ":TSUpdate html",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim", -- required by telescope
			"MunifTanjim/nui.nvim",

			-- optional
			"nvim-treesitter/nvim-treesitter",
			"rcarriga/nvim-notify",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			-- configuration goes here
		},
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" }
	}
})
