local M = {}

local oil = require("oil")

oil.setup({
    view_options = {
        show_hidden = true,
    },
    keymaps = {
        ["<C-h>"] = false,
    },
    columns = { "icon" },
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<space>-", oil.toggle_float)

return M
