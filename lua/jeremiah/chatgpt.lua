-- Adding shortcut to save current file and open chatgpt
vim.api.nvim_set_keymap('n', '<leader>cc', ':lua ToggleChatGptTerminal()<CR>', { noremap = true, silent = true })

-- Function to open a new terminal buffer and run the server
function OpenChatGptTerminal()
	jeremiah.utils.OpenTerminalTabKind('/home/linuxbrew/.linuxbrew/bin/codex', 'chatgpt')
end

function ToggleChatGptTerminal()
	jeremiah.utils.SaveAll()
	local buf = jeremiah.utils.FindTerminalBuffer('chatgpt')
	if buf then
		jeremiah.utils.FocusBufferInTab(buf)
	else
		OpenChatGptTerminal()
	end
end
