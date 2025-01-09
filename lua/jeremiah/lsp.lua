-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig = require('lspconfig')
local lspconfig_defaults = lspconfig.util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lspconfig_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)


vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = { buffer = event.buf }

        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.api.nvim_set_keymap('n', 'gi', ':Telescope lsp_implementations<CR>', { noremap = true, silent = true })
        vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol, opts)
        vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', '<leader>vca', vim.lsp.buf.code_action, opts)
        vim.api.nvim_set_keymap('n', 'gr', ':Telescope lsp_references<CR>', { noremap = true, silent = true })
        vim.keymap.set('n', 'gR', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>f', vim.lsp.buf.format, opts)
    end,
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
    sources = {
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'luasnip', keyword_length = 2 },
        { name = 'buffer',  keyword_length = 3 },
    },
    -- formatting = lsp_zero.cmp_format({ details = false }),
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
    -- snippet = {
    --     expand = function(args)
    --         require('luasnip').lsp_expand(args.body)
    --     end,
    -- },
    snippet = {
        expand = function(args)
            -- You need Neovim v0.10 to use vim.snippet
            vim.snippet.expand(args.body)
        end,
    },
})



local project_type = vim.fn.getenv("NVIM_PROJECT_TYPE")
-- supported options:
-- 1. personal
-- 2. work
-- 3. server
-- 4. leetcode

local ensure_installed_lsp = {}
local ensure_installed_treesitter = {}

if project_type == "work" then
    ensure_installed_lsp = { "gopls", "lua_ls", "pyright", "ts_ls", "eslint" }
    ensure_installed_treesitter = { "markdown", "markdown_inline", "go", "python", "lua", "typescript", "tsx",
        "javascript", "vim", "vimdoc",
        "query", "http" }
elseif project_type == "server" then
    -- no lsps
    -- no parsers
elseif project_type == "leetcode" then
    -- no lsps
    ensure_installed_treesitter = { "go" }
else
    -- personal and default
    ensure_installed_lsp = { "gopls", "lua_ls" }
    ensure_installed_treesitter = { "markdown", "markdown_inline", "go", "lua", "javascript", "vim", "vimdoc", "query",
        "http" }
end

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



-- Mason setup
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = ensure_installed_lsp,
    automatic_installation = true,
    handlers = {
        -- lsp_zero.default_setup,
        lua_ls = function()
            -- local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup({})
        end,
        gopls = function() -- Custom handler for gopls
            local gopls_opts = {
                settings = {
                    gopls = {
                        analyses = {
                            -- ref: https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
                            unusedparams = true,
                            shadow = true,
                            unusedvariable = true,
                            unusedwrite = true,
                            useany = true,
                        },
                        completeUnimported = true,
                        usePlaceholders = false, -- disabling because it is not working properly
                        staticcheck = true,      -- ref: https://github.com/dominikh/go-tools?tab=readme-ov-file
                    },
                },
            }
            -- Use lspconfig to setup gopls with the defined options
            require('lspconfig').gopls.setup(gopls_opts)
        end,
    }
})

-- Function to configure servers
local function setup_server(server_name)
    lspconfig[server_name].setup({
        on_init = function(client)
            -- Disable the semantic tokens provider
            client.server_capabilities.semanticTokensProvider = nil -- this prevents lsps from trying to format on top of my existing treesitter color scheme
        end,
        -- Add additional configuration here if needed
    })
end

for _, server in ipairs(ensure_installed_lsp) do
    setup_server(server)
end


cmp.setup.filetype({ 'sql' }, {
    sources = {
        { name = 'vim-dadbod-completion' },
        { name = 'buffer' },
    },
})
