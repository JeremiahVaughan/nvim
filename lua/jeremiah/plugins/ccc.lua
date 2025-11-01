local M = {
    {
        "uga-rosa/ccc.nvim",
        lazy = false,
        config = function()
            local ccc = require("ccc")

            vim.api.nvim_set_keymap("i", "<C-c>", "<Plug>(ccc-insert)", { noremap = false, silent = true })
            vim.api.nvim_set_keymap("v", "<C-s>", "<Plug>(ccc-select-color)", { noremap = false, silent = true })

            ccc.setup({
                highlighter = {
                    auto_enable = true,
                    lsp = true,
                },
            })
        end,
    },
}

return M
