-- Adding shortcut to save current file and open resource_monitor
vim.api.nvim_set_keymap('n', '<leader>r', ':lua ToggleResourceMonitorTerminal()<CR>', { noremap = true, silent = true })

-- Function to find the terminal buffer labeled as "resource_monitor"
function FindResourceMonitorTerminalBuffer()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.b[buf].is_resource_monitor_terminal then
            return buf
        end
    end
    return nil
end

-- Function to open a new terminal buffer and run the server
function OpenResourceMonitorTerminal()
    if vim.loop.os_uname().sysname == "Windows_NT" then
        vim.cmd('te ntop')
    else
        vim.cmd('te htop')
    end
    -- Open a new buffer and start a terminal
    vim.b.is_resource_monitor_terminal = true
end

function ToggleResourceMonitorTerminal()
    jeremiah.utils.SaveAll()
    local buf = FindResourceMonitorTerminalBuffer()
    if buf then
        vim.api.nvim_set_current_buf(buf)
    else
        OpenResourceMonitorTerminal()
    end
end
