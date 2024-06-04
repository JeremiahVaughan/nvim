-- Function to read file content
local function read_file(file_path)
    local file = io.open(file_path, "r")
    if not file then return nil end
    local content = file:read("*a")
    file:close()
    return content
end

-- Function to insert content at cursor position
local function insert_at_cursor(content)
    if not content then return end
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local lines = vim.split(content, "\n")
    vim.api.nvim_buf_set_lines(0, row, row, false, lines)
    vim.api.nvim_win_set_cursor(0, { row + #lines, col })
end

-- Function to read file and insert its content at cursor position
local function read_file_and_insert(file_path)
    local content = read_file(file_path)
    insert_at_cursor(content)
end

-- Create a custom command to insert file content
vim.api.nvim_create_user_command(
    'InsertFile',
    function(opts)
        read_file_and_insert(opts.args)
    end,
    { nargs = 1, complete = 'file' }
)


