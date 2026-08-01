local base64 = require('jeremiah.base64')

local M = {}

local function with_scratch_buffer(fn)
    local buf = vim.api.nvim_create_buf(true, true)
    local prev_buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_set_current_buf(buf)

    local ok, err = pcall(fn, buf)

    vim.api.nvim_set_current_buf(prev_buf)
    vim.api.nvim_buf_delete(buf, { force = true })

    if not ok then
        error(err)
    end
end

function M.replace_visual_selection_with_transformed_text()
    base64._set_runner_override(function(input)
        return string.upper(input)
    end)

    with_scratch_buffer(function(buf)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, { 'hello world' })

        vim.cmd('normal! 0')
        vim.cmd('normal! viw')

        base64.toggle_visual_selection_base64()

        local line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1]
        assert(line == 'HELLO world', string.format('expected "HELLO world", got %q', line))
    end)

    base64._set_runner_override(nil)
end

return M
