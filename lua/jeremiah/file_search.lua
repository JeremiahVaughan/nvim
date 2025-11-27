local M = {}

vim.api.nvim_create_user_command('Fd', function(opts)
    local pattern = opts.args
    local files = vim.fn.systemlist('fd -u ' .. pattern)
    vim.fn.setqflist({}, ' ', {
        title = 'fd ' .. pattern,
        items = vim.tbl_map(function(f)
            return { filename = f }
        end, files)
    })
    vim.cmd('copen')
end, { nargs = 1 })

return M
