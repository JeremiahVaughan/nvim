local M = {}

local runner_override

-- Toggle the selection between Base64 encoded and decoded states via the b64flip CLI.
local function log_message(message)
    vim.api.nvim_echo({ { tostring(message), 'None' } }, true, {})
end

local function run_b64flip(input)
    if runner_override then
        return runner_override(input)
    end

    local executable = vim.g.b64flip_command or 'b64flip'
    if vim.fn.executable(executable) ~= 1 then
        vim.notify('b64flip is not installed. See README for installation steps.', vim.log.levels.ERROR)
        return nil
    end

    local output = vim.fn.system({ executable }, input)
    if vim.v.shell_error ~= 0 then
        vim.notify('b64flip failed: ' .. output, vim.log.levels.ERROR)
        return nil
    end

    return output
end


function M.toggle_visual_selection_base64()
    local previous_selection = vim.fn.getreg('"')

    vim.cmd('normal! "vy')
    local selected_text = vim.fn.getreg('v')

    local transformed = run_b64flip(selected_text)
    if not transformed then
        vim.fn.setreg('"', previous_selection)
        return
    end

    transformed = transformed:gsub('\r?\n$', '')

    vim.fn.setreg('v', transformed, 'v')
    vim.cmd('normal! gv"vp')

    vim.fn.setreg('"', previous_selection)
end

function M._set_runner_override(fn)
    runner_override = fn
end

vim.keymap.set('v', '<leader>b', M.toggle_visual_selection_base64, {
    noremap = true,
    silent = true,
    desc = 'Toggle Base64 encoding for highlighted text',
})

return M
