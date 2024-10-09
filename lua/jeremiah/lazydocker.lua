-- Adding shortcut to save current file and open lazydocker
vim.api.nvim_set_keymap('n', '<leader>ld', ':lua ToggleLazyDockerTerminal()<CR>', { noremap = true, silent = true })

-- Function to find the terminal buffer labeled as "lazydocker"
function FindLazydockerTerminalBuffer()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(buf) and vim.b[buf].is_lazydocker_terminal then
			return buf
		end
	end
	return nil
end

-- Function to open a new terminal buffer and run the server
function OpenLazydockerTerminal()
	-- Open a new buffer and start a terminal
	vim.cmd('te lazydocker')
	vim.b.is_lazydocker_terminal = true
end

function ToggleLazyDockerTerminal()
	jeremiah.utils.SaveAll()
	local buf = FindLazydockerTerminalBuffer()
	if buf then
		vim.api.nvim_set_current_buf(buf)
	else
		OpenLazydockerTerminal()
	end
end
