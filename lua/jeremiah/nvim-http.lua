vim.filetype.add({
    extension = {
        http = "http", -- Files with `.http` extension will have `http` filetype
    },
})

local client = vim.lsp.start_client {
    name = "nvim_http",
    cmd = { "/Users/jeremiahvaughan/git_tool_data/efforts/lsp-from-scratch/nvim-http/main" },
    on_attach = function()
        print("im attaced")
    end
}

if not client then
    vim.notify("error, could not locate the nvim-http client", vim.log.levels.ERROR)
    return
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "http",
    callback = function()
        vim.lsp.buf_attach_client(0, client)
    end,
})
