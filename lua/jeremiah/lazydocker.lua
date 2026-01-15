-- Adding shortcut to save current file and open lazydocker
vim.api.nvim_set_keymap('n', '<leader>dd', ':lua ToggleLazyDockerTerminal()<CR>', { noremap = true, silent = true })

-- Function to find the terminal buffer labeled as "lazydocker"
function FindLazydockerTerminalBuffer()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(buf) and vim.b[buf].is_lazydocker_terminal then
			return buf
		end
	end
	return nil
end

local function FindLazydockerTerminalWindow(buf)
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
function OpenLazydockerTerminal()
	-- Open a new tab and start a terminal
	vim.cmd('tabnew')
	vim.cmd('te lazydocker')
	vim.b.is_lazydocker_terminal = true
end

function ToggleLazyDockerTerminal()
	jeremiah.utils.SaveAll()
	local buf = FindLazydockerTerminalBuffer()
	if buf then
		local location = FindLazydockerTerminalWindow(buf)
		if location then
			vim.api.nvim_set_current_tabpage(location.tab)
			vim.api.nvim_set_current_win(location.win)
		else
			vim.cmd('tabnew')
			vim.api.nvim_set_current_buf(buf)
		end
	else
		OpenLazydockerTerminal()
	end
end
