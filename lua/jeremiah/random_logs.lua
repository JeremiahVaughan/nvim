local M = {}

local runner_override

local function run_random_string(length)
    if runner_override then
        return runner_override(length)
    end

    local executable = vim.loop.os_homedir() .. '/go/bin/nvim-helper'
    if vim.fn.executable(executable) ~= 1 then
        vim.notify('nvim-helper is not installed. See README for installation steps.', vim.log.levels.ERROR)
        return nil
    end

    local output = vim.fn.system({ executable, 'random-string', tostring(length) })
    if vim.v.shell_error ~= 0 then
        vim.notify('nvim-helper random-string failed: ' .. output, vim.log.levels.ERROR)
        return nil
    end

    return output:gsub('%s+$', '')
end

function M.insert_todo_log()
    local random_str = run_random_string(5)
    if not random_str then
        return
    end

    local line = 'log.Printf("todo remove ' .. random_str .. '")'
    vim.api.nvim_put({ line }, 'c', true, true)
end

function M.insert_random_string()
    local random_str = run_random_string(5)
    if not random_str then
        return
    end

    vim.api.nvim_put({ random_str }, 'c', true, true)
end

function M._set_runner_override(fn)
    runner_override = fn
end

vim.keymap.set('n', '<leader>i', M.insert_todo_log, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>r', M.insert_random_string, { noremap = true, silent = true })

return M
