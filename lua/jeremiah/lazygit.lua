-- Adding shortcut to save current file and open lazygit
vim.api.nvim_set_keymap('n', '<leader>gg', ':lua ToggleLazyGitTerminal()<CR>', { noremap = true, silent = true })

-- Function to open a new terminal buffer and run the server
function OpenLazyGitTerminal()
    jeremiah.utils.OpenTerminalTabKind('lazygit', 'lazygit')
end

function ToggleLazyGitTerminal()
    jeremiah.utils.SaveAll()
    local buf = jeremiah.utils.FindTerminalBuffer('lazygit')
    if buf then
        jeremiah.utils.FocusBufferInTab(buf)
    else
        OpenLazyGitTerminal()
    end
end
