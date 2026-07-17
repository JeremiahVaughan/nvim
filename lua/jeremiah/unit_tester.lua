local M = {}

local function safe_json_decode(line)
    if vim.json and vim.json.decode then
        return vim.json.decode(line)
    end
    return vim.fn.json_decode(line)
end

local function debug_log(line)
    if not vim.g.unit_tester_debug then
        return
    end
    local log_path = '/tmp/unit_tester.log'
    local ts = os.date('%Y-%m-%d %H:%M:%S')
    vim.fn.writefile({ ('[%s] %s'):format(ts, line) }, log_path, 'a')
end

local function find_project_file_from_cwd(name)
    local cwd = vim.fn.getcwd()
    if vim.fs and vim.fs.find then
        local matches = vim.fs.find(name, { path = cwd, upward = true, type = 'file' })
        return matches[1] ~= nil
    end

    return vim.fn.findfile(name, cwd .. ';') ~= ''
end

local function is_rust_project()
    if vim.fn.executable('cargo') == 0 then
        return false
    end
    return find_project_file_from_cwd('Cargo.toml')
end

local function find_terminal_buf(label)
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) then
            local ok, buf_label = pcall(vim.api.nvim_buf_get_var, buf, 'term_id')
            if ok and buf_label == label then
                return buf
            end
        end
    end
    return nil
end

local function cleanup_terminal(label)
    local buf = find_terminal_buf(label)
    if not buf or not vim.api.nvim_buf_is_valid(buf) then
        return
    end
    local ok_job, existing_job = pcall(vim.api.nvim_buf_get_var, buf, 'terminal_job_id')
    if ok_job and existing_job and existing_job > 0 then
        pcall(vim.fn.jobstop, existing_job)
    end
    local wins = vim.fn.win_findbuf(buf)
    for _, win in ipairs(wins) do
        if vim.api.nvim_win_is_valid(win) then
            pcall(vim.api.nvim_win_close, win, true)
        end
    end
    pcall(vim.api.nvim_buf_delete, buf, { force = true })
end

local function parse_test_output(lines)
    local qf = {}
    for _, line in ipairs(lines) do
        if line and line ~= '' then
            local file, lnum, col = line:match('([%w%._%-%/\\]+%.rs):(%d+):(%d+)')
            if not file then
                file, lnum = line:match('([%w%._%-%/\\]+%.rs):(%d+)')
                col = 1
            end
            if file and lnum then
                table.insert(qf, {
                    filename = file,
                    lnum = tonumber(lnum),
                    col = tonumber(col) or 1,
                    text = line,
                    type = 'E',
                })
            end
        end
    end
    return qf
end

local function run_cargo_tests_with_capture()
    local current_win = vim.api.nvim_get_current_win()
    vim.cmd('botright vsplit')
    local win = vim.api.nvim_get_current_win()
    local term_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(win, term_buf)
    pcall(vim.api.nvim_buf_set_var, term_buf, 'term_id', 'rust-unit-test')
    local output = {}
    local function on_output(_, data, _)
        if type(data) ~= 'table' then
            return
        end
        for _, line in ipairs(data) do
            if line and line ~= '' then
                table.insert(output, line)
            end
        end
    end

    local function on_exit(_, code, _)
        vim.schedule(function()
            if vim.api.nvim_win_is_valid(current_win) then
                vim.api.nvim_set_current_win(current_win)
                vim.cmd('stopinsert')
            end
            if vim.api.nvim_win_is_valid(win) then
                local line_count = vim.api.nvim_buf_line_count(term_buf)
                pcall(vim.api.nvim_win_set_cursor, win, { line_count, 0 })
            end
            local qf = parse_test_output(output)
            if #qf > 0 then
                vim.fn.setqflist(qf, 'r')
                vim.cmd('belowright copen')
                vim.cmd('cfirst')
            elseif code == 0 then
                vim.fn.setqflist({}, 'r')
                vim.cmd('cclose')
            else
                vim.fn.setqflist({}, 'r')
                vim.notify('Tests failed but no file:line could be parsed.', vim.log.levels.WARN)
            end
        end)
    end

    vim.api.nvim_set_current_win(win)
    local ok, job_id = pcall(vim.fn.termopen, { 'cargo', 'test', '--color=always' }, {
        on_stdout = on_output,
        on_stderr = on_output,
        on_exit = on_exit,
    })
    if not ok then
        local err = tostring(job_id)
        vim.notify('Failed to start cargo test terminal job: ' .. err, vim.log.levels.ERROR)
        debug_log('termopen_error: ' .. err)
        if vim.api.nvim_win_is_valid(current_win) then
            vim.api.nvim_set_current_win(current_win)
        end
        return
    end
    if job_id and job_id > 0 then
        vim.api.nvim_buf_set_var(term_buf, 'terminal_job_id', job_id)
    end
    if vim.api.nvim_win_is_valid(current_win) then
        vim.api.nvim_set_current_win(current_win)
    end
    if vim.api.nvim_win_is_valid(win) then
        local line_count = vim.api.nvim_buf_line_count(term_buf)
        pcall(vim.api.nvim_win_set_cursor, win, { line_count, 0 })
    end
