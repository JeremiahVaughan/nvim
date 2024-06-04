local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local previewers = require('telescope.previewers')
local sorters = require('telescope.sorters')

function List_files_with_fzf()
    local script_path = debug.getinfo(1, 'S').source:match("@(.*)$")
    local plugin_dir = vim.fn.fnamemodify(script_path, ":h")
    local snip_dir = plugin_dir .. '/snippets'
    local files = vim.fn.readdir(snip_dir)

    pickers.new({}, {
        prompt_title = 'Select a file',
        finder = finders.new_table {
            results = files,
        },
        sorter = sorters.get_fuzzy_file(),
        previewer = previewers.new_termopen_previewer {
            get_command = function(entry)
                return { 'bat', '--style=numbers,changes', snip_dir .. '/' .. entry.value }
            end
        },
        attach_mappings = function(prompt_bufnr, map)
            local function on_select()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                local file_path = snip_dir .. '/' .. selection[1]
                local file = io.open(file_path, "r")
                if file then
                    local content = file:read("*all")
                    file:close()
                    -- Insert the content at the cursor location
                    vim.api.nvim_put(vim.split(content, '\n'), 'c', true, true)
                else
                    print("Could not read file: " .. file_path)
                end
            end

            map('i', '<CR>', on_select)
            map('n', '<CR>', on_select)

            return true
        end
    }):find()
end

-- Command to trigger the custom picker
vim.api.nvim_set_keymap('n', '<leader>ss', '<cmd>lua List_files_with_fzf()<CR>', { noremap = true, silent = true })

