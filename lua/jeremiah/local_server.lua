-- Key mapping to toggle (start/restart) the server
vim.api.nvim_set_keymap('n', '<leader>rt', ':lua ToggleServer("b")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>rr', ':lua ToggleServer("r")<CR>', { noremap = true, silent = true })

-- Function to open a new terminal buffer and run the server
function OpenServerTerminal(label)
    -- Open a new buffer and start a terminal
    vim.cmd('term')
    -- Label this terminal buffer as "server"
    vim.b.term_id = label
    RunStartServer(label)
end

function RunStartServer(label)
    local commandString = "\"make " .. label .. "\\<CR>\""
    vim.cmd('call jobsend(b:terminal_job_id, ' .. commandString .. ')')
end

--
-- Function to restart the server
function RestartServer(buf, label)
    -- Navigate to the terminal buffer
    vim.api.nvim_set_current_buf(buf)
    -- Send Ctrl+C to stop the server
    vim.cmd('call jobsend(b:terminal_job_id, "\\<C-c>")')
    -- Run the server command
    RunStartServer(label)
end

-- Function to find the terminal buffer labeled as "server"
function FindServerTerminalBuffer(label)
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) then
            local success, buf_label = pcall(vim.api.nvim_buf_get_var, buf, 'term_id')
            if success and buf_label == label then
                return buf
            end
        end
    end
    return nil
end

local function is_terminal_buffer(buf)
    local buftype = vim.api.nvim_get_option_value('buftype', { buf = buf })
    return buftype == 'terminal'
end

-- Function to toggle the server state (start or restart)
function ToggleServer(label)
    local currentBuf = vim.api.nvim_get_current_buf()
    if not is_terminal_buffer(currentBuf) then
        vim.cmd('write') -- saving changes so they are in play when the server is launched
    end

    local buf = FindServerTerminalBuffer(label)
    if buf then
        -- Server is running, so restart it
        RestartServer(buf, label)
    else
        -- Server is not running, so start it
        OpenServerTerminal(label)
    end
end
