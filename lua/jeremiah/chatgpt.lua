-- Adding shortcut to save current file and open chatgpt
vim.api.nvim_set_keymap('n', '<leader>cc', ':lua ToggleChatGptTerminal("default")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>CC', ':lua ToggleChatGptTerminal("super")<CR>', { noremap = true, silent = true })

local function ChatGptTerminalId(id)
	return 'chatgpt:' .. (id or 'default')
end

local function ChatGptTerminalCommand(id)
	local mode = id or 'default'
	if mode == 'super' then
		return '/home/linuxbrew/.linuxbrew/bin/codex'
	end
	return '/home/piegarden/go/bin/crush'
end

-- Function to find the terminal buffer labeled as "chatgpt"
function FindChatGptTerminalBuffer(id)
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(buf) then
			local success, term_id = pcall(vim.api.nvim_buf_get_var, buf, 'term_id')
			if success and term_id == ChatGptTerminalId(id) then
				return buf
			end
		end
	end
	return nil
end

-- Function to open a new terminal buffer and run the server
function OpenChatGptTerminal(id)
	-- Open a new buffer and start a terminal
	vim.cmd('te ' .. ChatGptTerminalCommand(id))
	vim.b.term_id = ChatGptTerminalId(id)
end

function ToggleChatGptTerminal(id)
	jeremiah.utils.SaveAll()
	local buf = FindChatGptTerminalBuffer(id)
	if buf then
		vim.api.nvim_set_current_buf(buf)
	else
		OpenChatGptTerminal(id)
	end
end
