local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }


cmp.setup({
    sources = {
        { name = 'path' },
        -- { name = 'nvim_lua' },
        -- { name = 'luasnip', keyword_length = 2 },
        { name = 'buffer',  keyword_length = 3 },
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
    snippet = {
        expand = function(args)
            -- You need Neovim v0.10 to use vim.snippet
            vim.snippet.expand(args.body)
        end,
    },
})


-- Treesitter setup
require('nvim-treesitter.configs').setup({
    modules = {},
    auto_install = true,
    sync_install = false,
    ignore_install = {},
    ensure_installed = ensure_installed_treesitter,
    highlight = {
        enable = true,
        disable = {},
        additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
        enable = true,
        init_selection = "gnn",
        node_incremental = "grn",
        node_decremental = "grm"
    },
    -- this was causing some strange behavor where the indent of a new line was not being respected.
    -- It was always placing my cursor at the beginning of the line regardless of indents of the current line.
    -- indent = { enable = true } -- Enable indentation
})



