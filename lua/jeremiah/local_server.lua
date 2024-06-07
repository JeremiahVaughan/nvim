-- Key mapping to toggle (start/restart) the server
vim.api.nvim_set_keymap('n', '<leader>rt', ':lua ToggleServer()<CR>', { noremap = true, silent = true })

-- Function to open a new terminal buffer and run the server
function OpenServerTerminal()
    -- Open a new buffer and start a terminal
    vim.cmd('term')
    -- Label this terminal buffer as "server"
    vim.b.is_server_terminal = true
    -- Run the server command
    vim.cmd('call jobsend(b:terminal_job_id, "make b\\<CR>")')
end

--
-- Function to restart the server
function RestartServer(buf)
    -- Navigate to the terminal buffer
    vim.api.nvim_set_current_buf(buf)
    -- Send Ctrl+C to stop the server
    vim.cmd('call jobsend(b:terminal_job_id, "\\<C-c>")')
    -- Clear the terminal
    vim.cmd('call jobsend(b:terminal_job_id, "clear\\<CR>")')
    -- Run the server command
    vim.cmd('call jobsend(b:terminal_job_id, "make b\\<CR>")')
end

-- Function to find the terminal buffer labeled as "server"
function FindServerTerminalBuffer()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.b[buf].is_server_terminal then
            return buf
        end
    end
    return nil
end

-- Function to toggle the server state (start or restart)
function ToggleServer()
    vim.cmd('write') -- saving changes so they are in play when the server is launched

    local buf = FindServerTerminalBuffer()
    if buf then
        -- Server is running, so restart it
        RestartServer(buf)
    else
        -- Server is not running, so start it
        OpenServerTerminal()
    end
end
