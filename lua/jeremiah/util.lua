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

function M.FindWindowForBuffer(buf)
    for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
            if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == buf then
                return { tab = tab, win = win }
            end
        end
    end
    return nil
end

function M.FocusBufferInTab(buf)
    local location = M.FindWindowForBuffer(buf)
    if location then
        vim.api.nvim_set_current_tabpage(location.tab)
        vim.api.nvim_set_current_win(location.win)
    else
        vim.cmd('tabnew')
        vim.api.nvim_set_current_buf(buf)
    end
end

local TERMINAL_KIND_VAR = 'terminal_kind'

function M.FindTerminalBuffer(kind)
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) then
            local ok, buf_value = pcall(vim.api.nvim_buf_get_var, buf, TERMINAL_KIND_VAR)
            if ok and buf_value == kind then
                return buf
            end
        end
    end
    return nil
end

function M.OpenTerminalTabKind(command, kind)
    vim.cmd('tabnew')
    if command and command ~= '' then
        vim.cmd('te ' .. command)
    else
        vim.cmd('term')
    end
    vim.b[TERMINAL_KIND_VAR] = kind
end

return M
