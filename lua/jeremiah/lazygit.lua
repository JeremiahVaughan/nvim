-- Adding shortcut to save current file and open lazygit
vim.api.nvim_set_keymap('n', '<leader>lg', ':lua ToggleLazyGitTerminal()<CR>', { noremap = true, silent = true })

-- Function to find the terminal buffer labeled as "lazygit"
function FindLazygitTerminalBuffer()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.b[buf].is_lazygit_terminal then
            return buf
        end
    end
    return nil
end

-- Function to open a new terminal buffer and run the server
function OpenLazygitTerminal()
    -- Open a new buffer and start a terminal
    vim.cmd('te lazygit')
    vim.b.is_lazygit_terminal = true
end

function ToggleLazyGitTerminal()
    jeremiah.utils.SaveAll()
    local buf = FindLazygitTerminalBuffer()
    if buf then
        vim.api.nvim_set_current_buf(buf)
    else
        OpenLazygitTerminal()
    end
end
