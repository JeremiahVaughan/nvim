-- Adding shortcut to save current file and open 1password
vim.api.nvim_set_keymap('n', '<leader>p', ':lua ToggleOnePasswordTerminal()<CR>', { noremap = true, silent = true })

-- Function to find the terminal buffer labeled as "1password"
function FindOnePasswordTerminalBuffer()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.b[buf].is_1password_terminal then
            return buf
        end
    end
    return nil
end

-- Function to open a new terminal buffer and run the server
function OpenOnePasswordTerminal()
    -- Open a new buffer and start a terminal
    vim.cmd('te one-password-tui')
    vim.b.is_1password_terminal = true
end

function ToggleOnePasswordTerminal()
    jeremiah.utils.SaveAll()
    local buf = FindOnePasswordTerminalBuffer()
    if buf then
        vim.api.nvim_set_current_buf(buf)
    else
        OpenOnePasswordTerminal()
    end
end
