local M = {}

local function toggle_diff_mode()
    local win1 = vim.fn.win_getid(1)
    local win2 = vim.fn.win_getid(2)

    local is_diff = vim.api.nvim_win_get_option(win1, 'diff')
        and vim.api.nvim_win_get_option(win2, 'diff')

    if is_diff then
        vim.api.nvim_win_call(win1, function() vim.cmd('diffoff') end)
        vim.api.nvim_win_call(win2, function() vim.cmd('diffoff') end)
    else
        vim.api.nvim_win_call(win1, function() vim.cmd('diffthis') end)
        vim.api.nvim_win_call(win2, function() vim.cmd('diffthis') end)
    end
end

vim.keymap.set('n', '<leader>d', toggle_diff_mode, { desc = 'Toggle diff mode for 2 vertical splits' })

return M
