function IsTerminalBuffer(buf)
    local buftype = vim.api.nvim_get_option_value('buftype', { buf = buf })
    return buftype == 'terminal'
end
