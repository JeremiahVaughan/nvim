-- Key mapping to toggle (start/restart) the server
vim.api.nvim_set_keymap('n', '<leader>t', ':lua ToggleQuickTerminal("b")<CR>', { noremap = true, silent = true })

-- The other way to handle this flow is to add watchers to trigger rebuids on file saves. 
-- However this tempts you to not check the startup logs and go strait to the browser to see changes. 
-- This causes a lot of confusion because if the startup fails or encounters issues like failed template parsing, the browser tries to pretend like everything is ok (half rendering, no page refresh, etc).
vim.api.nvim_set_keymap('n', '<leader>r', ':lua RebuildQuickTerminal("b")<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>rr', ':lua ToggleQuickTerminal("r")<CR>', { noremap = true, silent = true })

local function FindQuickTerminalWindow(buf)
	for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
			if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == buf then
				return { tab = tab, win = win }
			end
		end
	end
	return nil
end

-- Function to open a new terminal buffer and run the server
function OpenQuickTerminal(label)
	-- Open a new tab and start a terminal
	vim.cmd('tabnew')
	vim.cmd('term')
	-- Label this terminal buffer as "server"
	vim.b.term_id = label
end

-- Function to find the terminal buffer labeled as "server"
function FindServerTerminalBuffer(label)
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(buf) then
			local success, buf_label = pcall(vim.api.nvim_buf_get_var, buf, 'term_id')
			if success and buf_label == label then
				return buf
			end
		end
	end
	return nil
end

-- Function to toggle the server state (start or restart)
function ToggleQuickTerminal(label)
	jeremiah.utils.SaveAll()
	local buf = FindServerTerminalBuffer(label)
	if buf then
		local location = FindQuickTerminalWindow(buf)
		if location then
			vim.api.nvim_set_current_tabpage(location.tab)
			vim.api.nvim_set_current_win(location.win)
		else
			vim.cmd('tabnew')
			vim.api.nvim_set_current_buf(buf)
		end
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
	local buf = FindServerTerminalBuffer(label)
	if buf then
		local location = FindQuickTerminalWindow(buf)
		if location then
			vim.api.nvim_set_current_tabpage(location.tab)
			vim.api.nvim_set_current_win(location.win)
		else
			vim.cmd('tabnew')
			vim.api.nvim_set_current_buf(buf)
		end
		SendToTerminal(buf, '\x03')
	else
		OpenQuickTerminal(label)
		buf = vim.api.nvim_get_current_buf()
	end
	vim.defer_fn(function()
		SendToTerminal(buf, 'make b\n')
	end, 50)
end
