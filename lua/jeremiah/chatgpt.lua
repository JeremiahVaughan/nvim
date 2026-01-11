-- Adding shortcut to save current file and open chatgpt
vim.api.nvim_set_keymap('n', '<leader>cc', ':lua ToggleChatGptTerminal()<CR>', { noremap = true, silent = true })

-- Function to find the terminal buffer labeled as "chatgpt"
function FindChatGptTerminalBuffer()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(buf) and vim.b[buf].is_chatgpt_terminal then
			return buf
		end
	end
	return nil
end

-- Function to open a new terminal buffer and run the server
function OpenChatGptTerminal()
	-- Open a new tab and start a terminal
	vim.cmd('tabnew')
	vim.cmd('te /home/linuxbrew/.linuxbrew/bin/codex')
	vim.b.is_chatgpt_terminal = true
end

local function FindChatGptTerminalWindow(buf)
	for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
			if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == buf then
				return { tab = tab, win = win }
			end
		end
	end
	return nil
end

function ToggleChatGptTerminal()
	jeremiah.utils.SaveAll()
	local buf = FindChatGptTerminalBuffer()
	if buf then
		local location = FindChatGptTerminalWindow(buf)
		if location then
			vim.api.nvim_set_current_tabpage(location.tab)
			vim.api.nvim_set_current_win(location.win)
		else
			vim.cmd('tabnew')
			vim.api.nvim_set_current_buf(buf)
		end
	else
		OpenChatGptTerminal()
	end
end
