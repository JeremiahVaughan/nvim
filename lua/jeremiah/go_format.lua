local go_format_group = vim.api.nvim_create_augroup('GoFormat', { clear = true })

vim.api.nvim_create_autocmd('BufWritePost', {
    group = go_format_group,
    pattern = '*.go',
    callback = function()
        -- Run gofmt on the current file
        local file = vim.fn.expand('%:p')
        vim.fn.system('gofmt -w ' .. vim.fn.shellescape(file))
        
        -- Reload the file to see changes
        vim.cmd('checktime')
    end,
})
