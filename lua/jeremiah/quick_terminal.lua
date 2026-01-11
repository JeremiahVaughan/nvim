-- Key mapping to toggle (start/restart) the server
vim.api.nvim_set_keymap('n', '<leader>t', ':lua ToggleQuickTerminal("b")<CR>', { noremap = true, silent = true })

-- The other way to handle this flow is to add watchers to trigger rebuids on file saves. 
-- However this tempts you to not check the startup logs and go strait to the browser to see changes. 
-- This causes a lot of confusion because if the startup fails or encounters issues like failed template parsing, the browser tries to pretend like everything is ok (half rendering, no page refresh, etc).
vim.api.nvim_set_keymap('n', '<leader>r', ':lua RebuildQuickTerminal("b")<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>rr', ':lua ToggleQuickTerminal("r")<CR>', { noremap = true, silent = true })

-- Function to open a new terminal buffer and run the server
function OpenQuickTerminal(label)
	jeremiah.utils.OpenTerminalTabKind(nil, 'quick:' .. label)
end

-- Function to toggle the server state (start or restart)
function ToggleQuickTerminal(label)
	jeremiah.utils.SaveAll()
	local buf = jeremiah.utils.FindTerminalBuffer('quick:' .. label)
	if buf then
		jeremiah.utils.FocusBufferInTab(buf)
	else
		-- Server is not running, so start it
		OpenQuickTerminal(label)
	end
end

local function SendToTerminal(buf, text)
	local ok, job_id = pcall(vim.api.nvim_buf_get_var, buf, 'terminal_job_id')
	if not ok then
		return
	end
	vim.api.nvim_chan_send(job_id, text)
end

function RebuildQuickTerminal(label)
	jeremiah.utils.SaveAll()
	local buf = jeremiah.utils.FindTerminalBuffer('quick:' .. label)
	if buf then
		jeremiah.utils.FocusBufferInTab(buf)
		SendToTerminal(buf, '\x03')
	else
		OpenQuickTerminal(label)
		buf = vim.api.nvim_get_current_buf()
	end
	vim.defer_fn(function()
		SendToTerminal(buf, 'make b\n')
	end, 50)
end
