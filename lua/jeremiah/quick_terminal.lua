-- Key mapping to toggle (start/restart) the server
vim.api.nvim_set_keymap('n', '<leader>t', ':lua ToggleQuickTerminal("b")<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>rr', ':lua ToggleQuickTerminal("r")<CR>', { noremap = true, silent = true })

-- Function to open a new terminal buffer and run the server
function OpenQuickTerminal(label)
	-- Open a new buffer and start a terminal
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
		vim.api.nvim_set_current_buf(buf)
	else
		-- Server is not running, so start it
		OpenQuickTerminal(label)
	end
end
