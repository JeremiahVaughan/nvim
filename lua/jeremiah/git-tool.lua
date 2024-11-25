vim.api.nvim_set_keymap('n', '<leader>g', ':lua ToggleGitToolTerminal()<CR>', { noremap = true, silent = true })
function FindGitToolTerminalBuffer()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.b[buf].is_git_tool_terminal then
            return buf
        end
    end
    return nil
end

function OpenGitToolTerminal()
    vim.cmd('te git-tool')
    vim.b.is_git_tool_terminal = true
end

function ToggleGitToolTerminal()
    jeremiah.utils.SaveAll()
    local buf = FindGitToolTerminalBuffer()
    if buf then
        vim.api.nvim_set_current_buf(buf)
    else
        OpenGitToolTerminal()
    end
end
