local M = {}

local SEPARATOR = "────────────────────────────────────────────────────────"
local SEPARATOR_END = "────────────────────────────────────────────────────────"

local function get_visual_selection()
    local buf = vim.api.nvim_get_current_buf()
    local start_pos = vim.api.nvim_buf_get_mark(buf, "<")
    local end_pos = vim.api.nvim_buf_get_mark(buf, ">")
    if not start_pos or not end_pos then
        return ""
    end
    local start_row = math.min(start_pos[1], end_pos[1])
    local end_row = math.max(start_pos[1], end_pos[1])
    local first_col = (start_pos[1] <= end_pos[1]) and start_pos[2] or end_pos[2]
    local last_col = (start_pos[1] <= end_pos[1]) and end_pos[2] or start_pos[2]

    local lines = vim.api.nvim_buf_get_lines(buf, start_row - 1, end_row, false)
    if #lines == 0 then
        return ""
    end

    local col_start = math.min(first_col, last_col) + 1
    local col_end = math.max(first_col, last_col) + 1

    local parts = {}
    for i, line in ipairs(lines) do
        local first, last = (i == 1), (i == #lines)
        local s, e
        if first and last then
            s = col_start
            e = math.min(col_end, #line)
        elseif first then
            s = first_col + 1
            e = #line
        elseif last then
            s = 1
            e = math.min(last_col + 1, #line)
        else
            s = 1
            e = #line
        end
        table.insert(parts, line:sub(s, e))
    end
    local selected = table.concat(parts, "\n")
    return selected:match("^%s*(.-)%s*$") or selected
end

local function execute_and_append()
    local command = get_visual_selection()
    if command == "" then
        vim.notify("Visual command: selection is empty", vim.log.levels.WARN)
        return
    end

    local output = vim.fn.system(command)
    local exit_code = vim.v.shell_error

    output = output:gsub("\r\n", "\n"):gsub("\r", "\n")
    if output:match("\n$") then
        output = output:sub(1, -2)
    end

    local buf = vim.api.nvim_get_current_buf()
    local line_count = vim.api.nvim_buf_line_count(buf)
    local modifiable = vim.api.nvim_get_option_value("modifiable", { buf = buf })
    if not modifiable then
        vim.notify("Visual command: buffer is not modifiable", vim.log.levels.ERROR)
        return
    end

    local command_lines = {}
    for line in (command .. "\n"):gmatch("(.-)\n") do
        table.insert(command_lines, "| " .. line)
    end
    if #command_lines == 0 and command ~= "" then
        table.insert(command_lines, "| " .. command)
    end

    local header = {
        "",
        SEPARATOR,
        "command:",
    }
    vim.list_extend(header, command_lines)
    vim.list_extend(header, {
        "exit_code: " .. tostring(exit_code),
        "output:",
    })
    local output_lines = {}
    for line in (output .. "\n"):gmatch("(.-)\n") do
        table.insert(output_lines, line)
    end
    if #output_lines == 0 and output ~= "" then
        table.insert(output_lines, output)
    end
    local footer = { SEPARATOR_END, "" }

    local lines = vim.tbl_flatten({ header, output_lines, footer })
    vim.api.nvim_buf_set_lines(buf, line_count, line_count, false, lines)
end

vim.keymap.set("v", "<leader>xc", execute_and_append, {
    noremap = true,
    silent = true,
    desc = "Execute visually selected command and append output to buffer",
})

return M
