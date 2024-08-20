-- Adding shortcut to save current file and open k9s
vim.api.nvim_set_keymap('n', '<leader>k', ':lua ToggleK9Terminal()<CR>', { noremap = true, silent = true })

-- Function to find the terminal buffer labeled as "k9s"
function FindK9TerminalBuffer()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(buf) and vim.b[buf].is_k9_terminal then
			return buf
		end
	end
	return nil
end

-- Function to open a new terminal buffer and run the server
function OpenK9Terminal()
	-- Open a new buffer and start a terminal
	vim.cmd('te k9s')
	vim.b.is_k9_terminal = true
end

function ToggleK9Terminal()
	local buf = FindK9TerminalBuffer()
	if buf then
		vim.api.nvim_set_current_buf(buf)
	else
		OpenK9Terminal()
	end
end