end

local function parse_cargo_json(lines)
    local qf = {}
    local decoded_count = 0
    local json_error_count = 0
    local logged_error = false
    local reason_counts = {}
    local compiler_message_lines = 0
    local logged_compiler_line = false
    local logged_non_json = false
    for _, line in ipairs(lines) do
        if line ~= '' then
            if line:find('"compiler%-message"', 1, true) then
                compiler_message_lines = compiler_message_lines + 1
                if not logged_compiler_line then
                    logged_compiler_line = true
                    debug_log('compiler_line: ' .. line)
                end
            end
            local ok, decoded = pcall(safe_json_decode, line)
            if ok and type(decoded) == 'table' then
                local reason = decoded.reason or 'unknown'
                reason_counts[reason] = (reason_counts[reason] or 0) + 1
                if reason == 'build-finished' and decoded.success ~= nil then
                    debug_log('build_finished: ' .. tostring(decoded.success))
                end
                if reason == 'compiler-message' then
                    decoded_count = decoded_count + 1
                    local msg = decoded.message
                    if type(msg) == 'table' then
                        local spans = msg.spans or {}
                        local primary = nil
                        for _, span in ipairs(spans) do
                            if span.is_primary then
                                primary = span
                                break
                            end
                        end
                        if not primary then
                            primary = spans[1]
                        end
                        if primary and primary.file_name and primary.line_start then
                            local level = msg.level or ''
                            local qf_type = 'I'
                            if level == 'error' then
                                qf_type = 'E'
                            elseif level == 'warning' then
                                qf_type = 'W'
                            end
                            table.insert(qf, {
                                filename = primary.file_name,
                                lnum = primary.line_start,
                                col = primary.column_start or 1,
                                text = msg.message or 'Rust diagnostic',
                                type = qf_type,
                            })
                        end
                    end
                end
            else
                json_error_count = json_error_count + 1
                if not logged_error and line:sub(1, 1) == '{' then
                    logged_error = true
                    debug_log('decode_error: ' .. tostring(decoded))
                    debug_log('decode_line: ' .. line)
                end
                if not logged_non_json then
                    logged_non_json = true
                    debug_log('non_json_line: ' .. line)
                end
            end
        end
    end
    local reasons = {}
    for reason, count in pairs(reason_counts) do
        table.insert(reasons, ('%s=%d'):format(reason, count))
    end
    table.sort(reasons)
    debug_log(('parse: decoded=%d json_errors=%d qf=%d compiler_lines=%d reasons=%s'):format(decoded_count, json_error_count, #qf, compiler_message_lines, table.concat(reasons, ',')))
    return qf
end

local function run_cargo_quickfix()
    local cmd = 'cargo test --no-run --message-format=json --color=never 2>&1'
    debug_log('cmd: ' .. cmd)
    local lines = vim.fn.systemlist(cmd)
    local exit_code = vim.v.shell_error
    debug_log('exit: ' .. tostring(exit_code) .. ' lines: ' .. tostring(#lines))
    if #lines > 0 then
        debug_log('line0: ' .. tostring(lines[1]))
    end

    local qf = parse_cargo_json(lines)
    if #qf > 0 then
        vim.fn.setqflist(qf, 'r')
        vim.cmd('belowright copen')
        vim.cmd('cfirst')
    elseif exit_code == 0 then
        vim.fn.setqflist({}, 'r')
        vim.cmd('cclose')
    end
    return exit_code == 0
end

local function run_go_tests()
    if vim.fn.executable('go') == 0 then
        vim.notify('go executable not found', vim.log.levels.ERROR)
        return
    end

    pcall(vim.cmd, 'compiler go')
    local makeprg = 'go test ./...'
    vim.opt.makeprg = makeprg
    vim.notify(makeprg, vim.log.levels.INFO)
    vim.cmd('make')

    local exit_code = vim.v.shell_error
    local qf = vim.fn.getqflist({ size = 0 })
    if qf.size > 0 then
        vim.cmd('belowright copen')
        vim.cmd('cfirst')
    elseif exit_code == 0 then
        vim.cmd('cclose')
    else
        vim.notify('Tests failed but no file:line could be parsed.', vim.log.levels.WARN)
    end
end

function M.run()
    jeremiah.utils.SaveAll()
    if is_rust_project() then
        cleanup_terminal('rust-unit-test')
        local ok = run_cargo_quickfix()
        if ok then
            run_cargo_tests_with_capture()
        end
        return
    end

    run_go_tests()
end

vim.api.nvim_create_user_command('M', function()
    M.run()
end, { desc = 'Save buffers and run unit tests' })

return M
