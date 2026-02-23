local M = {
    {
        "nvim-treesitter/nvim-treesitter",
		branch = "main",
        build = ":TSUpdate",
        lazy = false,
        dependencies = {
            -- "nvim-treesitter/playground",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
        },
        config = function()
            local cmp = require("cmp")
            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            cmp.setup({
                sources = {
                    { name = "path" },
                    -- { name = "nvim_lua" },
                    -- { name = "luasnip", keyword_length = 2 },
                    { name = "buffer", keyword_length = 3 },
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                    ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
                    ["<Tab>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                }),
                snippet = {
                    expand = function(args)
                        -- Requires Neovim v0.10+ for vim.snippet
                        vim.snippet.expand(args.body)
                    end,
                },
            })

            require("nvim-treesitter.config").setup({
                modules = {},
                auto_install = true,
                sync_install = false,
                ignore_install = {},
                highlight = {
                    enable = true,
                    disable = {},
                    additional_vim_regex_highlighting = false,
                },
                incremental_selection = {
                    enable = true,
                    init_selection = "gnn",
                    node_incremental = "grn",
                    node_decremental = "grm",
                },
            })

            -- The new nvim-treesitter rewrite does not auto-enable highlights.
            -- Attach the Treesitter highlighter for every FileType so the `@`
            -- highlight groups from colors.lua are actually used (fallback is
            -- legacy Vim syntax).
            local ts_group = vim.api.nvim_create_augroup("JeremiahTreesitter", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                group = ts_group,
                pattern = "*",
                callback = function(args)
                    pcall(vim.treesitter.start, args.buf)
                end,
            })
        end,
    },
}




return M
