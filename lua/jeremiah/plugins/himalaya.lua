local M = {
    {
        "pimalaya/himalaya-vim",
        config = function()
            -- Configuration for himalaya-vim
            -- It is highly recommended to have these options on:
            -- syntax on
            -- filetype plugin on
            -- set hidden
            -- (These are usually default in Neovim)

            -- You can customize the account/folder picker if you have telescope installed
            vim.g.himalaya_account_picker = "telescope"
            vim.g.himalaya_folder_picker = "telescope"
        end,
    },
}

return M
