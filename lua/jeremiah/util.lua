local M = {}

function M.IsTerminalBuffer(buf)
    local buftype = vim.api.nvim_get_option_value('buftype', { buf = buf })
    return buftype == 'terminal'
end

function M.SaveAll()
    local currentBuf = vim.api.nvim_get_current_buf()
    if not M.IsTerminalBuffer(currentBuf) and vim.api.nvim_buf_get_name(currentBuf) ~= "" then
        vim.cmd('wa') -- saving changes so they are in play when the server is launched
    end
end

return M
