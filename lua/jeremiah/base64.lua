local M = {}

local runner_override

local function run_base64_toggle(input)
    if runner_override then
        return runner_override(input)
    end

    local executable = 'base64-toggle'
    if vim.fn.executable(executable) ~= 1 then
        vim.notify('base64-toggle is not installed. Install from: https://codeberg.org/jeremiahvaughan/base64-toggle', vim.log.levels.ERROR)
        return nil
    end

    local output = vim.fn.system({ executable }, input)
    if vim.v.shell_error ~= 0 then
        vim.notify('base64-toggle base64 failed: ' .. output, vim.log.levels.ERROR)
        return nil
    end

    return output
end


function M.toggle_visual_selection_base64()
    local previous_selection = vim.fn.getreg('"')

    vim.cmd('normal! "vy')
    local selected_text = vim.fn.getreg('v')

    local transformed = run_base64_toggle(selected_text)
    if not transformed then
        vim.fn.setreg('"', previous_selection)
        return
    end

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
