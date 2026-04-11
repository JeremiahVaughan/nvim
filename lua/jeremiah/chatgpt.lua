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
	-- Open a new buffer and start a terminal
	-- vim.cmd('te /home/linuxbrew/.linuxbrew/bin/codex')
	vim.cmd('te /home/piegarden/go/bin/crush')
	vim.b.is_chatgpt_terminal = true
end

function ToggleChatGptTerminal()
	jeremiah.utils.SaveAll()
	local buf = FindChatGptTerminalBuffer()
	if buf then
		vim.api.nvim_set_current_buf(buf)
	else
		OpenChatGptTerminal()
	end
end
