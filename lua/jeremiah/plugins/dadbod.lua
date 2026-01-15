local M = {
    {
        "tpope/vim-dadbod",
        dependencies = {
            { "kristijanhusak/vim-dadbod-completion" },
            { "kristijanhusak/vim-dadbod-ui" },
        },
    },
}

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "dbui", "dbout" },
    callback = function()
        vim.opt_local.winfixbuf = true
    end,
})

return M
