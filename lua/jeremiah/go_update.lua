local M = {}

local function resolve_target_version()
    local version = vim.g.go_update_target_version
    if version == nil or version == '' then
        return '1.25.7'
    end
    return tostring(version)
end

local function resolve_target_alpine_version()
    local version = vim.g.go_update_target_alpine_version
    if version == nil or version == '' then
        return '3.22'
    end
    return tostring(version)
end


local function collect_paths(raw_output)
    local paths = {}
    local lines = vim.split(raw_output or '', '\n', { trimempty = true })
    for _, line in ipairs(lines) do
        local trimmed = vim.trim(line)
        if trimmed ~= '' then
            table.insert(paths, trimmed)
        end
    end
    return paths
end

local function describe_path(path, version)
    local name = path:match('([^/\\]+)$') or path
    if name == 'go.mod' then
        return ('go.mod updated to Go %s'):format(version)
    end
    if name:find('Dockerfile', 1, true) then
        return ('Dockerfile golang tag updated to %s'):format(version)
    end
    return ('Updated to Go %s'):format(version)
end

function M.run()
    local version = resolve_target_version()
    local alpineVersion = resolve_target_alpine_version()
    local command = { 'nvim-helper', 'go-update', '--version', version, '--alpine-version', alpineVersion}

    local raw_output = vim.fn.system(command)
    local exit_code = vim.v.shell_error

    if exit_code ~= 0 then
        local message = vim.trim(raw_output)
        if message == '' then
            message = ('nvim-helper go-update failed with exit code %d'):format(exit_code)
        end
        vim.notify(message, vim.log.levels.ERROR)
        return
    end

    local paths = collect_paths(raw_output)
    if #paths == 0 then
        vim.notify('nvim-helper go-update completed but returned no paths.', vim.log.levels.WARN)
        vim.fn.setqflist({}, 'r')
        return
    end

    local qf = {}
    for _, path in ipairs(paths) do
        table.insert(qf, {
            filename = path,
            lnum = 1,
            col = 1,
            text = describe_path(path, version),
        })
    end

    vim.fn.setqflist(qf, 'r')
    vim.cmd('copen')
    vim.notify(('Go update touched %d files (target %s)'):format(#qf, version), vim.log.levels.INFO)
end

vim.api.nvim_create_user_command('GoUpdate', function()
    jeremiah.utils.SaveAll()
    M.run()
end, { desc = 'Update Go modules via nvim-helper' })

return M
