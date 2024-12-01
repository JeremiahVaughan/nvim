vim.filetype.add({
    extension = {
        http = "http", -- Files with `.http` extension will have `http` filetype
    },
})

local client = vim.lsp.start_client {
    name = "http_lsp",
    cmd = { "http-lsp" },
    on_attach = function()
        -- todo keybinds here
    end
}

if not client then
    vim.notify("error, could not locate the http-lsp client", vim.log.levels.ERROR)
    return
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "http",
    callback = function()
        vim.lsp.buf_attach_client(0, client)
    end,
})
