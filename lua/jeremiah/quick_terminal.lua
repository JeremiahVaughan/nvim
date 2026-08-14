-- Key mapping to toggle (start/restart) the server
vim.api.nvim_set_keymap('n', '<leader>t', ':lua ToggleQuickTerminal("b")<CR>', { noremap = true, silent = true })

-- The other way to handle this flow is to add watchers to trigger rebuids on file saves. 
-- However this tempts you to not check the startup logs and go strait to the browser to see changes. 
-- This causes a lot of confusion because if the startup fails or encounters issues like failed template parsing, the browser tries to pretend like everything is ok (half rendering, no page refresh, etc).
vim.api.nvim_set_keymap('n', '<leader>r', ':lua RebuildQuickTerminal("b")<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>rr', ':lua ToggleQuickTerminal("r")<CR>', { noremap = true, silent = true })

local QUICK_TERMINAL_VAR_PREFIX = 'jeremiah_quick_terminal_'

local function quick_terminal_var(label)
	return QUICK_TERMINAL_VAR_PREFIX .. label .. '_buf'
end

-- Function to find the terminal buffer labeled as "server"
local function get_quick_terminal_buf(label)
	local buf = vim.t[quick_terminal_var(label)]
	if type(buf) == 'number' and vim.api.nvim_buf_is_valid(buf) then
		return buf
	end

	vim.t[quick_terminal_var(label)] = nil
	return nil
end

local function set_quick_terminal_buf(label, buf)
	vim.t[quick_terminal_var(label)] = buf
end

-- Function to open a new terminal buffer and run the server
function OpenQuickTerminal(label)
	-- Open a new buffer and start a terminal
	vim.cmd('term')
	-- Label this terminal buffer as "server"
	vim.b.term_id = label
	set_quick_terminal_buf(label, vim.api.nvim_get_current_buf())
end

-- Function to toggle the server state (start or restart)
function ToggleQuickTerminal(label)
	jeremiah.utils.SaveAll()
	local buf = get_quick_terminal_buf(label)
	if buf then
		vim.api.nvim_set_current_buf(buf)
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
	local buf = get_quick_terminal_buf(label)
	if buf then
		vim.api.nvim_set_current_buf(buf)
		SendToTerminal(buf, '\x03')
	else
		OpenQuickTerminal(label)
		buf = vim.api.nvim_get_current_buf()
	end
	SendToTerminal(buf, ' make -j"$(nproc)" b\n') -- Adding a space at the beginning of the command because for some reason (probably timing) the first char is getting cut off
end
