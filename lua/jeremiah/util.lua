local M = {}

function M.SaveAll()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
            local name = vim.api.nvim_buf_get_name(buf)
            local buftype = vim.api.nvim_get_option_value('buftype', { buf = buf })
            local filetype = vim.api.nvim_get_option_value('filetype', { buf = buf })
            local modified = vim.api.nvim_get_option_value('modified', { buf = buf })
            local modifiable = vim.api.nvim_get_option_value('modifiable', { buf = buf })
            if name ~= ""
                and modified
                and modifiable
                and buftype ~= 'terminal'
                and filetype ~= 'oil'
            then
                vim.api.nvim_buf_call(buf, function()
                    vim.cmd('silent write')
                end)
            end
        end
    end
end

return M
