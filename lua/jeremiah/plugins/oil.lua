local M = {
    {
        "stevearc/oil.nvim",
        lazy = false,
        dependencies = {
            { "echasnovski/mini.icons", opts = {} },
        },
        config = function()
            require("jeremiah.oil")
        end,
    },
}

return M
